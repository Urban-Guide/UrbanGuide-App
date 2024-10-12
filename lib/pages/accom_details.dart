import 'package:flutter/material.dart';
import 'package:urbun_guide/models/accommodation.dart';
import 'package:urbun_guide/pages/accom_reserve_form.dart';
import 'package:urbun_guide/pages/accom_reviews.dart';

class AccommodationDetail extends StatefulWidget {
  final Accommodation accommodation;

  AccommodationDetail({required this.accommodation});

  @override
  _AccommodationDetailState createState() => _AccommodationDetailState();
}

class _AccommodationDetailState extends State<AccommodationDetail> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      widget.accommodation.imageUrl,
      'assets/images/acco11.jpg',
      'assets/images/acco12.jpg',
      'assets/images/acco13.jpg',
      'assets/images/acco14.jpg',
      'assets/images/acco15.jpg',
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF0FBFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2A5E),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(widget.accommodation.name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: PageView.builder(
                    itemCount: imageUrls.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.3),
                        colorBlendMode: BlendMode.darken,
                      );
                    },
                  ),
                ),
                // Left arrow icon
                Positioned(
                  top: 140,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.chevron_left,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 30),
                    onPressed: () {
                      setState(() {
                        if (_currentIndex > 0) {
                          _currentIndex--;
                        }
                      });
                    },
                  ),
                ),
                // Right arrow icon
                Positioned(
                  top: 140,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.chevron_right,
                        color: Colors.white, size: 30),
                    onPressed: () {
                      setState(() {
                        if (_currentIndex < imageUrls.length - 1) {
                          _currentIndex++;
                        }
                      });
                    },
                  ),
                ),
                // Image count display
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Location with icon
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: Color.fromARGB(255, 213, 54, 54)),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.accommodation.location,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 111, 114, 116),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // About section
            Text('About',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFF1E2A5E))),
            const SizedBox(height: 5),
            Text(
              'This place is a lovely Sri Lankan style budget friendly beachfront property with private swimming pool located right on the beach.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color.fromARGB(221, 57, 57, 57),
                  height: 1.5,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),

            Text(
              'Amenities',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xFF1E2A5E)),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.wifi, size: 30, color: Color(0xFF7C93C3)),
                    SizedBox(height: 5),
                    Text(
                      'Wi-Fi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7C93C3),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.pool, size: 30, color: Color(0xFF7C93C3)),
                    SizedBox(height: 5),
                    Text(
                      'Pool',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7C93C3),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.restaurant, size: 30, color: Color(0xFF7C93C3)),
                    SizedBox(height: 5),
                    Text(
                      'Breakfast',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7C93C3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccommodationReviews(
                        accommodation: widget.accommodation,
                      ),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Read Reviews',
                    style: TextStyle(
                      color: Color(0xFF1E2A5E),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Reserve button with shadow and gradient
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingFormPage(accommodation: widget.accommodation),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Color(0xFF7C93C3),
                  shadowColor: const Color.fromARGB(255, 51, 62, 81),
                ),
                child: const Text(
                  'Reserve',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
