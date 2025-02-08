import 'package:ewc/screens/metrics/route_data.dart';
import 'package:ewc/services/metrics_service.dart';
import 'package:ewc/widgets/graphs/bar-graph/bar_graph.dart';
import 'package:ewc/widgets/graphs/line-graph/line_graph.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {

  List<JourneyRoute> routeList = [];
  // instantiate the variables
  final MetricsService _metricsService = MetricsService();
  double totalDistance = 0;
  double averageMpg = 0;
  int totalRoutes = 0;
  // day of week route : shows the routes done this week by day
  Map<String, double> thisWeekFormated = {
    'Monday' : 0, 
    'Tuesday': 0,
    'Wednesday' : 0,
    'Thursday' : 0,
    'Friday' : 0,
    'Saturday' : 0,
    'Sunday' : 0,
    };
  List<JourneyRoute> thisWeek = [];
  List<Map<String, dynamic>> overallMpg = [];
  List<Map<String, dynamic>> overallDistance = [];
  List<Map<String, dynamic>> fuelConsumed = [];
  List<Map<String, dynamic>> emissions = [];

  // get the data and initialise the list of routes
  // do once when the app is first opened
  @override
  void initState(){
    super.initState();
    main();
  }

  void main() async{
    // get the data from the database
    routeList = await _initialiseMetricData();
    // calculate the total routes, total distance and average Mpg
    _calculateDetails();
    // get the dates that occured this week
    thisWeek = _calculateThisWeek();
    //  put the dates into a nice format
    for (var route in thisWeek){
      DateTime d = DateTime.parse(route.date);
      int dayOfWeek = d.weekday;
      if (dayOfWeek == 1){
        thisWeekFormated['Monday'] = route.distance;
      } else if (dayOfWeek == 2){
        thisWeekFormated['Tuesday'] = route.distance;
      } else if (dayOfWeek == 3){
        thisWeekFormated['Wednesday'] = route.distance;
      } else if (dayOfWeek == 4){
        thisWeekFormated['Thursday'] = route.distance;
      }else if (dayOfWeek == 5){
        thisWeekFormated['Friday'] = route.distance;
      }else if (dayOfWeek == 6){
        thisWeekFormated['Saturday'] = route.distance;
      }else if (dayOfWeek == 7){
        thisWeekFormated['Sunday'] = route.distance;
      } else{
        throw Exception("unvalid");
      }
    }
    
    print(overallDistance);
    print(overallMpg);
  }

  // get the data from the database
  Future<List<JourneyRoute>> _initialiseMetricData() async {
    List<JourneyRoute> routes = await _metricsService.fetchAllRoutes();
    return routes;
  }

  // calculate the total routes, total distance and average Mpg and add to lists
  void _calculateDetails() async {
    totalRoutes = routeList.length;
    double cumulativeMpg =0;
    for (var route in routeList){
      // calculate the total distance
      totalDistance = totalDistance + route.distance;
      // caluclate the average mpg
      cumulativeMpg = cumulativeMpg + route.mpg;
      
      overallMpg.add({'date': route.date, 'value': route.mpg});
      overallDistance.add({'date': route.date, 'value': route.distance});

      // calculate the fuel consumed : number of gallons of fuel consumed
      double fuel =  route.distance/route.mpg;
      emissions.add({'date': route.date, 'value': fuel});
      print(fuel);
      // calculate the emissions using 10.21 kg co2 per galone
      double emitted = (route.distance * 10.21) / route.mpg;
      fuelConsumed.add({'date':route.date, 'value': emitted});
      print(emitted);
    }
    averageMpg = cumulativeMpg / totalRoutes;
    
    // calculate the dates that are in the current week
  }

  // returns the jorunies that occured in the current week
  List<JourneyRoute> _calculateThisWeek() {
    // get the currentWeekday = now.weekday;
   // DateTime now = DateTime.now();
    DateTime now = DateTime(2025, 1, 28);
    // work out when monday was (1 = monday, 7= sunday)
    int daysToSubtract = now.weekday -1;
    DateTime monday = now.subtract(Duration(days: daysToSubtract));
    // genereate this weeks dates
    // List<DateTime> weekDates = List.generate(7, (index){
    //   return startOfWeek.add(Duration(days: index));
    // });
    // get the first and last days of the week
    DateTime sunday = monday.add(Duration(days: 7));
    // returns the list of routes that happened this week
    return routeList.where((item) {
      print("returning stuff");
      // parse the string to be datetime
      DateTime date = DateTime.parse(item.date);
      return date.isAfter(monday.subtract(Duration(days:1))) && date.isBefore(sunday.add(Duration(days:1)));
    }).toList();
  }
  // build the UI for the metrics page
  @override
  Widget build(BuildContext context) {
    // sample data
    return Scaffold(
      // display the graphs as a scrollable list
      body: ListView(children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: StaggeredGrid.count(
              crossAxisCount: 2, // number of columns in the the grid
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              children: [
                StaggeredGridTile.extent(
                    crossAxisCellCount: 2,
                    mainAxisExtent: 300.0,
                    child: _buildTile(
                      Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(children: [
                                Text('Carbon Footprint Bar Graph',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 4.0)),
                                SizedBox(
                                  height: 200,
                                  child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Total Distance : $totalDistance miles", style : TextStyle(fontSize: 20)),
                                      SizedBox(height: 20,),
                                      Text("Average mpg : $averageMpg mpg", style : TextStyle(fontSize: 20)),
                                      SizedBox(height: 20,),
                                      Text("Number of routes completed : $totalRoutes", style : TextStyle(fontSize: 20)),
                                    ],
                                      )
                                  ),
                                  ]),
                                ])),
                        context)),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: 2,
                      mainAxisExtent: 300.0,
                      child: _buildTile(
                          Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(children: [
                                      Text('Weekly Distance Summary',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 4.0)),
                                      SizedBox(
                                        height: 200,
                                        child: MyBarGraph(
                                            key: ValueKey("barGraph"),
                                            weeklySummary: thisWeekFormated.values.toList()),
                                      ),
                                    ]),
                                  ])),
                          context)),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: 2,
                      mainAxisExtent: 300.0,
                      child: _buildTile(
                        Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(children: [
                                    Text('MPG over time',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 4.0)),
                                    SizedBox(
                                      height: 200,
                                      child: MyLineGraph(
                                          key: ValueKey("lineGraph"),
                                          dataPoints: overallMpg),
                                    ),
                                  ]),
                                ])),
                        context, // pass in the context as an argument
                      )),
                  StaggeredGridTile.extent(
                    crossAxisCellCount: 2,
                    mainAxisExtent: 300.0,
                    child: _buildTile(
                      Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(children: [
                                  Text('Distance Over Time',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 4.0)),
                                  SizedBox(
                                    height: 200,
                                    child: MyLineGraph(
                                        key: ValueKey("lineGraph"),
                                        dataPoints: overallDistance),
                                  ),
                                ]),
                              ])),
                      context, // pass in the context as an argument
                    )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: 2,
                      mainAxisExtent: 300.0,
                      child: _buildTile(
                        Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(children: [
                                    Text('Gallons of Fuel Consumed',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 4.0)),
                                    SizedBox(
                                      height: 200,
                                      child: MyLineGraph(
                                          key: ValueKey("lineGraph"),
                                          dataPoints: fuelConsumed),
                                    ),
                                  ]),
                                ])),
                        context, // pass in the context as an argument
                      )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: 2,
                      mainAxisExtent: 300.0,
                      child: _buildTile(
                        Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(children: [
                                    Text('KG of CO2 per Journey',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 4.0)),
                                    SizedBox(
                                      height: 200,
                                      child: MyLineGraph(
                                          key: ValueKey("lineGraph"),
                                          dataPoints: emissions),
                                    ),
                                  ]),
                                ])),
                        context, // pass in the context as an argument
                      )),
                ],
              )),
        ]));
  }
}

// widget box for each of the graphs
Widget _buildTile(Widget child, BuildContext context) {
  return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Theme.of(context).shadowColor,
      child: child);
}
