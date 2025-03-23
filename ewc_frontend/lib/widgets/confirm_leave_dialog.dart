import 'package:flutter/material.dart';

// This dialog is displayed when the user tries to exit the stop screen
// without saving
class ConfirmLeaveDialog {
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit stop without saving?'),
          actions: [
            TextButton(
              // Pop the dialog with true value - exit stop page
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Quit without saving')
            ),
            TextButton(
              // Pop the dialog with false value - do not exit stop page
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel')
            )
          ],
        );
      }
    );
  }
}