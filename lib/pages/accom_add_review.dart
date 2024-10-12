import 'package:flutter/material.dart';
import 'package:urbun_guide/models/accommodation.dart';
import 'package:urbun_guide/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urbun_guide/pages/accom_reviews.dart'; // Import the AccommodationReviews page

class AddReviewPage extends StatelessWidget {
  final Accommodation accommodation;
  final FirebaseService _firebaseService = FirebaseService();

  AddReviewPage({required this.accommodation});

  @override
  Widget build(BuildContext context) {
    final TextEditingController reviewController = TextEditingController();
    final TextEditingController userNameController =
        TextEditingController(); // New controller for username

    return Scaffold(
      backgroundColor: Color(0xFFF0FBFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2A5E),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          'Add review - ${accommodation.name}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance
            .authStateChanges()
            .first, // Fetch the current user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching user information'));
          } else if (snapshot.hasData) {
            User? currentUser = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username TextField with box decoration
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white, // Set the background color to white
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: userNameController, // Text field for username
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Username',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Review TextField with box decoration
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white, // Set the background color to white
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: reviewController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Write here',
                      ),
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7C93C3),
                    ),
                    onPressed: () async {
                      String review = reviewController.text;
                      String userName = userNameController.text.isNotEmpty
                          ? userNameController.text
                          : currentUser!.displayName ?? 'Anonymous';

                      // Validate inputs
                      if (review.isNotEmpty && userName.isNotEmpty) {
                        // Save the review to Firestore with user ID and name
                        await _firebaseService.saveReview(
                          accommodation.id,
                          currentUser!.uid, // Pass the user ID
                          userName, // Pass the entered username or fallback to the current user's name
                          review,
                        );

                        // After saving, navigate to the reviews page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccommodationReviews(
                              accommodation: accommodation,
                            ),
                          ),
                        );
                      } else {
                        // Show an alert if the review or username fields are empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please provide a username and a review'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w500), // Change font color to white
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No user is signed in'));
          }
        },
      ),
    );
  }
}
