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
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: Text("Mark as unvisited")
              ) : SizedBox.shrink()
            ],
          ),
        )
      ),
    );
  }
}