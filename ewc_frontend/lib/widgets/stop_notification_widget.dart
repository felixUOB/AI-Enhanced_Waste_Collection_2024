import 'package:flutter/material.dart';
import 'package:ewc/models/stop_model.dart';

class StopNotificationWidget extends StatelessWidget {
  final Stop stop;
  final VoidCallback onDismiss;

  const StopNotificationWidget({
    Key? key,
    required this.stop,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 20,
      right: 20,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(8),
        child: Dismissible(
          key: ValueKey(stop.id),
          direction: DismissDirection.up,
          onDismissed: (direction) => onDismiss(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // First row: Upcoming stop text and close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Upcoming Stop: ${stop.name}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: onDismiss,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Second row: Additional instruction message with an inline icon
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't forget to log this stop by pressing ",
                          style: TextStyle(color: Colors.white),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.where_to_vote,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}