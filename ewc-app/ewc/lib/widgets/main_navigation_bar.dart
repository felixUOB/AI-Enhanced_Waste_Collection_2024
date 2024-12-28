import 'package:ewc/screens/map/map.dart';
import 'package:ewc/screens/metrics/metrics.dart';
import 'package:ewc/screens/route-schedule/schedule.dart';
import 'package:flutter/material.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<MainNavigationBar> {
  int currentPageIndex = 1; // Set default opening page to map

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the body of the scaffold to be the selected screen
      body: IndexedStack(
        index: currentPageIndex,
        children: [MetricsPage(), MapPage(), Schedule()],
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
