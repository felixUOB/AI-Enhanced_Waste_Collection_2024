import 'package:ewc/service_locator.dart';
import 'package:flutter/cupertino.dart';

import 'package:ewc/models/stop_model.dart';
import 'package:ewc/services/stops_service.dart';

class StopsProvider extends ChangeNotifier {
  List<Stop> _stops = [];
  final StopsService _stopsService = getIt<StopsService>();

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
        notifyListeners();
        return;
      }
    }
  }
}