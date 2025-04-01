import 'package:ewc/models/stop_model.dart';
import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/screens/route-schedule/stop_view_dialog.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/route_service.dart';
import 'package:ewc/theme/theme_constants.dart';
import 'package:ewc/widgets/confirm_leave_dialog.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class StopView extends StatefulWidget {
  final int id;
  final String name;
  final bool visited;
  final String? description;

  const StopView({
    super.key,
    required this.id,
    required this.name,
    required this.visited,
    this.description
  });

  @override
  State<StopView> createState() => _StopView();
}

class _StopView extends State<StopView> {

  late bool _oldVisited;
  late bool _newVisited;
  late bool _saved;
  int? _oldWeight;
  int? _newWeight;
  final RouteService _routeService = getIt<RouteService>();

  @override
  void initState() {
    super.initState();
    _oldVisited = widget.visited;
    _newVisited = widget.visited;
    _saved = true;
    _newWeight = Provider.of<StopsProvider>(context, listen: false)
        .stopCollectionLog[widget.id];
    _oldWeight = _newWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: Key('back button'),
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            if ((_newVisited == _oldVisited && _newWeight == _oldWeight) || _saved) {
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
            key: Key('save button'),
            onPressed: () async {
              if (!_saved) {
                if (!_newVisited) {
                  // _newVisited is false, remove stop collection
                  _oldVisited = _newVisited;
                  var stopsProvider = Provider.of<StopsProvider>(context, listen: false);
                  stopsProvider.setVisited(widget.id, false);
                  stopsProvider.removeStopCollection(widget.id);
                  List<Stop> stops = stopsProvider.stops;
                  Stop depot = stopsProvider.depot;
                  LatLng? location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
                  if (location != null) {
                    List<Stop> newOrder = await _routeService.updateOrder(depot, location, stops);
                    if (context.mounted) stopsProvider.updateStopOrder(newOrder);
                  }
                } else if (_newWeight != null) {
                  // _newVisited is true, add stop collection to log
                  _oldWeight = _newWeight;
                  _oldVisited = _newVisited;
                  var stopsProvider = Provider.of<StopsProvider>(context, listen: false);
                  stopsProvider.setVisited(widget.id, true);
                  stopsProvider.addStopCollection(widget.id, _newWeight!);
                  List<Stop> stops = stopsProvider.stops;
                  Stop depot = stopsProvider.depot;
                  LatLng? location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
                  if (location != null) {
                    List<Stop> newOrder = await _routeService.updateOrder(depot, location, stops);
                    if (context.mounted) stopsProvider.updateStopOrder(newOrder);
                  }
                } else {
                  // Entered weight is null, cannot save
                  // Should be impossible to reach this code
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cannot save stop data, entered weight is null.')),
                  );
                }
                
                _saved = true;

                // Successfully updated stops data, show success message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stop status successfully updated.')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stop status already saved.')),
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
            if ((_newVisited == _oldVisited && _newWeight == _oldWeight) || _saved) {
              // Values not been changed since last save, allow exit
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
                      key: Key('stop name'),
                      '${widget.name} - ${_newVisited ? 'Visited' : 'Not visited'}',
                      style: AppTheme().constWhiteTextLarge
                    ),
                  )
                ),
                SizedBox(height: 20),

                // Stop Description
                widget.description != null ?
                Align(alignment: Alignment.topLeft,
                  child: Text(
                    key: Key('stop description'),
                    'Stop Description: \n${widget.description}',
                    style: TextStyle(fontSize: 18),
                )) : SizedBox.shrink(),

                widget.description != null ?
                SizedBox(height: 20) :
                SizedBox.shrink(),

                _newVisited ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      key: Key('collected amount'),
                      'Collected amount - ${_newWeight!}kg'
                    ),
                    // Button to undo stop visit
                    ElevatedButton(
                      key: Key('unvisit button'),
                      onPressed: () {
                        setState(() {
                          _newVisited = false;
                          _newWeight = null;
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
                ) : ElevatedButton(
                  key: Key('visit button'),
                  onPressed: () async {
                    
                    // Display dialog for weight collected
                    int? weightCollected = await StopViewDialog.show(context, widget.name);
                    if (weightCollected == null) {
                      // User clicked cancel button
                      return;
                    }
                    
                    setState(() {
                      _newWeight = weightCollected;
                      _newVisited = true;
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
                    'Mark as visited',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    )
                  )
                )
              ],
            )
          )
        )
      )
    );
  }
}