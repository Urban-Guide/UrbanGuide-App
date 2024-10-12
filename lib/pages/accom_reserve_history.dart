import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urbun_guide/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class AccommodationBookingHistoryPage extends StatefulWidget {
  @override
  _AccommodationBookingHistoryPageState createState() =>
      _AccommodationBookingHistoryPageState();
}

class _AccommodationBookingHistoryPageState
    extends State<AccommodationBookingHistoryPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _bookings = [];
  String? _userId; // Store logged-in user ID

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(); // Get the current user's ID
  }

  // Fetch the current logged-in user's ID
  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      _fetchBookings();
    }
  }

  // Fetch bookings only for the logged-in user
  Future<void> _fetchBookings() async {
    if (_userId != null) {
      List<Map<String, dynamic>> bookings =
          await _firebaseService.getBookingsByUserId(_userId!);
      setState(() {
        _bookings = bookings;
      });
    }
  }

  // Function to delete a booking
  Future<void> _deleteBooking(String bookingId) async {
    await _firebaseService.deleteBooking(bookingId);
    _fetchBookings(); // Refresh after deletion
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
          'Reservations',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _bookings.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                final booking = _bookings[index];

                final checkInDate = DateFormat('yyyy-MM-dd')
                    .format(booking['checkInDate'].toDate());
                final checkOutDate = DateFormat('yyyy-MM-dd')
                    .format(booking['checkOutDate'].toDate());

                return Card(
                  elevation:
                      8.0, // Increased elevation for a more prominent shadow
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking['accommodationName'],
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Text(
                            'Booking ID: ${booking['bookingId']}', // Display bookingId
                            style: TextStyle(fontSize: 16.0)),
                        SizedBox(height: 10.0),
                        Text('Check-in: $checkInDate',
                            style: TextStyle(fontSize: 16.0)),
                        Text('Check-out: $checkOutDate',
                            style: TextStyle(fontSize: 16.0)),
                        Text('Number of Rooms: ${booking['numberOfRooms']}',
                            style: TextStyle(fontSize: 16.0)),
                        SizedBox(height: 10.0),
                        Text('Total Payment: ${booking['totalPayment']} LKR',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 30, 69, 153))),
                        SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            final bookingId = booking['bookingId'];
                            if (bookingId != null) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Confirm Cancellation'),
                                  content: Text(
                                      'Are you sure you want to cancel this booking?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteBooking(bookingId);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Booking ID is not available')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Color(0xFF7C93C3), // Set button color
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 12.0), // Add padding
                          ),
                          child: const Text('Cancel Reservation'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
