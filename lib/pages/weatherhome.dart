import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:urbun_guide/pages/hourly_forecast.dart';
import 'package:urbun_guide/pages/daily_forecast.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String selectedCity = 'Colombo, LK';
  List<String> cities = ['Colombo, LK', 'New York, US', 'Galle, LK'];

  // To store the fetched weather data
  Map<String, dynamic> weatherData = {};

  // To store the fetched daily forecast data
  List<dynamic> dailyForecastData = [];

  // To store the fetched air quality data
  Map<String, dynamic> airQualityData = {};

  String apiKey = '193cb743af1b3702d849b4c3e2cc3faf';

  @override
  void initState() {
    super.initState();
    fetchWeather(selectedCity); // Fetch weather for the default city
  }

  Future<void> fetchWeather(String city) async {
    String cityName = city.split(',')[0];
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
        });
        fetchDailyForecast(
            cityName); // Fetch daily forecast after getting current weather
      } else {
        print('Error: ${response.reasonPhrase}');
        setState(() {
          weatherData = {}; // Clear data if request fails
        });
      }
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        weatherData = {}; // Clear data if request fails
      });
    }
  }

  Future<void> fetchDailyForecast(String cityName) async {
    if (weatherData['coord'] == null) {
      print('Error: Coordinates not available');
      return; // Exit if coordinates are not available
    }

    String url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=${weatherData['coord']['lat']}&lon=${weatherData['coord']['lon']}&exclude=hourly,minutely&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final forecastData = json.decode(response.body);
        if (mounted) {
          setState(() {
            dailyForecastData =
                forecastData['daily']; // Store daily forecast data
            // Ensure air quality data is fetched from the correct endpoint if needed
            // airQualityData = forecastData['current']['air_quality'];
          });
        }
        print(dailyForecastData); // Debugging: Check if data is fetched
      } else {
        print('Error fetching daily forecast: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching daily forecast: $e');
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
              _buildCurrentWeather(),
              if (weatherData.isNotEmpty)
                HourlyForecastPage(
                  city: selectedCity,
                  apiKey: apiKey,
                ),
              if (weatherData.isNotEmpty)
                DailyForecast(
                  city: selectedCity,
                  apiKey: apiKey,
                ),
              _buildCurrentConditions(), // Add current conditions here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E2A5E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16), // Round bottom left corner
          bottomRight: Radius.circular(16), // Round bottom right corner
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedCity,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/placeholder_avatar.png'), // Use AssetImage here
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
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCity,
                icon: Icon(Icons.search),
                isExpanded: true,
                hint: Text('Search for a city or a region'),
                items: cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCity = newValue;
                    });
                    fetchWeather(
                        newValue); // Fetch new weather data for the selected city
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    if (weatherData.isNotEmpty && weatherData['main'] != null) {
      // Get the UTC time and adjust it according to the city's timezone
      int timezoneOffset =
          weatherData['timezone']; // Timezone offset in seconds
      DateTime currentUtcTime = DateTime.now().toUtc(); // Current UTC time
      DateTime localTime = currentUtcTime
          .add(Duration(seconds: timezoneOffset)); // Adjust to local time

      // Get the weather description to determine the background image
      String weatherDescription =
          weatherData['weather'][0]['main'].toLowerCase();

      // Determine the background image based on weather
      String backgroundImage;
      if (weatherDescription.contains('clear')) {
        backgroundImage = 'assets/sunny.png';
      } else if (weatherDescription.contains('cloud')) {
        backgroundImage = 'assets/cloudy.png';
      } else if (weatherDescription.contains('rain')) {
        backgroundImage = 'assets/rainy.png';
      } else {
        backgroundImage =
            'assets/default.png'; // Use a default image if no match
      }

      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        width: 450, // Set width for the container
        height: 250, // Set height for the container
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover, // Fit the image to cover the container
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            // Black overlay
            Container(
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.2), // 20% transparent black overlay
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            // Right-aligned content with padding
            Align(
              alignment: Alignment.centerLeft, // Align to the right
              child: Padding(
                padding: const EdgeInsets.only(left: 16), // Add right padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.end, // Align text to the right
                  children: [
                    Text(
                      DateFormat('EEEE | h:mm a')
                          .format(localTime), // Display local time
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      '${weatherData['main']['temp']}°C',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weatherData['weather'][0]['description'],
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  /* Widget _buildCurrentWeatherDetails() {
    return Column(
      children: [
        if (weatherData.containsKey('main') && weatherData['main'] != null)
          Text("Humidity: ${weatherData['main']['humidity']}%"),
        if (weatherData.containsKey('wind') && weatherData['wind'] != null)
          Text("Wind Speed: ${weatherData['wind']['speed']} m/s"),
      ],
    );
  }*/

  Widget _buildCurrentConditions() {
    if (weatherData.isNotEmpty && weatherData['main'] != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Conditions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            // Use GridView to display conditions in two columns
            GridView.count(
              shrinkWrap: true, // To avoid infinite height error
              physics: NeverScrollableScrollPhysics(), // Disable scrolling
              crossAxisCount: 2, // 2 boxes in each row
              childAspectRatio:
                  1.5, // Adjusts the height/width ratio of the boxes
              crossAxisSpacing: 16, // Space between columns
              mainAxisSpacing: 16, // Space between rows
              children: [
                _buildConditionBox(
                    "Humidity",
                    "${weatherData['main']['humidity']}%",
                    'assets/humidity.png'),
                _buildConditionBox("Wind Speed",
                    "${weatherData['wind']['speed']} m/s", 'assets/wind.gif'),
                _buildConditionBox(
                    "Pressure",
                    "${weatherData['main']['pressure']} hPa",
                    'assets/pressure.png'),
                _buildConditionBox("Air Quality",
                    "${airQualityData['aqi'] ?? 'N/A'}", 'assets/quality.png'),
              ],
            ),
            SizedBox(
                height: 48), // Add a SizedBox for white space below the grid
          ],
        ),
      );
    } else {
      return SizedBox.shrink(); // Return an empty widget if there's no data
    }
  }

// Helper function to build condition boxes
  // Helper function to build condition boxes
  Widget _buildConditionBox(String title, String value, String imagePath) {
    return Container(
      padding: EdgeInsets.all(16), // Add padding inside the box
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Light shadow for depth
            blurRadius: 4,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.start, // Align content to the start
        children: [
          // Image or GIF
          Image.asset(
            imagePath,
            height: 40, // Set the height of the image
            width: 40, // Set the width of the image
            fit: BoxFit.cover, // Fit the image to the container
          ),
          SizedBox(width: 8), // Space between the image and the text
          Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the left
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold)), // Title styling
              SizedBox(height: 8), // Space between title and value
              Text(value, style: TextStyle(fontSize: 16)), // Value styling
            ],
          ),
        ],
      ),
    );
  }
}
