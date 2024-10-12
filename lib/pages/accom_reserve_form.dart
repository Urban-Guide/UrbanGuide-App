import 'package:flutter/material.dart';
import 'package:urbun_guide/pages/accom_reserve_history.dart';
import 'package:urbun_guide/services/firebase_services.dart';
import 'package:intl/intl.dart';
import 'package:urbun_guide/user_management/services/auth.dart';
import '../models/accommodation.dart';

class BookingFormPage extends StatefulWidget {
  final Accommodation accommodation;

  BookingFormPage({required this.accommodation});

  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _numberOfRooms = 1;
  double _totalPayment = 0.0;

  // Instances of FirebaseService and AuthServices
  final FirebaseService _firebaseService = FirebaseService();
  final AuthServices _authServices = AuthServices();

  // Method to calculate total payment
  void _calculateTotalPayment() {
    if (_checkInDate != null && _checkOutDate != null) {
      int noOfDays = _checkOutDate!.difference(_checkInDate!).inDays;
      setState(() {
        _totalPayment =
            widget.accommodation.pricePerNight * noOfDays * _numberOfRooms;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      // Get the logged-in user's ID and name from AuthServices
      String? userId = _authServices.currentUser?.uid;
      Map<String, dynamic>? userData =
          await _authServices.getUserData(userId ?? "");

      if (userId != null && userData != null) {
        String userName = userData['name'] ?? 'Unknown';

        // Save booking to Firestore using FirebaseService, including userId and userName
        await _firebaseService.saveBooking(
          widget.accommodation,
          _checkInDate,
          _checkOutDate,
          _numberOfRooms,
          _totalPayment,
          userId, // Pass userId
          userName, // Pass userName
        );

        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Booking Confirmed'),
            content: Text(
                'Your booking for ${widget.accommodation.name} has been confirmed!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );

        // Navigate to Booking History Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AccommodationBookingHistoryPage()),
        );
      } else {
        // Show error if user is not logged in or there was an issue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Unable to retrieve user data.')),
        );
      }
    }
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
            '${widget.accommodation.name}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Check-in Date Field
                TextFormField(
                  readOnly: true, // Make it read-only to prevent editing
                  decoration: const InputDecoration(
                    labelText: 'Check-in date',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 37, 37, 37),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 236, 236, 236),
                          width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 37, 49, 121), width: 2.0),
                    ),
                  ),
                  controller: TextEditingController(
                    text: _checkInDate != null
                        ? DateFormat('yyyy-MM-dd').format(_checkInDate!)
                        : 'Select date',
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _checkInDate = picked;
                      });
                      _calculateTotalPayment();
                    }
                  },
                ),

                SizedBox(height: 20), // Space between fields

                // Check-out Date Field
                TextFormField(
                  readOnly: true, // Make it read-only to prevent editing
                  decoration: const InputDecoration(
                    labelText: 'Check-out Date',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 37, 37, 37),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 236, 236, 236),
                          width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 37, 49, 121), width: 2.0),
                    ),
                  ),
                  controller: TextEditingController(
                    text: _checkOutDate != null
                        ? DateFormat('yyyy-MM-dd').format(_checkOutDate!)
                        : 'Select date',
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _checkInDate ?? DateTime.now(),
                      firstDate: _checkInDate ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _checkOutDate = picked;
                      });
                      _calculateTotalPayment();
                    }
                  },
                ),

                SizedBox(height: 20), // Space between fields

                // Number of Rooms Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Number of Rooms',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 37, 37, 37),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 236, 236, 236),
                          width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 37, 49, 121), width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _numberOfRooms.toString(),
                  onChanged: (value) {
                    setState(() {
                      _numberOfRooms = int.tryParse(value) ?? 1;
                      _calculateTotalPayment();
                    });
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Please enter a valid number of rooms';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20), // Space between fields

                // Total Payment Field (displaying total payment)
                Text(
                  'Total Payment (LKR): ${_totalPayment.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 20), // Space between fields

                // Submit Button
                ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF7C93C3), // Text color
                  ),
                  child: Text('Submit Booking'),
                ),
              ],
            ),
          ),
        ));
  }
}
