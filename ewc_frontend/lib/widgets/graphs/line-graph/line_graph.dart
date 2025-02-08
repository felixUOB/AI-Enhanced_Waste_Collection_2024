
import 'package:ewc/widgets/graphs/bar-graph/bar_graph.dart';
import 'package:ewc/widgets/graphs/line-graph/line_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyLineGraph extends StatelessWidget{
  final List weeklySummary;

  const MyLineGraph({
    super.key,
    required this.weeklySummary,
  });

  @override
  Widget build(BuildContext context){

    LineData myLineData = LineData(
      monAmount: weeklySummary[0], 
      tueAmount: weeklySummary[1], 
      wedAmount: weeklySummary[2], 
      thuAmount: weeklySummary[3], 
      friAmount: weeklySummary[4],
      satAmount: weeklySummary[5], 
      sunAmount: weeklySummary[6], 
    );
    myLineData.initializeBarData();
    
    // work out the maxY based on the data
    double maxY = (weeklySummary
    .map((e) => (e as num).toDouble()) //make sure its a number
    .reduce((a,b)=> a > b ? a : b) * 1.2) // add extra space
    .ceilToDouble(); // make whole number

    return LineChart(
      LineChartData(
        maxY: maxY,
        minY: 0,
        // draw the background lines
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3), // Adjust color for visibility
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          border: const Border(
            bottom: BorderSide(color: Colors.grey, width: 4),
            ),
        ),
        titlesData: FlTitlesData(
          // ones we want
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: getBottomTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: getLeftTitles,
              ),
            ),
          // ones we dont want
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: myLineData.lineData
            .map((point) => FlSpot(point.x.toDouble(), point.y)).toList(),
            isCurved: true,
            dotData: FlDotData(show:true),
            // #077b41
            color: Theme.of(context).colorScheme.primary,
            barWidth: 4,
          ),
        ],
      ),
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
    default:
      text = Text('', style: style);
    }
    return SideTitleWidget(meta: meta, child: text);

}

Widget getLeftTitles(double value, TitleMeta meta){
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 10,
  );
  String text;
  // only display the even values on the scale
  if (value % 2 == 0){
    text = value.toInt().toString();
  }else{
    return Container(); // dont display just have a space 
  }
  return SideTitleWidget(
    meta: meta,
    child: Text(text, style:style),
    );
}