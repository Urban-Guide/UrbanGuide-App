import 'package:flutter/material.dart';
import 'package:urbun_guide/models/cards.dart'; // Assuming PlaceCard and RecommendPlaceCard are defined here
import 'package:urbun_guide/models/place.dart'; // Assuming Place model is defined here

class AllTab extends StatelessWidget {
  final String city; // Add city field

  const AllTab({required this.city, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 10.0),
          child: Text(
            "Most Popular Places",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Filter places based on the selected city
        for (var place in places.where((p) => p.city == city).take(1))
          PlaceCard(
            number: place.number,
            image: place.mainImage,
            title: place.title,
            subtitle: place.details,
          ),
        const SizedBox(height: 20.0),
        const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 10.0),
          child: Text(
            "Recommended Places For You",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 200.0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Filter recommended places based on the city
                for (var place in places.where((p) => p.city == city).take(3))
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
    );
  }
}


class NatureTab extends StatelessWidget {
  final String city;
  final String searchQuery; // Add searchQuery field

  const NatureTab({required this.city, required this.searchQuery, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var place in places.where((p) =>
            p.type == "Nature" &&
            p.city == city &&
            (p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
             p.details.toLowerCase().contains(searchQuery.toLowerCase()))))
          PlaceCard(
            number: place.number,
            image: place.mainImage,
            title: place.title,
            subtitle: place.details,
          ),
      ],
    );
  }
}

class HistoricalTab extends StatelessWidget {
  final String city;
  final String searchQuery; // Add searchQuery field

  const HistoricalTab({required this.city, required this.searchQuery, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var place in places.where((p) =>
            p.type == "Historical" &&
            p.city == city &&
            (p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
             p.details.toLowerCase().contains(searchQuery.toLowerCase()))))
          PlaceCard(
            number: place.number,
            image: place.mainImage,
            title: place.title,
            subtitle: place.details,
          ),
      ],
    );
  }
}

class EntertainmentTab extends StatelessWidget {
  final String city;
  final String searchQuery; // Add searchQuery field

  const EntertainmentTab({required this.city, required this.searchQuery, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var place in places.where((p) =>
            p.type == "Fun" &&
            p.city == city &&
            (p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
             p.details.toLowerCase().contains(searchQuery.toLowerCase()))))
          PlaceCard(
            number: place.number,
            image: place.mainImage,
            title: place.title,
            subtitle: place.details,
          ),
      ],
    );
  }
}