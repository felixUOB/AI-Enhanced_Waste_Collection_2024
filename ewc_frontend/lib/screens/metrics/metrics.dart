import 'package:ewc/widgets/graphs/bar-graph/bar_graph.dart';
import 'package:ewc/widgets/graphs/line-graph/line_graph.dart';
import 'package:ewc/widgets/graphs/pie-chart/pie_chart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  @override
  Widget build(BuildContext context) {
    // sample data
    List<double> carbonFootPrintData = [2.4, 2.4, 3.2, 4.5, 6.7, 6.7, 5.4];
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
                                            Text("Total Distance : ", style : TextStyle(fontSize: 20)),
                                            SizedBox(height: 20,),
                                            Text("Average mpg : ", style : TextStyle(fontSize: 20)),
                                            SizedBox(height: 20,),
                                            Text("Total routes completed : ", style : TextStyle(fontSize: 20)),
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
                                            weeklySummary: carbonFootPrintData),
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
                                          weeklySummary: carbonFootPrintData),
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
                                  Text('Emissions',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 4.0)),
                                  SizedBox(
                                    height: 200,
                                    child: MyLineGraph(
                                        key: ValueKey("lineGraph"),
                                        weeklySummary: carbonFootPrintData),
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
                                    Text('Fuel consumed',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 4.0)),
                                    SizedBox(
                                      height: 200,
                                      child: MyLineGraph(
                                          key: ValueKey("lineGraph"),
                                          weeklySummary: carbonFootPrintData),
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
