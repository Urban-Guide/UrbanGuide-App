import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbun_guide/service/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class AddReview extends StatefulWidget {
  final String placeName; // Add this field to accept the place name

  const AddReview(
      {super.key, required this.placeName}); // Add the required field

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  TextEditingController placeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    placeController.text = widget.placeName; // Auto-fill the place name
  }

  String reviewDescription = '';
  int rating = 0;
  bool agree = false;

  @override
  Widget build(BuildContext context) {
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
                  'Give Your Review',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name input
              const Text(
                'Name',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your name',
                ),
              ),
              const SizedBox(height: 20),

              // Place field
              const Text('Place Name', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: placeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter place name',
                ),
                readOnly: true, // Make it read-only since it's auto-filled
              ),
              const SizedBox(height: 20),

              // Rating input
              const Text(
                'Rate the Place',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30.0,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Review input
              const Text(
                'Give your review about the place',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reviewController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your review...',
                ),
                onChanged: (value) {
                  setState(() {
                    reviewDescription = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Checkbox for agreement
              Row(
                children: [
                  Checkbox(
                    value: agree,
                    onChanged: (bool? value) {
                      // Dismiss the keyboard when the checkbox is clicked
                      FocusScope.of(context).unfocus();
                      setState(() {
                        agree = value!;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'I agree to have my feedback displayed.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Submit button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7C93C3),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                  ),
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        reviewController.text.isEmpty ||
                        placeController.text.isEmpty ||
                        rating == 0 ||
                        !agree) {
                      Fluttertoast.showToast(
                        msg: "Please fill all the fields.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    // Get the current user ID
                    String userId = FirebaseAuth.instance.currentUser!.uid;

                    String reviewId =
                        'rev${randomAlphaNumeric(5).padLeft(5, '0')}'; // Custom ID generation
                    Map<String, dynamic> reviewDataMap = {
                      "Id": reviewId,
                      "UserId": userId, // Add user ID here
                      "Name": nameController.text,
                      "Place": placeController.text,
                      "Rating": rating,
                      "Review": reviewDescription,
                    };

                    try {
                      await DatabaseMethods()
                          .addReviewDetails(reviewDataMap, reviewId);

                      Fluttertoast.showToast(
                        msg: "Review submitted successfully!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.indigo[800],
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      // Clear all fields after submission
                      nameController.clear();
                      reviewController.clear();
                      setState(() {
                        placeController;
                        rating = 0;
                        agree = false;
                      });
                    } catch (error) {
                      Fluttertoast.showToast(
                        msg: "Error submitting review. Please try again.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: const Text(
                    "Submit Review",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
