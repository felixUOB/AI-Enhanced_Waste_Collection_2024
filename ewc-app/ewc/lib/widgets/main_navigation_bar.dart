import 'package:ewc/screens/map/map.dart';
import 'package:ewc/screens/metrics/metrics.dart';
import 'package:ewc/screens/route-schedule/schedule.dart';
import 'package:ewc/services/route_plot_api.dart';
import 'package:flutter/material.dart';
import 'package:ewc/screens/map/map_service.dart' as mapService;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MainNavigationBar extends StatefulWidget {
  RouteService? altRouteService;
  MainNavigationBar({super.key, required this.altRouteService});

  @override
  State<MainNavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<MainNavigationBar> {
  bool isRouteServiceInitialized = false;
  int currentPageIndex = 1; // Set default opening page to map
  late RouteService? routeService;

  Future<void> initRouteService() async {
    if (widget.altRouteService != null) {
      routeService = widget.altRouteService;
    } else {
      await dotenv.load();
      routeService = RouteService(dotenv.env['API_KEY']!);
    }

    setState(() {
      isRouteServiceInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initRouteService();
  }

  @override
  Widget build(BuildContext context) {
    if (!isRouteServiceInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      // Set the body of the scaffold to be the selected screen
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          MetricsPage(),
          MapPage(routeService: routeService),
          Schedule()
        ],
      ),
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            // This function is ran when the user clicks a tab on the navigation bar
            // The parameter 'index' corresponds to which of the 3 buttons the user has clicked:
            //   Metrics page - 0
            //   Map page - 1
            //   Schedule page - 2

            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          labelBehavior:
              NavigationDestinationLabelBehavior.alwaysHide, // Hide icon labels
          destinations: const <Widget>[
            // This array tells the navigation bar which icons it needs to display

            // Metrics page icon
            NavigationDestination(
                key: Key("metricsLink"),
                icon: Icon(Icons.bar_chart_outlined),
                label: "Metrics"),

            // Map page icon
            NavigationDestination(
                key: Key("mapLink"), icon: Icon(Icons.map), label: "Map"),

            // Stops list page icon
            NavigationDestination(
                key: Key("scheduleLink"),
                icon: Icon(Icons.menu_rounded),
                label: "Schedule")
          ]),
    );
  }
}
