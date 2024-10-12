import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final String? selectedType;
  final double minPrice;
  final double maxPrice;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<RangeValues> onPriceChanged;

  FilterDialog({
    required this.selectedType,
    required this.minPrice,
    required this.maxPrice,
    required this.onTypeChanged,
    required this.onPriceChanged,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? selectedType;
  double minPrice = 0;
  double maxPrice = 20000;

  @override
  void initState() {
    super.initState();
    selectedType =
        widget.selectedType; // Initialize with the passed selected type
    minPrice = widget.minPrice;
    maxPrice = widget.maxPrice;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Filter Accommodations",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E2A5E),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accommodation Type Dropdown
            Text(
              'Select Accommodation Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2A5E),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text('Select type'),
                  value: selectedType,
                  isExpanded: true,
                  items: <String>['Hostel', 'Villa']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            // Price Range Slider
            Text(
              "Price Range",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2A5E),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "${minPrice.toStringAsFixed(0)} - ${maxPrice.toStringAsFixed(0)} LKR",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            RangeSlider(
              values: RangeValues(minPrice, maxPrice),
              min: 0,
              max: 20000,
              divisions: 200,
              activeColor: Color(0xFF1E2A5E),
              inactiveColor: Colors.grey[300],
              onChanged: (RangeValues values) {
                setState(() {
                  minPrice = values.start;
                  maxPrice = values.end;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Reset selected filters
            setState(() {
              selectedType = null;
              minPrice = 0;
              maxPrice = 20000;
            });
          },
          child: Text('Reset Filters'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onTypeChanged(selectedType);
            widget.onPriceChanged(RangeValues(minPrice, maxPrice));
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Apply Filters'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      elevation: 8,
    );
  }
}
