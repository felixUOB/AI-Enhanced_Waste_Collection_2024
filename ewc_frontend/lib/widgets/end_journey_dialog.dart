import 'package:flutter/material.dart';

/// This file manages the end journey dialog.
///
/// Functions:
/// - `show()`: Displays the end journey dialog.
/// - `showInvalidInputDialog()`: Shows a dialog for invalid input notifications.

class EndJourneyDialog {
  static void show(BuildContext context, Function(double) onConfirm) {
    String mpgInput = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('End Journey'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Miles per Gallon'),
            onChanged: (value) => mpgInput = value,
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
                final parsedMpg = double.tryParse(mpgInput);
                if (parsedMpg == null) {
                  _showInvalidInputDialog(context, 'Miles per Gallon');
                  return;
                }

                // Valid input: call the onConfirm callback
                onConfirm(parsedMpg);

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