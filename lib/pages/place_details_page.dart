import 'package:flutter/material.dart';
import 'package:urbun_guide/models/place.dart';
import 'package:urbun_guide/pages/add_review.dart';
import 'package:urbun_guide/pages/gallery_page.dart';
import 'package:urbun_guide/service/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore

class PlaceDetailsPage extends StatefulWidget {
  final String number;

  const PlaceDetailsPage({super.key, required this.number});

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetailsPage> {
  Stream<QuerySnapshot>? reviewStream; // Corrected type

  getOnTheLoad() async {
    // Await the Future and get the stream
    reviewStream = await DatabaseMethods().getReviewDetails();
    setState(() {}); // Re-render the widget with the updated reviewStream data
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  // Function to open the Google Maps link
  Future<void> _openMap(String url) async {
    if (url.isEmpty || !Uri.parse(url).isAbsolute) {
      print('Invalid URL: $url');
      return; // Exit if the URL is invalid
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  // Review Card Widget
  Widget reviewCard(String reviewText, String userName, int rating) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2.0,
      color: const Color.fromARGB(225, 225, 232, 248),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reviewText,
              style: const TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '— $userName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final place = places.firstWhere((place) => place.number == widget.number);

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
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                child: Text(
                  place.title,
                  style: const TextStyle(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      place.mainImage,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: IconButton(
                      icon: const Icon(Icons.location_on,
                          color: Colors.white, size: 30),
                      onPressed: () async {
                        await _openMap(place.locationLink);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                place.title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(place.details),
              const SizedBox(height: 20),
              Text(place.description),
              const SizedBox(height: 30),

              // Gallery section with Explore More button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (place.galleryImages.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GalleryPage(galleryImages: place.galleryImages),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("No Images Available"),
                              content: const Text(
                                  "This place doesn't have any images in the gallery."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: const Text(
                        'Explore More',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      place.additionalImages[0],
                      width: 170,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      place.additionalImages[1],
                      width: 170,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Reviews Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reviews',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff7C93C3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                    ),
                    onPressed: () {
                      // Navigate to AddReview page with place name
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddReview(
                              placeName: place.title), // Pass the place name
                        ),
                      );
                    },
                    child: const Text(
                      'Add Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // StreamBuilder to display reviews
              StreamBuilder<QuerySnapshot>(
                stream: reviewStream, // Directly passing the stream
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Filter reviews based on the place title
                  final filteredReviews = snapshot.data!.docs.where((review) {
                    return review['Place'] == place.title;
                  }).toList();

                  if (filteredReviews.isEmpty) {
                    return const Text(
                      'No reviews yet.\nBe the first to review!',
                      style: TextStyle(
                          color: Color.fromARGB(255, 62, 76, 105),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300),
                    );
                  }

                  // List of review cards
                  return Column(
                    children: filteredReviews.map((review) {
                      String reviewText = review['Review'];
                      String userName = review['Name'];
                      int rating = (review['Rating'] as num).toInt();

                      return reviewCard(reviewText, userName, rating);
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
