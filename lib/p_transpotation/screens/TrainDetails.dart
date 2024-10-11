import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urbun_guide/user_management/screens/home/home.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainDetailsPage extends StatelessWidget {
  final dynamic trainNumber;

  const TrainDetailsPage(
      {required this.trainNumber, required String destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Train Route Number $trainNumber'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('train')
              .where('trainNumber', isEqualTo: trainNumber)
              .get(), // Fetch the document where routeNumber matches
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                  child:
                      Text('No bus details available for route $trainNumber'));
            }

            // Since routeNumber is unique, assume we only have one document.
            var busDoc = snapshot.data!.docs.first;
            var busData = busDoc.data() as Map<String, dynamic>;
            String destination =
                busData['destination'] ?? 'Unknown destination';
            String frequency = busData['distance'] ?? 'Unknown frequency';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Train route number $trainNumber',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          destination,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          frequency,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Fetch and display the timetable sub-collection
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('train')
                      .doc(busDoc.id) // Use the document ID
                      .collection(
                          'timetable') // Fetch the timetable sub-collection
                      .get(),
                  builder: (context, timetableSnapshot) {
                    if (timetableSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!timetableSnapshot.hasData ||
                        timetableSnapshot.data!.docs.isEmpty) {
                      return const Text('No timetable available.');
                    }

                    final timetableDocs = timetableSnapshot.data!.docs;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          '🕒 Timetable',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          itemCount: timetableDocs.length,
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable inner scroll
                          shrinkWrap: true, // Wrap in available space
                          itemBuilder: (context, index) {
                            final timetableData = timetableDocs[index].data()
                                as Map<String, dynamic>;

                            // Prepare a list to display all fields
                            List<Widget> fieldsList = [];
                            timetableData.forEach((key, value) {
                              fieldsList.add(
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        // Ensures that text takes up only the necessary width
                                        child: Center(
                                          child: Text(
                                            value.toString(),
                                            style: const TextStyle(
                                                fontSize:
                                                    16), // Adjust font size if necessary
                                            softWrap:
                                                true, // Allows the text to wrap to the next line
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });

                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text(
                                      'Timetable Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ...fieldsList, // Display all fields dynamically
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                // Fetch and display the stops
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('train')
                      .doc(busDoc.id) // Use the document ID
                      .collection('stop') // Fetch the 'stop' sub-collection
                      .get(),
                  builder: (context, busstopSnapshot) {
                    if (busstopSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!busstopSnapshot.hasData ||
                        busstopSnapshot.data!.docs.isEmpty) {
                      return const Text('No bus stops available.');
                    }

                    final busstopDocs = busstopSnapshot.data!.docs;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          '🛑 Bus Stops',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          itemCount: busstopDocs.length,
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable inner scroll
                          shrinkWrap: true, // Wrap in available space
                          itemBuilder: (context, index) {
                            final busstopData = busstopDocs[index].data()
                                as Map<String, dynamic>;

                            // Display all fields inside each stop document
                            List<Widget> fieldsList = [];
                            busstopData.forEach((key, value) {
                              fieldsList.add(
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        key,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(value.toString()),
                                    ],
                                  ),
                                ),
                              );
                            });

                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Stop Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ...fieldsList, // Display all fields dynamically
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Center(
                    child: _buildMapView(
                        trainNumber)), // Load map image dynamically
                const SizedBox(height: 20),

                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      String googleUrl =
                          'https://www.google.com/maps/search/?api=1&query=$trainNumber';

                      if (await canLaunch(googleUrl)) {
                        await launch(googleUrl);
                      } else {
                        throw 'Could not open Google Maps';
                      }
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text('Google map'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded edges
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            0, // Set this dynamically if you want to track the current index
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              // Logic for 'Map' button (if needed)
              break;
            case 1:
              // Navigate to Home Page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Home()), // Replace 'HomePage' with the actual home page widget
              );
              break;
            case 2:
              // Logic for 'Bus' button (if needed)
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus), label: 'Bus'),
        ],
      ),
    );
  }

  // Function to build the map view
  Widget _buildMapView(String trainNumber) {
    return FutureBuilder<String>(
      future: _getMapImageUrl(
          trainNumber), // Get the map image URL from Firebase Storage
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No map available.'));
        }

        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Image.network(
            snapshot.data!, // Display the map image from the URL
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  // Function to get the map image URL from Firebase Storage
  Future<String> _getMapImageUrl(String trainNumber) async {
    try {
      // Assuming the map is stored in Firebase Storage under a folder named by routeNumber
      String imagePath = 'train_map/$trainNumber/tmap.png';
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error fetching map image: $e');
      return '';
    }
  }
}
