import 'package:ewc/service_locator.dart';
import 'package:flutter/cupertino.dart';

import 'package:ewc/models/stop_model.dart';
import 'package:ewc/services/stops_service.dart';

class StopsProvider extends ChangeNotifier {
  List<Stop> _stops = [];
  final StopsService _stopsService = getIt<StopsService>();

  List<Stop> get stops => _stops;

  Future<void> initialiseStops() async {
    // Fetch stops from backend
    _stops = await _stopsService.fetchAllStops();
    notifyListeners();
  }

  void setVisited(int stopID) {
    for (Stop stop in _stops) {
      if (stop.id == stopID) {
        stop.visited = true;
        notifyListeners();
        return;
      }
    }
  }
}