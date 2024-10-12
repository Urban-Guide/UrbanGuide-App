import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the google_fonts package
import 'package:provider/provider.dart';
import 'package:urbun_guide/user_management/models/UserModel.dart';
import 'package:urbun_guide/user_management/screens/wrapper.dart';
import 'package:urbun_guide/user_management/services/auth.dart';
import 'package:urbun_guide/pages/weatherhome.dart';
import 'package:urbun_guide/pages/tourist_home.dart';
import 'package:urbun_guide/p_transpotation/screens/bus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: UserModel(uid: ""),
      value: AuthServices().user,
      child: MaterialApp(
        title: 'Urban Guide',
        debugShowCheckedModeBanner: false, // Remove the debug banner
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(
            // Set the Poppins font for the entire app
            Theme.of(context).textTheme,
          ),
        ),
        home: const MainLayout(),
      ),
    );
  }
}

// Main layout with navigation menu
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 2; // Default to home icon
  final List<Widget> _pages = [
    TouristHome(), // Placeholder for future 'Places' page
    const Placeholder(), // Placeholder for future 'Sleep' page
    const Wrapper(), // Authentication-related wrapper page
    BusPage(), // Placeholder for future 'Bus' page
    WeatherPage(), // Weather page
  ];

  List<IconData> navIcons = [
    Icons.place,
    Icons.bed,
    Icons.home,
    Icons.directions_bus,
    Icons.wb_sunny,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed the AppBar entirely
      body: Stack(
        children: [
          _pages[selectedIndex], // Render the selected page
          Align(
            alignment: Alignment.bottomCenter,
            child: _navBar(), // Render navigation menu
          ),
        ],
      ),
    );
  }

  Widget _navBar() {
    return Container(
      height: 65,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A5E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(navIcons.length, (index) {
          return buildNavItem(navIcons[index], index);
        }),
      ),
    );
  }

  Widget buildNavItem(IconData icon, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF7C93C3),
          size: 28,
        ),
      ),
    );
  }
}
