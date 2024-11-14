
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
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0), 
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: myLineData.lineData.map((point) => FlSpot(point.x.toDouble(), point.y)).toList(),
              isCurved: false,
              dotData: FlDotData(
                show:false,
              ),
              // #077b41
              color: Theme.of(context).colorScheme.primary,
              barWidth: 4,
            ),
          ],
          borderData: FlBorderData(
            border: const Border(
              bottom: BorderSide(color: Colors.grey, width: 4),
              
            ),
          ),
          gridData: FlGridData(show: false),

          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          )
        ),
      ),
    );
  }
}
SideTitles get _bottomTitles => SideTitles(
  showTitles: true,
  getTitlesWidget: (value, meta) {
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
    return text;
  },
  interval: 1,
);
