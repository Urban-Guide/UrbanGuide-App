import 'package:flutter/material.dart';
import 'package:urbun_guide/pages/accom_details.dart';
import '../models/accommodation.dart';

class AccommodationItem extends StatelessWidget {
  final Accommodation accommodation;

  AccommodationItem({required this.accommodation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the AccommodationDetail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AccommodationDetail(accommodation: accommodation),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image displayed at the top
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                accommodation.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            // Description below the image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accommodation.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2A5E),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        accommodation.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.home, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        accommodation.accommodationType,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'LKR ${accommodation.pricePerNight.toStringAsFixed(2)}/night',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2A5E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
