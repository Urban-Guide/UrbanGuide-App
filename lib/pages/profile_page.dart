import 'package:flutter/material.dart';
import 'package:urbun_guide/pages/manage_reviews_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final String name = "Name";
  final String email = "email@gmail.com";
  final String phone = "+94 123456789";

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
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Show the bottom sheet for editing details
              _showEditProfileBottomSheet(context, name, email, phone);
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Icon, Name, Email, Phone Number
            const Row(
              children: [
                SizedBox(width: 20.0),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color.fromARGB(
                      255, 83, 107, 169), // Profile icon background
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ), // Profile icon
                ),
                SizedBox(width: 40.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text("email@gmail.com"),
                    Text("+94 123456789"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Activity Summary Section
            const Text(
              "Activity Summary",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Wrapped ListTile in a Container for borderRadius
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFCDDAF5), // Background color
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: ListTile(
                title: const Text("Manage Bookings"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const ManageBookingsPage()),
                  // );
                },
              ),
            ),
            const SizedBox(height: 15),
            // Manage Reviews ListTile wrapped in a Container for borderRadius
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFCDDAF5), // Background color
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: ListTile(
                title: const Text("Manage Reviews"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageReviewsPage(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // Settings Section
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Toggle Buttons (without logic)
            SwitchListTile(
              title: const Text("Location Sharing"),
              value: true, // Default value, can be modified later
              onChanged: (bool value) {
                // Logic will be added later if needed
              },
            ),
            SwitchListTile(
              title: const Text("Weather Alert Notification"),
              value: false, // Default value, can be modified later
              onChanged: (bool value) {
                // Logic will be added later if needed
              },
            ),
            ListTile(
              title: const Text("Transportation Mode"),
              trailing: DropdownButton<String>(
                value: 'Bus', // Default value
                items: const [
                  DropdownMenuItem(value: 'Bus', child: Text('Bus')),
                  DropdownMenuItem(value: 'Car', child: Text('Car')),
                  DropdownMenuItem(value: 'Bike', child: Text('Bike')),
                ],
                onChanged: (String? value) {
                  // Logic for changing mode can be added later
                },
              ),
            ),
            const Spacer(),

            // Logout and Delete Account Section
            ElevatedButton(
              onPressed: () {
                // Handle Logout Logic here if needed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7C93C3), // Set the background color to blue
                foregroundColor: Colors.white, // Set the text color to white
              ),
              child: const Text("Log out"),
            ),
            TextButton(
              onPressed: () {
                _showDeleteAccountConfirmation(context);
              },
              child: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show confirmation dialog for account deletion
  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete Account"),
          content: const Text(
            "Are you sure you want to delete your account?\nThis action cannot be undone.",
            textAlign: TextAlign.left,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Add delete account logic here
                Navigator.of(context).pop(); // Close the dialog after deleting
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to show the bottom sheet for editing profile details
  void _showEditProfileBottomSheet(BuildContext context, String currentName,
      String currentEmail, String currentPhone) {
    // Create TextEditingController for each text field
    final TextEditingController nameController =
        TextEditingController(text: currentName);
    final TextEditingController emailController =
        TextEditingController(text: currentEmail);
    final TextEditingController phoneController =
        TextEditingController(text: currentPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            top: 40.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 70.0,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Makes the sheet height fit its content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  // Update logic can be added here, such as saving the updated values
                  Navigator.pop(context); // Close the bottom sheet
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7C93C3), // Set the background color to blue
                foregroundColor: Colors.white, // Set the text color to white
              ),
                child: const Text("Update Details"),
              ),
            ],
          ),
        );
      },
    );
  }
}
