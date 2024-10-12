import 'package:flutter/material.dart';
import 'package:urbun_guide/user_management/services/auth.dart';
import 'update.dart'; // Import the update page

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthServices _auth = AuthServices();
  String? name, email, nic, phone, addressNo, street, city;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? uid = _auth.currentUser?.uid;

    if (uid != null) {
      Map<String, dynamic>? userData = await _auth.getUserData(uid);

      if (userData != null) {
        setState(() {
          name = userData['name'];
          email = userData['email'];
          nic = userData['nic'];
          phone = userData['phone'];
        });
      }
    }
  }

  Future<void> _deleteProfile(BuildContext context) async {
    String? password = await _showPasswordConfirmationDialog(context);

    if (password != null) {
      bool isPasswordCorrect = await _auth.reauthenticateUser(password);

      if (isPasswordCorrect) {
        await _auth.deleteUser();
        Navigator.pop(context, true); // Navigate back after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect password!')),
        );
      }
    }
  }

  Future<String?> _showPasswordConfirmationDialog(BuildContext context) async {
    String? password;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your password to delete profile'),
          content: TextField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            onChanged: (value) {
              password = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(password);
              },
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
            onPressed: () async {
              // Navigate to the UpdateProfile page and wait for result
              bool? updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProfile(
                    userData: {
                      'name': name,
                      'email': email,
                      'nic': nic,
                      'phone': phone,
                    },
                  ),
                ),
              );

              if (updated == true) {
                _loadUserData();
              }
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: email == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Icon, Name, Email, Phone Number
                  Row(
                    children: [
                      const SizedBox(width: 20.0),
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color.fromARGB(
                            255, 83, 107, 169), // Profile icon background
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ), // Profile icon
                      ),
                      const SizedBox(width: 40.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name ?? "Name",
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Text(email ?? "email@gmail.com"),
                          Text(phone ?? "+94 123456789"),
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
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child: ListTile(
                      title: const Text("Manage Bookings"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Manage bookings navigation logic can be added
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Manage Reviews ListTile wrapped in a Container for borderRadius
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFCDDAF5), // Background color
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child: ListTile(
                      title: const Text("Manage Reviews"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Manage reviews navigation logic can be added
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

                  // Toggle Buttons
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
                      backgroundColor: const Color(
                          0xff7C93C3), // Set the background color to blue
                      foregroundColor:
                          Colors.white, // Set the text color to white
                    ),
                    child: const Text("Log out"),
                  ),
                  TextButton(
                    onPressed: () {
                      _deleteProfile(context); // Call delete function
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
}
