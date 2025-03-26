import 'package:flutter/material.dart';

/// This file manages the start journey dialog widget.
///
/// Functions:
/// - `show()`: Shows the start journey dialog.
/// - `_showInvalidInputDialog()`: Shows an invalid input dialog.

class StartJourneyDialog {
  static void show(BuildContext context, Function(double, double) onConfirm) {
    String mileageInput = '';
    String mpgInput = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Journey'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Mileage'),
                  onChanged: (value) => mileageInput = value,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Miles per Gallon'),
                  onChanged: (value) => mpgInput = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                // Parse user inputs
                final parsedMileage = double.tryParse(mileageInput);
                if (parsedMileage == null) {
                  _showInvalidInputDialog(context, 'Mileage');
                  return;
                }

                final parsedMpg = double.tryParse(mpgInput);
                if (parsedMpg == null) {
                  _showInvalidInputDialog(context, 'Miles per Gallon');
                  return;
                }

                // Valid input: call the onConfirm callback
                onConfirm(parsedMileage, parsedMpg);

                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
          ],
        );
      },
    );
  }

  static void _showInvalidInputDialog(BuildContext context, String field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Input'),
          content: Text('Please enter a valid $field.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
          ],
        );
      },
    );
  }
}