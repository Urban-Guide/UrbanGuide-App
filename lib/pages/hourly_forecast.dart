import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HourlyForecastPage extends StatefulWidget {
  final String city;
  final String apiKey;

  HourlyForecastPage({required this.city, required this.apiKey});

  @override
  _HourlyForecastPageState createState() => _HourlyForecastPageState();
}

class _HourlyForecastPageState extends State<HourlyForecastPage> {
  List<dynamic> hourlyData = [];

  @override
  void initState() {
    super.initState();
    fetchHourlyForecast(
        widget.city); // Fetch hourly forecast for the selected city
  }

  Future<void> fetchHourlyForecast(String city) async {
    // Extract city name (before the comma) for API request
    String cityName = city.split(',')[0];
    String url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=${widget.apiKey}&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          hourlyData = data['list']; // Store the hourly forecast data
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching hourly forecast: $e');
    }
  }

  // Function to determine background image based on weather description
  String getBackgroundImage(String weatherDescription) {
    if (weatherDescription.contains('clear')) {
      return 'assets/sunny.png';
    } else if (weatherDescription.contains('cloud')) {
      return 'assets/cloudy.png';
    } else if (weatherDescription.contains('rain')) {
      return 'assets/rainy.png';
    } else {
      return 'assets/default.png'; // Use a default image if no match
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hourly Forecast',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          if (hourlyData.isNotEmpty)
            Container(
              height: 120, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hourlyData.length,
                itemBuilder: (context, index) {
                  final hourData = hourlyData[index];
                  final dateTime = DateTime.fromMillisecondsSinceEpoch(
                      hourData['dt'] * 1000);
                  String weatherDescription =
                      hourData['weather'][0]['main'].toLowerCase();
                  String backgroundImage =
                      getBackgroundImage(weatherDescription);

                  return Container(
                    width: 80, // Adjust width as needed
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(backgroundImage),
                        fit: BoxFit
                            .cover, // Fit the image to cover the container
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        // Black overlay for better text visibility
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                                0.5), // 50% transparent black overlay
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // Center horizontally
                          children: [
                            Text(
                              DateFormat('h a').format(dateTime), // Format time
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              textAlign: TextAlign.center, // Center align text
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${hourData['main']['temp']}°C', // Temperature
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              textAlign: TextAlign.center, // Center align text
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
