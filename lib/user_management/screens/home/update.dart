import 'package:flutter/material.dart';
import 'package:urbun_guide/user_management/services/auth.dart';

class UpdateProfile extends StatefulWidget {
  final Map<String, dynamic> userData; // Pass user data to pre-fill the form

  UpdateProfile({required this.userData});

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final AuthServices _auth = AuthServices();

  // Create TextEditingControllers for form fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController nicController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with the existing data
    nameController = TextEditingController(text: widget.userData['name']);
    emailController = TextEditingController(text: widget.userData['email']);
    nicController = TextEditingController(text: widget.userData['nic']);
    phoneController = TextEditingController(text: widget.userData['phone']);
  }

  Future<void> _saveProfile() async {
    String? uid = _auth.currentUser?.uid;

    if (uid != null) {
      try {
        // Update user profile in Firestore
        await _auth.updateUserProfile(
          uid,
          nameController.text,
          emailController.text,
          nicController.text,
          phoneController.text,
        );

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );

        // Navigate back to Profile page with updated data
        Navigator.pop(
            context, true); // true indicates the update was successful
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile: ${e.toString()}")),
        );
      }
    }
  }

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
        title: const Padding(
          padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
          child: Text(
            "Update Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField('Name', nameController),
            const SizedBox(height: 10),
            _buildTextField('Email', emailController),
            const SizedBox(height: 10),
            _buildTextField('NIC', nicController),
            const SizedBox(height: 10),
            _buildTextField('Phone', phoneController),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7C93C3),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
