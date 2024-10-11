import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  // Method to insert complaint details to the database
  Future addReviewDetails(
      Map<String, dynamic> reviewDataMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("Reviews")
          .doc(id)
          .set(reviewDataMap);
    } catch (e) {
      print("Error adding reviews details: $e");
      throw e;
    }
  }

  // Method to Read complaint from the database
  Future<Stream<QuerySnapshot>> getReviewDetails() async {
    return FirebaseFirestore.instance
        .collection('Reviews') // Filter by place title
        .snapshots();
  }

  // Modify this method to directly return the stream
  Stream<QuerySnapshot> getReviewDetailsall() {
    return FirebaseFirestore.instance.collection('Reviews').snapshots();
  }

  //Method to update complaint details in the database
  Future<void> updateReview(String reviewId, Map<String, dynamic> updatedData) {
    return FirebaseFirestore.instance
        .collection('Reviews')
        .doc(reviewId)  // The specific review document ID
        .update(updatedData);
  }

  Future<DocumentSnapshot> getReviewById(String reviewId) {
    return FirebaseFirestore.instance
        .collection('Reviews')
        .doc(reviewId)
        .get();
  }

  // Method to delete complaint from the database
  Future<void> deleteReview(String complaintId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Reviews')
          .doc(complaintId)
          .delete();
    } catch (e) {
      print("Error deleting complaint: $e");
      throw e;
    }
  }
}
