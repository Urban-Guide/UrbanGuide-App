import 'package:flutter/material.dart';
import 'package:urbun_guide/models/accommodation.dart';
import 'package:urbun_guide/services/firebase_services.dart';
import 'accom_add_review.dart';

class AccommodationReviews extends StatefulWidget {
  final Accommodation accommodation;

  AccommodationReviews({required this.accommodation});

  @override
  _AccommodationReviewsState createState() => _AccommodationReviewsState();
}

class _AccommodationReviewsState extends State<AccommodationReviews> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    List<Map<String, dynamic>> reviews =
        await _firebaseService.getReviews(widget.accommodation.id);
    setState(() {
      _reviews = reviews;
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
        title: Text(
          '${widget.accommodation.name} Reviews',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    return Card(
                      color: Colors.white, // Set card color to white
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review['userName'] ??
                                  'Anonymous', // Handle null values for userName
                              style: TextStyle(
                                  fontWeight: FontWeight
                                      .w500, // Light font weight for username
                                  fontSize: 17,
                                  color:
                                      const Color.fromARGB(255, 152, 152, 152)),
                            ),
                            SizedBox(height: 8),
                            Text(
                              review['review'] ??
                                  'No review provided', // Handle null values for review
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 19,
                                  color: const Color.fromARGB(
                                      255, 90, 90, 90) // Bold for review text
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Positioned FloatingActionButton in the top-right corner
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              backgroundColor:
                  Color(0xFF7C93C3), // Change the color of the button
              child: Icon(Icons.edit,
                  color: Colors.white), // Optional icon color change
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddReviewPage(accommodation: widget.accommodation),
                  ),
                ).then((_) {
                  _fetchReviews();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
