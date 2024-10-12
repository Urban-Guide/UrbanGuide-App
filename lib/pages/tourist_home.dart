import 'package:flutter/material.dart';
import 'package:urbun_guide/models/tabs.dart';
import 'package:urbun_guide/pages/profile_page.dart';

class TouristHome extends StatefulWidget {
  const TouristHome({super.key});

  @override
  _TouristHomeState createState() => _TouristHomeState();
}

class _TouristHomeState extends State<TouristHome> {
  String selectedCity = "Galle, LK"; // Default city
  final List<String> cities = [
    "Galle, LK",
    "Colombo, LK"
  ]; // Add more cities as needed
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1E2A5E),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          title: Row(
            children: [
              // Dropdown for selecting city
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                  child: DropdownButton<String>(
                    value: selectedCity,
                    onChanged: (String? newCity) {
                      setState(() {
                        selectedCity = newCity!;
                      });
                    },
                    items: cities.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(
                          city,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    dropdownColor: const Color(
                        0xff1E2A5E), // Dropdown color matching app bar
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    underline: Container(), // Removes underline
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to the Profile Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
                child: const Icon(Icons.person_outlined,
                    color: Colors.white, size: 35.0),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 10.0,
                bottom: 20.0,
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query.toLowerCase(); // Update search query
                  });
                },
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Nature'),
                Tab(text: 'Historical'),
                Tab(text: 'Fun'),
              ],
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: TabBarView(
                children: [
                  AllTab(city: selectedCity),
                  NatureTab(city: selectedCity, searchQuery: searchQuery),
                  HistoricalTab(city: selectedCity, searchQuery: searchQuery),
                  EntertainmentTab(
                      city: selectedCity, searchQuery: searchQuery),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
