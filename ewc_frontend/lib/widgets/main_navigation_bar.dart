import 'package:ewc/screens/map/map.dart';
import 'package:ewc/screens/metrics/metrics.dart';
import 'package:ewc/screens/route-schedule/schedule.dart';
import 'package:ewc/services/route_plot_service.dart';
import 'package:ewc/screens/settings/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore: must_be_immutable
class MainNavigationBar extends StatefulWidget {
  bool testing;
  MainNavigationBar({super.key, required this.testing});

  @override
  State<MainNavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<MainNavigationBar> {
  bool isRouteServiceInitialized = false;
  int currentPageIndex = 1; // Set default opening page to map
  late RouteService? routeService;

  Future<void> initRouteService() async {
    await dotenv.load();
    routeService = RouteService(dotenv.env['API_KEY']!);

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
      key: Key("mainNavigationBar"),
      // Set the body of the scaffold to be the selected screen
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          MetricsPage(
            key: ValueKey("metricsPage"),
          ),
          !widget.testing
              ? MapPage(
                  key: ValueKey("mapPage"),
                )
              : Container(
                  key: ValueKey("mapPageReplacement"),
                  color: Colors.green,
                  child: Center(
                    child: Text("TESTING - MAP DISABLED"),
                  ),
                ),
          Schedule(
            key: ValueKey("schedulePage"),
          ),
          SettingPage(
            key : ValueKey("settingPage")
          )
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
                icon: Icon(Icons.bar_chart_outlined), label: "Metrics"),

            // Map page icon
            NavigationDestination(icon: Icon(Icons.map), label: "Map"),

            // Stops list page icon
            NavigationDestination(
                icon: Icon(Icons.menu_rounded), label: "Schedule"),

            NavigationDestination(
                icon: Icon(Icons.settings), label: "Settings")
          ]),
    );
  }
}
