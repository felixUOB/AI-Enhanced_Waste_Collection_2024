import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/theme/theme_constants.dart';
import 'package:ewc/widgets/confirm_leave_dialog.dart';
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

  late bool _newVisited;
  late bool _saved;

  @override
  void initState() {
    super.initState();
    _newVisited = widget.visited;
    _saved = false;
  }

  @override
  Widget build(BuildContext context) {
    int? amountCollected = Provider.of<StopsProvider>(context, listen: false)
        .stopCollectionLog[widget.id];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            if (_newVisited == widget.visited || _saved) {
              // Visited has not been changed, allow exit
              Navigator.of(context).pop();
            } else {
              // Data has changed and has not been saved, display dialog
              bool shouldPop = await ConfirmLeaveDialog.show(context) ?? false;
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            }
          }
        ),

        actions: [
          IconButton(
            onPressed: () {
              if (_newVisited != widget.visited) {
                // Update stops data if it has changed
                StopsProvider stopProvider = Provider.of<StopsProvider>(context, listen: false);
                stopProvider.setVisited(widget.id, false);
                stopProvider.removeStopCollection(widget.id);

                _saved = true;

                // Successfully updated stops data, show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stop status successfully updated')),
                );
              }
            },
            icon: Icon(Icons.save)
          )
        ],
      ),


      body: SafeArea(
        // PopScope triggers onPopInvokedWithResult() method when user
        // performs Android swipe back gesture
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, _) async {
            if (didPop) {
              return;
            }
            if (_newVisited == widget.visited || _saved) {
              // Visited has not been changed, allow exit
              Navigator.of(context).pop();
            } else {
              final bool shouldPop = await ConfirmLeaveDialog.show(context) ?? false;
              if (shouldPop && context.mounted) {
                Navigator.pop(context);
              }
            }
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints.expand(height: 100),
                  decoration: BoxDecoration(
                    color: _newVisited ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.name} - ${_newVisited ? 'Visited' : 'Not visited'}',
                      style: AppTheme().constWhiteTextLarge
                    ),
                  )
                ),
                SizedBox(height: 20),
                _newVisited ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Collected amount - ${amountCollected!}kg'
                    ),
                    // Button to undo stop visit
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _newVisited = false;
                          _saved = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: spaceNXTGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      ),
                      child: Text(
                        'Mark as unvisited',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        )
                      )
                    )
                  ],
                ) : SizedBox.shrink()
              ],
            )
          )
        )
      )
    );
  }
}