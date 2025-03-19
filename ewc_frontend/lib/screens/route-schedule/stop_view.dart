import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StopView extends StatefulWidget {
  final int id;
  final String name;
  final bool visited;

  const StopView({
    super.key,
    required this.id,
    required this.name,
    required this.visited
  });

  @override
  State<StopView> createState() => _StopView();
}

class _StopView extends State<StopView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Stop - ${widget.name}",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),


      body: SafeArea(
        child: Column(
          children: [

            // Top half, stop location name
            Expanded(
              child: Container(
                color: Colors.blue[300],
                child: Text(
                  "Test Stop Name",
                  style: AppTheme().constWhiteTextLarge
                ),
              )
            ),

            // Bottom half, buttons
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    Text("Status: ${(widget.visited) ? "Collection logged" : "Collection required"}"),
                    widget.visited ?
                    ElevatedButton(
                      onPressed: () {
                        StopsProvider stopProvider = Provider.of<StopsProvider>(context, listen: false);
                        stopProvider.setVisited(widget.id, false);
                        stopProvider.removeStopCollection(widget.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: spaceNXTGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                      ),
                      child: Text(
                        "Mark as unvisited",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )
                      )
                    ) : SizedBox.shrink()
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }
}