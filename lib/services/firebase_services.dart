import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/accommodation.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save a booking
  Future<void> saveBooking(
      Accommodation accommodation,
      DateTime? checkInDate,
      DateTime? checkOutDate,
      int numberOfRooms,
      double totalPayment,
      String userId,
      String userName) async {
    await _firestore.collection('bookings').add({
      'accommodationId': accommodation.id,
      'accommodationName': accommodation.name,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'numberOfRooms': numberOfRooms,
      'totalPayment': totalPayment,
      'userId': userId, // Store user ID
      'userName': userName, // Store user name
    });
  }

  // Method to retrieve bookings by userId
  Future<List<Map<String, dynamic>>> getBookingsByUserId(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'bookingId': doc.id, // Include document ID as bookingId
            })
        .toList();
  }

  // Method to delete a booking by its ID
  Future<void> deleteBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).delete();
  }

  // Method to save a review for a specific accommodation
  Future<void> saveReview(String accommodationId, String userId,
      String userName, String review) async {
    try {
      await _firestore
          .collection('accommodations')
          .doc(accommodationId)
          .collection('reviews')
          .add({
        'userId': userId,
        'userName': userName,
        'review': review,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving review: $e");
      throw e;
    }
  }

  // Method to retrieve reviews for a specific accommodation
  Future<List<Map<String, dynamic>>> getReviews(String accommodationId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('accommodations')
        .doc(accommodationId)
        .collection('reviews')
        .get(); // No need to order if you don't want the timestamp

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'reviewId': doc.id, // Include document ID as reviewId
        'userId': data['userId'], // Include userId
        'userName': data['userName'], // Include userName
        'review': data['review'], // Include review text
      };
    }).toList();
  }
}
