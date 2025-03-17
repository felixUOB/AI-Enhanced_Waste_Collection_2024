import 'package:ewc/screens/metrics/route_data.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/metrics_service.dart';
import 'package:ewc/widgets/graphs/bar-graph/bar_graph.dart';
import 'package:ewc/widgets/graphs/line-graph/line_graph.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

class MetricsPage extends StatefulWidget {

  final bool testingMode;

  const MetricsPage({super.key, this.testingMode = false});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  List<JourneyRoute> routeList = [];
  // instantiate the variables
  final MetricsService _metricsService = getIt<MetricsService>();

  bool get isTesting => widget.testingMode;

  double totalDistance = 0;
  double averageMpg = 0;
  int totalRoutes = 0;
  // day of week route : shows the routes done this week by day
  Map<String, double> thisWeekFormatted = {
    'Monday' : 0, 
    'Tuesday': 0,
    'Wednesday' : 0,
    'Thursday' : 0,
    'Friday' : 0,
    'Saturday' : 0,
    'Sunday' : 0,
  };

  // holds the journeys that have occured on this week
  List<JourneyRoute> thisWeeksJourneys = [];
  List<Map<String, dynamic>> overallMpg = [];
  List<Map<String, dynamic>> overallDistance = [];
  List<Map<String, dynamic>> fuelConsumed = [];
  List<Map<String, dynamic>> emissions = [];

  // get the data and initialise the list of routes
  // do once when the app is first opened
  @override
  void initState(){
    super.initState();
    _fetchMetricsDate();
  }

  Future<void> _fetchMetricsDate() async{
    List<JourneyRoute> fetchedRoutes = await _initialiseMetricData();
    List<JourneyRoute> updatedRoutes = [];
    // fill in the spare days
    if (fetchedRoutes.length >1){
      // sort the data
      fetchedRoutes.sort((a,b) => a.date.compareTo(b.date));

      // loop around all of the days currently in the array and fill in any blank days
      int len = fetchedRoutes.length-1;
      int i =0;
      while (i<len){
        // get the first day
        DateTime current = DateTime.parse(fetchedRoutes[i].date);
        
        // combine entries that were on the same day
        double totalDistance = fetchedRoutes[i].distance;
        var mpg = [fetchedRoutes[i].mpg];
        
        while(fetchedRoutes[i].date == fetchedRoutes[i+1].date){
          totalDistance += fetchedRoutes[i+1].distance;
          mpg.add(fetchedRoutes[i+1].mpg);
          i++;
        }
        double avgMpg = mpg.reduce((a,b) => (a+b)) / mpg.length;
        updatedRoutes.add(JourneyRoute(distance: totalDistance, mpg: avgMpg, date: current.toString(), filler: false));

        // fill in any gaps
        DateTime next = DateTime.parse(fetchedRoutes[i+1].date);
        // see if the day after current is the next day or identify if there is a gap
        while (!current.add(Duration(days: 1)).isAtSameMomentAs(next)){
            current = current.add(Duration(days: 1));
            // add a filler day
            updatedRoutes.add(JourneyRoute(distance: 0, mpg: 0, date: current.toString(), filler: true));
        }
        i ++;
      }
    }
    updatedRoutes.sort((a,b) => a.date.compareTo(b.date));
    routeList = updatedRoutes;
    _calculateDetails();
    thisWeeksJourneys = _calculateThisWeek();
    // update the state of the graphs
    setState((){
      //  put the dates into a nice format
      for (var route in thisWeeksJourneys){
        DateTime d = DateTime.parse(route.date);
        int dayOfWeek = d.weekday;
        if (dayOfWeek == 1){
          thisWeekFormatted['Monday'] = route.distance;
        } else if (dayOfWeek == 2){
          thisWeekFormatted['Tuesday'] = route.distance;
        } else if (dayOfWeek == 3){
          thisWeekFormatted['Wednesday'] = route.distance;
        } else if (dayOfWeek == 4){
          thisWeekFormatted['Thursday'] = route.distance;
        }else if (dayOfWeek == 5){
          thisWeekFormatted['Friday'] = route.distance;
        }else if (dayOfWeek == 6){
          thisWeekFormatted['Saturday'] = route.distance;
        }else if (dayOfWeek == 7){
          thisWeekFormatted['Sunday'] = route.distance;
        }
      }
    });
  }

  // get the data from the database
  Future<List<JourneyRoute>> _initialiseMetricData() async {

    // if its in testing mode return fake data instead of the stuff from the db
    if (isTesting){
      String today = DateTime.now().toString().split(' ')[0];
      String yesterday = (DateTime.now().subtract(Duration(days: 1))).toString().split(' ')[0];
      return [
        JourneyRoute(date: today, distance: 50, mpg: 10, filler: false),
        JourneyRoute(date: yesterday, distance: 30, mpg: 8, filler: false),
      ];
    }
    return await _metricsService.fetchLast30Days();
    //return await _metricsService.fetchAllRoutes();
  }

  // calculate the total routes, total distance and average Mpg and add to lists
  void _calculateDetails() async {

    if (routeList.isNotEmpty) {
      double cumulativeMpg =0;
      for (var route in routeList){
        // make sure its an actual value and not a fake one
        if (route.filler == false){
          totalRoutes ++;
          // calculate the total distance
          totalDistance += route.distance;
          // caluclate the average mpg
          cumulativeMpg += route.mpg;
          // calculate the fuel consumed : number of gallons of fuel consumed
          double fuel =  route.distance/route.mpg;
          // calculate the emissions using 10.21 kg co2 per gallons
          double emitted = (route.distance * 10.21) / route.mpg;
          
          fuelConsumed.add({'date':route.date, 'value': fuel});
          emissions.add({'date': route.date, 'value': emitted});
          overallMpg.add({'date': route.date, 'value': route.mpg});
          overallDistance.add({'date': route.date, 'value': route.distance});
        } else{
          // the data doesn't actually exist so just use 0's
          fuelConsumed.add({'date':route.date, 'value': 0});
          emissions.add({'date': route.date, 'value': 0});
          overallMpg.add({'date': route.date, 'value': 0});
          overallDistance.add({'date': route.date, 'value': 0});
        }
      }
      if (totalRoutes >0 ){
        averageMpg = (cumulativeMpg / totalRoutes).truncateToDouble();
      }
    }
  }
  // returns the journies that occured in the current week
  List<JourneyRoute> _calculateThisWeek() {
    // get the currentWeekday = now.weekday;
    DateTime now = DateTime.now();
    // work out when monday was (1 = monday, 7= sunday)
    int daysToSubtract = now.weekday -1;
    DateTime monday = now.subtract(Duration(days: daysToSubtract));
    DateTime sunday = monday.add(Duration(days: 7));
    // returns the list of routes that happened this week
    return routeList.where((item) {
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
                                Text('Summary of last 30 days:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Padding(
                                    padding:
                                        EdgeInsets.only(
                                          bottom: 4.0)),
                                SizedBox(
                                  height: 200,
                                  child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: 
                                          Text("Total Distance : $totalDistance miles", 
                                          style : TextStyle(fontSize: 20)),
                                        ),
                                      SizedBox(height: 20,),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: 
                                          Text("Average mpg : $averageMpg mpg", 
                                          style : TextStyle(fontSize: 20)),
                                      ),
                                      SizedBox(height: 20,),
                                      FittedBox(
                                        fit:BoxFit.scaleDown,
                                        child: 
                                          Text("Number of routes completed : $totalRoutes", 
                                          style : TextStyle(fontSize: 20)
                                        ),
                                      ),
                                    ],
                                      )
                                  ),
                                  ]),
                                ])),
                        context,
                        "This graph shows some summary data about the journeys you have completed."
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
                                            weeklySummary: thisWeekFormatted.values.isNotEmpty ? thisWeekFormatted.values.toList() : [0,0,0,0,0,0,0]),
                                      ),
                                    ]),
                                  ])),
                          context,
                          "This graph shows how far you have travelled on your journeys this week.",
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
                                    Text('MPG over last 30 days',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 4.0)),
                                    SizedBox(
                                      height: 200,
                                      child: MyLineGraph(
                                          key: ValueKey("lineGraph"),
                                          dataPoints: overallMpg.isNotEmpty ? overallMpg : [{'date': DateTime.now().toString(), 'value': 0}]),
                                    ),
                                  ]),
                                ])),
                        context,
                        "This graph shows the mpg for each journey you have completed." // pass in the context as an argument
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
                                  Text('Distance Over the last 30 days',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 4.0)),
                                  SizedBox(
                                    height: 200,
                                    child: MyLineGraph(
                                        key: ValueKey("lineGraph"),
                                        dataPoints: (overallDistance.isNotEmpty ? overallDistance : [{'date': DateTime.now().toString(), 'value': 0}] ),
                                  ),),
                                ]),
                              ])),
                      context,
                      "This graph shows the amount of distance traveled for each journey." // pass in the context as an argument
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
                                          dataPoints: fuelConsumed.isNotEmpty ? fuelConsumed : [{'date': DateTime.now().toString(), 'value': 0}]),
                                    ),
                                  ]),
                                ])),
                        context,
                        "This graph hows the amount of fuel consumed in gallons over all of your journeys." // pass in the context as an argument
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
                                          // check to see if the list is empty, if it is use a defult 
                                          dataPoints: emissions.isNotEmpty ? emissions : [{'date': DateTime.now().toString(), 'value': 0}]),
                                    ),
                                  ]),
                                ])),
                        context,
                        "This graph shows the amount of CO2 produced from each journey you have completed in KG's" // pass in the context as an argument
                      )),
                ],
              )),
        ]));
  }
}

// widget box for each of the graphs
Widget _buildTile(Widget child, BuildContext context, String hoverMessage ) {
  return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Theme.of(context).shadowColor,
      child: Tooltip(
            message: hoverMessage,
            margin: const EdgeInsets.all(24.0),
            preferBelow: false,
            child: child,
          ),
        
      
  );
}
