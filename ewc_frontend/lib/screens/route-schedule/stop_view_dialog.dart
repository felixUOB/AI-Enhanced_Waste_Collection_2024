import 'package:flutter/material.dart';

/// This file manages the log stop dialog widget on the stop_view page.
///
/// Functions:
/// - `show()`: Displays the log stop dialog.
/// - `_showInvalidInputDialog()`: Shows a dialog for invalid input notifications.

class StopViewDialog {
  static Future<int?> show(BuildContext context, String name) {
    return showDialog<int?>(
      context: context,
      builder: (BuildContext context) {
        String wasteCollectedInput = '';
        return AlertDialog(
          title: const Text('Register Collection'),
          content: SingleChildScrollView(
            child: TextField(
              key: Key('waste collected'),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mass of waste collected (kg)'),
              onChanged: (value) => wasteCollectedInput = value,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null); // Dismiss dialog
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                final parsedWasteInput = int.tryParse(wasteCollectedInput);
                if (parsedWasteInput == null || parsedWasteInput < 0) {
                  _showInvalidInputDialog(context, 'collection amount');
                  return;
                }
                Navigator.of(context).pop(parsedWasteInput); // Dismiss dialog
              },
            ),
          ],
        );
      }
    );
  }

  static void _showInvalidInputDialog(BuildContext context, String field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          key: Key('invalid dialog'),
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