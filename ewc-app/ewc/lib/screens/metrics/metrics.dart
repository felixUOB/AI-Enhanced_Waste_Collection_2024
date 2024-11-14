
import 'package:ewc/widgets/graphs/bar-graph/bar_graph.dart';
import 'package:ewc/widgets/graphs/line-graph/line_graph.dart';
import 'package:ewc/widgets/graphs/pie-chart/pie_chart.dart';
import 'package:ewc/imports/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MetricsPage extends StatefulWidget{

  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage>{
  @override
  Widget build(BuildContext context){

    // Holds the Titles for the widgets 
    final List metrics = ['Carbon Footprint Bar Graph', 'Fuel Consumption', 'Carbon Footprint Line Graph', 'Fuel Consumption Pie Chart'];

    // list of the graphs
    // read database to get these values
    List<double> carbonFootPrintData= [
      2.4,
      2.4,
      3.2,
      4.5,
      6.7,
      6.7,
      5.4
    ];
    List<double> fuelConsumptionData= [
      2.4,
      2.4,
      3.2,
      4.5,
      6.7,
      6.7,
      5.4
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        //backgroundColor: Theme.of(context).canvasColor,
        title: Text('Metrics Page', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          SafeArea(
          child: Container(
              // ignore: prefer_const_literals_to_create_immutables
              margin: EdgeInsets.only(right: 8.0),
              child: Column(
                children: [
                  Padding(
                  padding: const EdgeInsets.all(3),
                  child:
                    // ignore: prefer_const_constructors
                    Align(
                      alignment: Alignment.topRight, 
                      // ignore: prefer_const_constructors
                      child: ThemeSwitch(),
                    )
                  )
                ],
              )
          ))// ignore: prefer_const_constructor 
          ],
      ),
      body: ListView(
        children: [Padding(
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
                          Column(
                            children: [
                              Text('Carbon Footprint Bar Graph',
                              style: Theme.of(context).textTheme.titleMedium),
                              Padding(padding: EdgeInsets.only(bottom: 4.0)),
                              SizedBox(
                                height: 200,
                                child: MyBarGraph(weeklySummary: carbonFootPrintData),
                              ),
                            ]
                          ),
                        ]
                      )
                    ),
                    context
                  )
              ),
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
                          Column(
                            children: [
                              Text('Carbon Footprint Line Graph',
                              style: Theme.of(context).textTheme.titleMedium),
                              Padding(padding: EdgeInsets.only(bottom: 4.0)),
                              SizedBox(
                                height: 200,
                                child: MyLineGraph(weeklySummary: carbonFootPrintData),
                              ),
                            ]
                          ),
                        ]
                      )
                    ), 
                    context, // pass in the context as an argument 
                  )
              ),
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
                          Column(
                            children: [
                              Text('Carbon Footprint Pi Graph',
                              style: Theme.of(context).textTheme.titleMedium),
                              Padding(padding: EdgeInsets.only(bottom: 4.0)),
                              SizedBox(
                                height: 200,
                                child: MyPieChart(sectors: carbonFootPrintData),
                              ),
                            ]
                          ),
                        ]
                      )
                    ),
                    context // pass in the context as an argument
                )
              )   
            ],
          )
        ),
        ]
      ) 
      
    );

  }
}

Widget _buildTile(Widget child, BuildContext context){
  return Material(
    elevation: 14.0,
    borderRadius: BorderRadius.circular(12.0),
    shadowColor: Theme.of(context).shadowColor,
    child: child
  );
}