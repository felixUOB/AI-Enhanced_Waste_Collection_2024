import 'package:ewc/imports/imports.dart';
import 'package:ewc/screens/map/map.dart';
import 'package:ewc/screens/metrics/metrics.dart';
import 'package:ewc/screens/route-schedule/schedule.dart';

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
      body: IndexedStack(
      index: currentPageIndex,
      children: const [
        MetricsPage(),
        MapPage(),
        Schedule()
      ],
    ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const <Widget> [

          // Metrics page icon
          NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              label: "Metrics"
          ),

          // Map page icon
          NavigationDestination(
              icon: Icon(Icons.map),
              label: "Map"
          ),

          // Stops list page icon
          NavigationDestination(
              icon: Icon(Icons.menu_rounded),
              label: "Schedule"
          )

        ]
      ),
    );
  }
}