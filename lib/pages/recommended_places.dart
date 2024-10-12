import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendedPlaces extends StatefulWidget {
  final String city;

  const RecommendedPlaces({Key? key, required this.city}) : super(key: key);

  @override
  _RecommendedPlacesState createState() => _RecommendedPlacesState();
}

class _RecommendedPlacesState extends State<RecommendedPlaces> {
  List<dynamic> recommendedPlaces = []; // Store recommended places

  @override
  void initState() {
    super.initState();
    fetchRecommendedPlaces(widget.city); // Fetch recommended places on init
  }

  Future<void> fetchRecommendedPlaces(String city) async {
    // Replace this with your actual API endpoint
    String url = 'https://api.example.com/recommended?city=$city';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          recommendedPlaces = json.decode(response.body);
        });
      } else {
        print('Error fetching recommended places: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching recommended places: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Places for You',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          recommendedPlaces.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recommendedPlaces.length,
                  itemBuilder: (context, index) {
                    final place = recommendedPlaces[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(place['name']),
                        subtitle: Text(place['description']),
                        trailing: Text('${place['rating']} ⭐'),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
