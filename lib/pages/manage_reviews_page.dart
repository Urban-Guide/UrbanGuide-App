import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urbun_guide/service/database.dart';

class ManageReviewsPage extends StatelessWidget {
  const ManageReviewsPage({Key? key}) : super(key: key);

  // Function to show bottom sheet when edit button is pressed
  void _showEditReviewSheet(BuildContext context, String reviewId) async {
    // Fetch review details from the database using the reviewId
    DocumentSnapshot reviewSnapshot =
        await DatabaseMethods().getReviewById(reviewId);

    if (!reviewSnapshot.exists) {
      // If the document does not exist, show an error or handle it appropriately
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review not found')),
      );
      return;
    }

    // Extract data from the fetched review
    String name = reviewSnapshot['Name'] ?? 'Unknown'; // Fetch name
    String reviewText = reviewSnapshot['Review'] ?? ''; // Fetch review text
    double currentRating =
        reviewSnapshot['Rating']?.toDouble() ?? 0; // Fetch rating

    // Initialize controllers with fetched data
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController reviewController =
        TextEditingController(text: reviewText);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 40.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 60.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              const Text(
                'Name',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Rating field
              const Text(
                'Rate the Place',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      currentRating = index + 1.0; // Update the rating
                    },
                    icon: Icon(
                      Icons.star,
                      size: 40.0,
                      color:
                          index < currentRating ? Colors.yellow : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Review field
              const Text(
                'Give your review about the place',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: reviewController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // Update Review button
              ElevatedButton(
                onPressed: () async {
                  // Logic to update the review in the database
                  await DatabaseMethods().updateReview(
                    reviewId, // Pass the review document ID
                    {
                      'Name': nameController.text,
                      'Review': reviewController.text,
                      'Rating': currentRating, // Updated rating
                    },
                  );

                  Navigator.pop(context); // Close the sheet after updating
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xff7C93C3), // Update button color
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: const Center(
                  child: Text(
                    'Update Review',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user ID using Firebase Authentication
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1E2A5E),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        toolbarHeight: 70.0,
        title: const Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                child: Text(
                  'My Reviews', // Updated title for the page
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Add space between AppBar and the first item in the body
          const SizedBox(height: 20.0),

          // StreamBuilder wrapped with padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // Add side padding
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Reviews')
                    .where('UserId', isEqualTo: userId) // Filter reviews by userId
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading reviews"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No reviews found"));
                  }

                  // Now, let's display the list of reviews
                  var reviews = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      var reviewData =
                          reviews[index].data() as Map<String, dynamic>;
                      var reviewText = reviewData['Review'] ?? 'No review text';
                      var reviewPlace = reviewData['Place'] ?? 'No place text';

                      return Card(
                        color: const Color(0xFFCDDAF5), // Card background color
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 5.0), // Add margin around cards
                        child: Padding(
                          padding: const EdgeInsets.all(
                              15.0), // Add padding inside cards
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reviewPlace,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              // const SizedBox(height: 10),
                              Text(
                                reviewText,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(
                                  height: 5), // Space between text and buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _showEditReviewSheet(
                                          context, reviews[index].id);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      // Show confirmation dialog before deleting
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Delete Review"),
                                            content: const Text(
                                                "Are you sure you want to delete this review?"),
                                            actions: [
                                              TextButton(
                                                child: const Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                              ),
                                              TextButton(
                                                child: const Text("Delete"),
                                                onPressed: () {
                                                  // Logic to delete the review
                                                  DatabaseMethods()
                                                      .deleteReview(
                                                          reviews[index].id);
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog after deleting
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
