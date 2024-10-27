
import 'package:ewc/screens/metrics/graphs/bar-graph/bar_graph.dart';
import 'package:ewc/screens/metrics/graphs/line-graph/line_graph.dart';
import 'package:ewc/screens/metrics/widgets/square.dart';
import 'package:flutter/material.dart';

class MetricsPage extends StatefulWidget{

  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage>{
  @override
  Widget build(BuildContext context){

    // Holds the Titles for the widgets 
    final List metrics = ['Carbon Footprint Bar Graph', 'Fuel Consumption', 'Carbon Footprint Line Graph'];

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

    List<Widget> graphs = [
      barGraph(carbonFootPrintData), 
      barGraph(fuelConsumptionData), 
      lineGraph(carbonFootPrintData),
      ];


    return Scaffold(
      body: Column(
        children: [
          // title
          title("Metric Display Screen"),

          // returns a scrollable list of graphs
          Expanded(
            child: ListView.builder(
              itemCount: graphs.length,
              itemBuilder: (context, index){
                return MySquare(
                  title: metrics[index], 
                  child: graphs[index]
                );
              },
            ),
          ),

        ],
      ),
    );

  }
}

Widget barGraph(List<double> data){
  return Center(
      child: SizedBox(
        height: 200,
        child: MyBarGraph(
          weeklySummary: data,
        )
    ),
  );
}

Widget lineGraph(List<double> data){
  return Center(
    child: SizedBox(
      height: 200,
      child: MyLineGraph(
        weeklySummary: data,
      ),
    ),
  );
}

Widget title(String text){
  return Center(
    child: Text(
      text,
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}