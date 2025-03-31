import 'package:ewc/service_locator.dart';
import 'package:flutter/cupertino.dart';

import 'package:ewc/models/stop_model.dart';
import 'package:ewc/services/stops_service.dart';

/// This file manages the state of the stops and provides
/// functionality to interact with the list of stops.
///
/// Functions:
/// - `addStopCollection()`: Add stop collection to stopCollectionLog.
/// - `removeStopCollection()`: Remove stop collection from stopCollectionLog.
/// - `initialiseStops()`: Initializes and fetches stops from the service.
/// - `setVisited(int stopID, bool value)`: Marks a stop's visited attribute according to value argument.
/// - `addCustomListener()`: Adds listener to provider.
/// - `reset()`: Resets provider upon logging out of app.

class StopsProvider extends ChangeNotifier {
  List<Stop> _stops = [];
  final StopsService _stopsService = getIt<StopsService>();
  final List<VoidCallback> _listeners = [];

  // Map which keeps track of each stop collection
  // Data gets sent to backend when user clicks end journey
  final Map<int, int> _stopCollectionLog = {};

  List<Stop> get stops => _stops;
  Map<int, int> get stopCollectionLog => _stopCollectionLog;

  // Adds a stop collection to the stop collection log
  void addStopCollection(int id, int weight) {
    _stopCollectionLog[id] = weight;
  }

  // Removes a stop collection from the stop collection log
  void removeStopCollection(int id) {
    _stopCollectionLog.remove(id);
  }

  Future<void> initialiseStops() async {
    // Fetch stops from backend
    _stops = await _stopsService.fetchAllStops();
    notifyListeners();
  }

  void updateStopOrder(List<Stop> newStops) {
    // Previously visited stops must be added to new list first so they remain
    // at top of schedule page list
    List<Stop> newStopOrder = [];
    for (Stop stop in _stops) {
      if (stop.visited) {
        newStopOrder.add(stop);
      }
    }

    newStopOrder.addAll(newStops);
    _stops = newStopOrder;
    notifyListeners();
  }

  void setVisited(int stopID, bool value) {
    for (Stop stop in _stops) {
      if (stop.id == stopID) {
        stop.visited = value;
        return;
      }
    }
  }

  void addCustomListener(VoidCallback listener) {
    _listeners.add(listener);
    addListener(listener);
  }

  void reset() {
    _stops.clear();
    _stopCollectionLog.clear();
    for (final listener in _listeners) {
      removeListener(listener);
    }
    _listeners.clear();
  }
}