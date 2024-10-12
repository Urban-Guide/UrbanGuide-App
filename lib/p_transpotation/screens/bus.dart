import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urbun_guide/p_transpotation/screens/BusDetailsPage.dart';
import 'package:urbun_guide/p_transpotation/screens/TrainDetails.dart';
import 'package:urbun_guide/user_management/screens/home/home.dart';
import 'package:urbun_guide/p_transpotation/screens/bus.dart';

class BusPage extends StatefulWidget {
  @override
  _BusPageState createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String dropdownValue = 'Highway';

  // Firestore collection reference for bus routes
  final CollectionReference busCollection =
      FirebaseFirestore.instance.collection('bus');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Function to fetch bus routes based on the category from Firestore
  Future<List<Map<String, String>>> fetchBusRoutes(String category) async {
    QuerySnapshot snapshot = await busCollection.get();
    List<Map<String, String>> busRoutes = [];

    snapshot.docs.forEach((doc) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['type'] == category) {
        busRoutes.add({
          'routeNumber': data['routeNumber'] ?? '',
          'destination': data['destination'] ?? '',
        });
      }
    });

    return busRoutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: Icon(Icons.location_on),
        title: Text('Colombo, LK'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.png'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue[900],
            ),
            tabs: [
              Tab(icon: Icon(Icons.directions_bus)),
              Tab(icon: Icon(Icons.train)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Bus tab with Firestore data integration
                FutureBuilder<List<Map<String, String>>>(
                  future: fetchBusRoutes(dropdownValue),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return BusTab(
                        dropdownValue: dropdownValue,
                        onDropdownChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        busRoutes: snapshot.data ?? [],
                      );
                    }
                  },
                ),
                TrainTab(), // The train tab remains the same as your previous implementation
              ],
            ),
          ),
        ],
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
}

class BusTab extends StatelessWidget {
  final String dropdownValue;
  final Function(String) onDropdownChanged;
  final List<Map<String, String>> busRoutes;

  const BusTab({
    required this.dropdownValue,
    required this.onDropdownChanged,
    required this.busRoutes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search bus route',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (query) {
              // Handle search logic here if needed (e.g., filtering busRoutes)
            },
          ),
        ),
        // Dropdown and Bus Text
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Bus',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onDropdownChanged(newValue);
                  }
                },
                items: <String>['Highway', 'Express', 'Intercity']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        // List of Bus Routes
        Expanded(
          child: ListView.builder(
            itemCount: busRoutes.length,
            itemBuilder: (context, index) {
              final bus = busRoutes[index];
              return BusRouteCard(
                routeNumber: bus['routeNumber']!,
                destination: bus['destination']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class TrainTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search train',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (query) {
              // Handle search logic if needed
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text('Train',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('train').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No trains available."));
              }

              final trainRoutes = snapshot.data!.docs;

              return ListView.builder(
                itemCount: trainRoutes.length,
                itemBuilder: (context, index) {
                  final train = trainRoutes[index];
                  return TrainRouteCard(
                    trainNumber: train['trainNumber'] ?? '',
                    trainName: train['trainName'] ?? '',
                    destination: train['destination'] ?? '',
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class BusRouteCard extends StatelessWidget {
  final String routeNumber;
  final String destination;

  const BusRouteCard({required this.routeNumber, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.directions_bus),
        title: Text(routeNumber),
        subtitle: Text(destination),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to BusDetailsPage when tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BusDetailsPage(
                routeNumber: routeNumber,
                destination: '',
              ),
            ),
          );
        },
      ),
    );
  }
}

class TrainRouteCard extends StatelessWidget {
  final String trainNumber;
  final String trainName;
  final String destination;

  const TrainRouteCard({
    required this.trainNumber,
    required this.trainName,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.train),
        title: Text('$trainName ($trainNumber)'),
        subtitle: Text(destination),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrainDetailsPage(
                trainNumber: trainNumber,
                destination: '',
              ),
            ),
          );
        },
      ),
    );
  }
}
