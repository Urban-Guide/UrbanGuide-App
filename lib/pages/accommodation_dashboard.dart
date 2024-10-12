import 'package:flutter/material.dart';
import 'package:urbun_guide/widgets/accom_filter_dialog.dart';
import '../models/accommodation.dart';
import '../widgets/accom_item.dart';

class AccommodationsPage extends StatefulWidget {
  @override
  _AccommodationsPageState createState() => _AccommodationsPageState();
}

class _AccommodationsPageState extends State<AccommodationsPage> {
  List<Accommodation> allAccommodations = [
    Accommodation(
        id: 'A100',
        name: 'Kubuk Villa',
        location: 'Galle',
        pricePerNight: 10000.0,
        imageUrl: 'assets/images/acco2.jpg',
        accommodationType: 'Villa'),
    Accommodation(
        id: 'A101',
        name: 'Water Villa',
        location: 'Colombo',
        pricePerNight: 5000.0,
        imageUrl: 'assets/images/acco1.jpg',
        accommodationType: 'Villa'),
    Accommodation(
        id: 'A102',
        name: 'Flower Villa',
        location: 'Galle',
        pricePerNight: 6000.0,
        imageUrl: 'assets/images/acco3.jpg',
        accommodationType: 'Villa'),
    Accommodation(
        id: 'A103',
        name: 'Oceanview Hostel',
        location: 'Colombo',
        pricePerNight: 10000.0,
        imageUrl: 'assets/images/acco4.jpg',
        accommodationType: 'Hostel'),
    Accommodation(
        id: 'A104',
        name: 'Antique Villa',
        location: 'Galle',
        pricePerNight: 8000.0,
        imageUrl: 'assets/images/acco5.jpg',
        accommodationType: 'Villa'),
    Accommodation(
        id: 'A105',
        name: 'Backpackers Lounge',
        location: 'Colombo',
        pricePerNight: 9000.0,
        imageUrl: 'assets/images/acco6.jpg',
        accommodationType: 'Hostel'),
    Accommodation(
        id: 'A106',
        name: 'Sea Hostel',
        location: 'Galle',
        pricePerNight: 11000.0,
        imageUrl: 'assets/images/acco7.jpg',
        accommodationType: 'Hostel'),
    Accommodation(
        id: 'A107',
        name: 'Kurudu lounge',
        location: 'Colombo',
        pricePerNight: 12000.0,
        imageUrl: 'assets/images/acco8.jpg',
        accommodationType: 'Hostel'),
    Accommodation(
        id: 'A108',
        name: 'Araliya resort',
        location: 'Galle',
        pricePerNight: 10000.0,
        imageUrl: 'assets/images/acco9.jpg',
        accommodationType: 'Hostel'),
    Accommodation(
        id: 'A109',
        name: 'Kanda Hostel',
        location: 'Colombo',
        pricePerNight: 5000.0,
        imageUrl: 'assets/images/acco10.jpg',
        accommodationType: 'Hostel'),
  ];

  List<Accommodation> filteredAccommodations = [];
  String? selectedType;
  double minPrice = 0;
  double maxPrice = 20000;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredAccommodations = allAccommodations;
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return FilterDialog(
          selectedType: selectedType,
          minPrice: minPrice,
          maxPrice: maxPrice,
          onTypeChanged: (String? newValue) {
            setState(() {
              selectedType = newValue;
              _filterAccommodations(); // Apply filters after dialog is closed
            });
          },
          onPriceChanged: (RangeValues values) {
            setState(() {
              minPrice = values.start;
              maxPrice = values.end;
              _filterAccommodations(); // Apply filters after dialog is closed
            });
          },
        );
      },
    );
  }

  void _filterAccommodations() {
    setState(() {
      filteredAccommodations = allAccommodations.where((accommodation) {
        final matchesLocation = searchQuery.isEmpty ||
            accommodation.location
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
        final matchesType = selectedType == null ||
            accommodation.accommodationType == selectedType;
        final matchesPrice = accommodation.pricePerNight >= minPrice &&
            accommodation.pricePerNight <= maxPrice;

        return matchesLocation && matchesType && matchesPrice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0FBFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2A5E),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: const Text(
          "Accommodations",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white),
              onPressed: _openFilterDialog,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by city',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Color(0xFF1E2A5E)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFF1E2A5E), width: 2.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                _filterAccommodations(); // Apply filtering based on search input
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredAccommodations.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AccommodationItem(
                    accommodation: filteredAccommodations[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
