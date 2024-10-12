import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:urbun_guide/models/weather_model.dart';
import 'package:intl/intl.dart';

class Weathermain extends StatefulWidget {
  final String selectedCity;
  final String apiKey;

  Weathermain({required this.selectedCity, required this.apiKey});

  @override
  _WeathermainState createState() => _WeathermainState();
}

class _WeathermainState extends State<Weathermain> {
  Weather? currentWeather;
  List<HourlyForecast> hourlyForecasts = [];
  List<DailyForecast> dailyForecasts = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    String weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=${widget.selectedCity}&appid=${widget.apiKey}&units=metric';
    String forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=${widget.selectedCity}&appid=${widget.apiKey}&units=metric';

    final weatherResponse = await http.get(Uri.parse(weatherUrl));
    final forecastResponse = await http.get(Uri.parse(forecastUrl));

    if (weatherResponse.statusCode == 200) {
      setState(() {
        currentWeather = Weather.fromJson(json.decode(weatherResponse.body));
      });
    }

    if (forecastResponse.statusCode == 200) {
      final forecastData = json.decode(forecastResponse.body);
      setState(() {
        hourlyForecasts = forecastData['list']
            .map<HourlyForecast>((item) => HourlyForecast.fromJson(item))
            .toList()
            .cast<HourlyForecast>();

        dailyForecasts = forecastData['list']
            .map<DailyForecast>((item) => DailyForecast.fromJson(item))
            .toList()
            .cast<DailyForecast>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              if (currentWeather != null) _buildCurrentWeatherSection(),
              if (hourlyForecasts.isNotEmpty) _buildHourlyForecast(),
              if (dailyForecasts.isNotEmpty) _buildWeeklyForecast(),
              if (currentWeather != null) _buildCurrentConditions(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF192046),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.selectedCity,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/placeholder_avatar.png'), // Replace with your image asset
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for a city or a region',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Icon(Icons.search),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Now',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            DateFormat('EEEE | h:mm a').format(DateTime.now()),
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '${currentWeather!.temperature}°C',
            style: TextStyle(
              color: Colors.black,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            currentWeather!.description,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forecast for the next hours',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: hourlyForecasts.map((hour) {
              return Column(
                children: [
                  Image.network(
                    'http://openweathermap.org/img/wn/${hour.icon}@2x.png',
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(height: 8),
                  Text(hour.time),
                  SizedBox(height: 8),
                  Text('${hour.temperature}°C'),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyForecast() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Predictions for the upcoming week',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Column(
            children: dailyForecasts.map((day) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(day.date),
                  Row(
                    children: [
                      Image.network(
                        'http://openweathermap.org/img/wn/${day.icon}@2x.png',
                        width: 32,
                        height: 32,
                      ),
                      SizedBox(width: 8),
                      Text('${day.minTemp}°C / ${day.maxTemp}°C'),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentConditions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Conditions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Wind Speed: ${currentWeather!.windSpeed} m/s'),
          Text('Humidity: ${currentWeather!.humidity}%'),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
