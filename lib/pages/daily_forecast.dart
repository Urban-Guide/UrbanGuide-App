import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class DailyForecast extends StatefulWidget {
  final String city;
  final String apiKey;

  DailyForecast({required this.city, required this.apiKey});

  @override
  _DailyForecastState createState() => _DailyForecastState();
}

class _DailyForecastState extends State<DailyForecast> {
  List<dynamic> _forecast = [];
  Map<String, dynamic> _currentConditions = {};

  @override
  void initState() {
    super.initState();
    fetchDailyForecast();
  }

  Future<void> fetchDailyForecast() async {
    String cityName = widget.city.split(',')[0]; // Extract city name
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=${widget.apiKey}&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        double lat = data['coord']['lat'];
        double lon = data['coord']['lon'];

        // Fetch daily forecast using One Call API 3.0
        String forecastUrl =
            'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,alerts&appid=${widget.apiKey}&units=metric';

        final forecastResponse = await http.get(Uri.parse(forecastUrl));

        if (forecastResponse.statusCode == 200) {
          var forecastData = json.decode(forecastResponse.body);
          print('Forecast Data: $forecastData'); // Debugging line
          setState(() {
            _forecast = forecastData['daily'];
            _currentConditions =
                forecastData['current']; // Get current conditions
          });
        } else {
          print('Error fetching forecast: ${forecastResponse.reasonPhrase}');
        }
      } else {
        print('Error fetching weather data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching daily forecast: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '7-Day Forecast',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 300, // Adjust height as needed for vertical list
            child: ListView.builder(
              itemCount: _forecast.length,
              itemBuilder: (context, index) {
                var forecast = _forecast[index];
                var date =
                    DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
                var dayName = DateFormat('E')
                    .format(date); // Get day name (e.g., Mon, Tue)
                var iconCode = forecast['weather'][0]['icon'];
                var iconUrl =
                    'https://openweathermap.org/img/wn/$iconCode@2x.png';

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dayName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Image.network(iconUrl, width: 40, height: 40),
                      Text('${forecast['temp']['day'].round()}°C'),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Current Conditions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          if (_currentConditions.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Temperature: ${_currentConditions['temp']}°C',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Humidity: ${_currentConditions['humidity']}%',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Pressure: ${_currentConditions['pressure']} hPa',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Wind Speed: ${_currentConditions['wind_speed']} m/s',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
