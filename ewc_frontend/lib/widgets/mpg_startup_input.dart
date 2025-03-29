import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MPGInputDialog extends StatefulWidget {
  const MPGInputDialog({super.key});

  @override
  MPGInputDialogState createState() => MPGInputDialogState();
}

class MPGInputDialogState extends State<MPGInputDialog> {
  TextEditingController mpgController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter your vehicle's Miles per Gallon"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: mpgController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "Miles per Gallon",
              errorText: errorText,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            double? mpgValue = double.tryParse(mpgController.text);

            if (mpgValue == null || mpgValue <= 0) {
              setState(() {
                errorText = "MPG must be a positive number.";
              });
              return;
            }

            var box = await Hive.openBox('Settings');
            await box.put('mpg', mpgValue);
            await box.flush();

            if (!mounted) return;
            if (!context.mounted) return;
            Navigator.pop(context, mpgValue); // Close dialog & return value
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ],
    );
  }
}