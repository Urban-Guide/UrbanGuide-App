import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:urbun_guide/pages/profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:urbun_guide/models/cards.dart';
import 'package:urbun_guide/models/place.dart';
import 'package:urbun_guide/p_transpotation/screens/bus.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  // Define variables to store weather data and city selection
  String selectedCity = 'Colombo, LK'; // Default city
  List<String> cityOptions = [
    'Colombo, LK',
    'Galle, LK'
  ]; // Dropdown city options
  Map<String, dynamic> weatherData = {}; // Store current weather data
  String apiKey = '193cb743af1b3702d849b4c3e2cc3faf'; // Your API key
  String dropdownValue = 'Highway'; // Default dropdown value for bus routes

  // Firestore collection reference for bus routes
  final CollectionReference busCollection =
      FirebaseFirestore.instance.collection('bus');

  @override
  void initState() {
    super.initState();
    fetchWeather(selectedCity); // Fetch weather on page load
  }

  // Function to fetch bus routes based on the category from Firestore
  Future<List<Map<String, String>>> fetchBusRoutes(String category) async {
    QuerySnapshot snapshot = await busCollection.get();
    List<Map<String, String>> busRoutes = [];

    snapshot.docs.forEach((doc) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['type'] == category) {
        busRoutes.add({
          'routeNumber': data['routeNumber'] ?? '',
          'destination': data['destination'] ?? '',
        });
      }
    });

    return busRoutes;
  }

  // Function to fetch current weather data from API
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

  // Header with city selection and profile icon
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
                selectedCity,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/placeholder_avatar.png'),
                ),
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
                isExpanded: true,
                icon: Icon(Icons.search),
                hint: Text('Search for a city or a region'),
                value: selectedCity,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCity = newValue;
                    });
                    fetchWeather(
                        selectedCity); // Fetch new weather data for the selected city
                  }
                },
                items:
                    cityOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Current weather widget
  Widget _buildCurrentWeather() {
    if (weatherData.isNotEmpty && weatherData['main'] != null) {
      int timezoneOffset = weatherData['timezone'];
      DateTime currentUtcTime = DateTime.now().toUtc();
      DateTime localTime =
          currentUtcTime.add(Duration(seconds: timezoneOffset));

      String weatherDescription =
          weatherData['weather'][0]['main'].toLowerCase();
      String backgroundImage;

      // Set background image based on weather description
      if (weatherDescription.contains('clear')) {
        backgroundImage = 'assets/sunny.png';
      } else if (weatherDescription.contains('cloud')) {
        backgroundImage = 'assets/cloudy.png';
      } else if (weatherDescription.contains('rain')) {
        backgroundImage = 'assets/rainy.png';
      } else {
        backgroundImage = 'assets/default.png';
      }

      return Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        width:
            MediaQuery.of(context).size.width * 1.0, // 100% of the screen width
        height: 250,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE | h:mm a').format(localTime),
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

  // Recommended places widget
  Widget _buildRecommendedPlaces() {
    List<Place> recommendedPlaces = places
        .where((p) => p.city == selectedCity)
        .toList(); // Adjust according to your data structure
    return Container(
      margin: const EdgeInsets.only(left: 16.0), // Add left margin here
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 10.0), // Remove left padding
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align text to the left
              children: const [
                Text(
                  "Popular Places",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 200.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var place in recommendedPlaces.take(3))
                    RecommendPlaceCard(
                      number: place.number,
                      image: place.mainImage,
                      title: place.title,
                      subtitle: place.details,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display bus routes
  // Modify the _buildBusRoutes method to include the header text
  Widget _buildBusRoutes() {
    return FutureBuilder<List<Map<String, String>>>(
      // Make the call to fetch bus routes
      future: fetchBusRoutes(dropdownValue),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, String>> busRoutes = snapshot.data ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Recommended Routes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: busRoutes.length,
                  itemBuilder: (context, index) {
                    final bus = busRoutes[index];
                    return BusRouteCard(
                      routeNumber: bus['routeNumber']!,
                      destination: bus['destination']!,
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

// Main build method for the Home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Urban Guide')),
      body: ListView(
        children: [
          _buildHeader(),
          _buildCurrentWeather(),
          _buildRecommendedPlaces(),
          SizedBox(height: 20),
          Container(
            height: 300, // Set a height for the bus routes section
            child: _buildBusRoutes(),
          ),
        ],
      ),
    );
  }
}
