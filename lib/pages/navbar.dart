import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Ensure the Get package is installed in your pubspec.yaml
import 'package:urbun_guide/pages/weatherhome.dart';
import 'package:urbun_guide/pages/test1.dart';
import 'package:urbun_guide/pages/test2.dart';
import 'package:urbun_guide/pages/test3.dart';
import 'package:urbun_guide/pages/test4.dart'; // Ensure these pages exist and are correctly imported

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the NavigationController using Get.put to allow dependency injection
    final NavigationController controller = Get.put(NavigationController());

    return Scaffold(
      // Use Obx to observe the changes in the selectedIndex and update the UI accordingly
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.only(
              bottom:
                  20.0), // Add space at the bottom to create a floating effect
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color for the container
              borderRadius: BorderRadius.circular(30), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5), // Position of the shadow
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(
                horizontal: 20), // Add space to the left and right
            height: 64, // Set the height here
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildIcon(controller, Icons.place, 0),
                buildIcon(controller, Icons.bed, 1),
                buildIcon(controller, Icons.home, 2),
                buildIcon(controller, Icons.directions_bus, 3),
                buildIcon(controller, Icons.wb_sunny, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the icons
  Widget buildIcon(NavigationController controller, IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: controller.selectedIndex.value == index
            ? Colors.blueAccent // Highlight color for selected icon
            : Colors.grey.withOpacity(0.6), // Dimmed color for unselected icons
      ),
      onPressed: () {
        controller.selectedIndex.value = index; // Update the selectedIndex
      },
    );
  }
}

class NavigationController extends GetxController {
  // Observing the selectedIndex state (set as RxInt)
  final RxInt selectedIndex = 0.obs;

  // List of screens for navigation
  final screens = [
    const Test1(),
    const Test2(),
    const Test3(),
    const Test4(),
    WeatherPage(), // Ensure this page exists and is correctly implemented
  ];
}
