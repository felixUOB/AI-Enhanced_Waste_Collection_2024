import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/screens/map/map.dart';
import 'package:ewc/services/metrics_service.dart';
import 'package:ewc/services/route_service.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:ewc/services/auth_service/auth_service.dart';

// Generate with flutter pub run build_runner build
@GenerateMocks([AuthService, RouteService, StopsService, MetricsService, GeolocatorPlatform, LocationProvider, StopsProvider, Config])
void main() {}
