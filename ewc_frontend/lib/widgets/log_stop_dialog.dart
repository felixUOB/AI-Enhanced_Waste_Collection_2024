import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:flutter/material.dart';

import 'package:ewc/models/stop_model.dart';
import 'package:provider/provider.dart';

class LogStopDialog {
  static void show(BuildContext context, Function(int, int) onConfirm) {
    int? selectedStop;
    String wasteCollectedInput = '';
    List<Stop> stops = Provider.of<StopsProvider>(context, listen: false).stops;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Register Collection'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                DropdownMenu<int>(
                  enableSearch: false,
                  hintText: 'Select stop',
                  dropdownMenuEntries:
                    stops.map((stop) => DropdownMenuEntry(value: stop.id, label: stop.name)).toList(),
                  onSelected: (value) => selectedStop = value,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Mass of waste collected (kg)'),
                  onChanged: (value) => wasteCollectedInput = value,
                ),
              ]
            )
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
                final parsedWasteInput = int.tryParse(wasteCollectedInput);
                if (selectedStop == null) {
                  _showInvalidInputDialog(context, 'stop');
                  return;
                }
                if (parsedWasteInput == null || parsedWasteInput < 0) {
                  _showInvalidInputDialog(context, 'collection amount');
                  return;
                }

                // Valid input: call the onConfirm callback
                onConfirm(selectedStop!, parsedWasteInput);

                Navigator.of(context).pop(); // Dismiss dialog
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