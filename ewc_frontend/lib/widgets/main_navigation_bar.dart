import 'package:ewc/screens/map/map.dart';
import 'package:ewc/screens/metrics/metrics.dart';
import 'package:ewc/screens/route-schedule/schedule.dart';
import 'package:ewc/screens/settings/settings.dart';
import 'package:flutter/material.dart';

/// This file manages the main navigation bar widget.
///
/// Functions:
/// - `build()`: Builds the main navigation bar widget.
/// - 'onDestinationSelected()': Function to handle the navigation bar button presses.

class MainNavigationBar extends StatefulWidget {
  final bool testing;
  const MainNavigationBar({super.key, required this.testing});

  @override
  State<MainNavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<MainNavigationBar> {
  int currentPageIndex = 1; // Set default opening page to map

  @override
  Widget build(BuildContext context) {

    // titles for each tab
    final List<String> appBarTitles = [
      'Journey Statistics',
      'RecycleNXT',
      'Schedule',
      'Settings',
    ];

    return Scaffold(
      key: Key("mainNavigationBar"),
      appBar: AppBar(
        title: Text(
          appBarTitles[currentPageIndex],
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
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
          !widget.testing
          ? Schedule(
            key: ValueKey("schedulePage"),
          )
          : Container(
            key: ValueKey("schedulePageReplacement"),
            color: Colors.green,
            child: Center(
              child: Text("TESTING - SCHEDULE DISABLED"),
            ),
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

            NavigationDestination(icon: Icon(Icons.settings), label: "Settings")
          ]),
    );
  }
}
