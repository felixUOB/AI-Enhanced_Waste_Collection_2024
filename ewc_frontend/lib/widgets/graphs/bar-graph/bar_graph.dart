import 'package:ewc/widgets/graphs/bar-graph/bar_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// class storing the structure of how the bar graph looks

class MyBarGraph extends StatelessWidget{

  final List weeklySummary;
  // could also pass in maxY and minY, colors etc.

  const MyBarGraph({
    super.key,
    required this.weeklySummary,
  });

  @override
  Widget build(BuildContext context){
    BarData myBarData = BarData(
      monAmount: weeklySummary[0], 
      tueAmount: weeklySummary[1], 
      wedAmount: weeklySummary[2], 
      thuAmount: weeklySummary[3], 
      friAmount: weeklySummary[4],
      satAmount: weeklySummary[5], 
      sunAmount: weeklySummary[6], 
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 10,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
            
          ),
          
        ),
        barGroups: myBarData.barData
        .map(
          (data) => BarChartGroupData(
            x: data.x,
            barRods: [
              BarChartRodData(
                toY: data.y, 
                color: Theme.of(context).colorScheme.primary, 
                width: 25,
                borderRadius: BorderRadius.circular(4),
                backDrawRodData: BackgroundBarChartRodData(
                  show:true,
                  toY: 10,
                  color: Colors.grey.shade400,
                )
              )
              
              ],
          ),
          ).toList(),
      )
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta){
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text = Text('');
  switch (value.toInt()){
    case 0:
      text = const Text('M', style: style);
      break;
    case 1:
      text = const Text('T', style: style);
      break;
    case 2:
      text = const Text('W', style: style);
      break;
    case 3:
      text = const Text('T', style: style);
      break;
    case 4:
      text = const Text('F', style: style);
      break;
    case 5:
      text = const Text('S', style: style);
      break;
    case 6:
      text = const Text('S', style: style);
      break;
  }

  return SideTitleWidget(meta: meta, child: text);
}