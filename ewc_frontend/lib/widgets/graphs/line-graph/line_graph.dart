
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // date formatting

class MyLineGraph extends StatelessWidget{
  final List<Map<String, dynamic>> dataPoints;

  const MyLineGraph({
    super.key,
    this.dataPoints = const [], 
  });

  @override
  Widget build(BuildContext context){
    // get the data points in FlSpot format
    List<FlSpot> points = dataPoints.asMap().entries.map((entry) {
        int index = entry.key;
        if (entry.value['value'] != 0){
          double value = (entry.value['value'] as num).toDouble();
          return FlSpot(index.toDouble(), value);
        } else{
          return FlSpot.nullSpot;
        }
      }).toList();

    // work out the maxY based on the data
    double maxY = (dataPoints.map((e) => (e['value'] as num).toDouble()) //make sure its a number
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
              color: Colors.grey, // Adjust color for visibility
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey,
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
             // interval: (dataPoints.length).ceilToDouble(), // space out the labels on the bottom axis
              getTitlesWidget: (value, meta) => 
              getBottomTitles(value, meta, dataPoints),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              getTitlesWidget: getLeftTitles,
              ),
            ),
          // ones we dont want
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: points,
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

Widget getBottomTitles(double value, TitleMeta meta, List<Map<String, dynamic>> dataPoints){
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    int index = value.toInt();
    if (index < 0 || index >= dataPoints.length){
       return Container();
    }

    DateTime date = DateTime.parse(dataPoints[index]['date']);
    
    // display only the day (dd)
    String dayLabel = DateFormat('dd').format(date);
    // show month name (MM) only on the first of the month
    if (index == 0 || date.month != DateTime.parse(dataPoints[index - 1]['date']).month){
      dayLabel = DateFormat('ddMMM').format(date);
    }
    
    return SideTitleWidget(
      meta: meta, 
      child: Text(dayLabel, style:style),
    );
}

Widget getLeftTitles(double value, TitleMeta meta){
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 10,
  );
  // only display the even values on the scale
  if (value == 0 || value % 5 == 0 || meta.axisSide == AxisSide.left && meta.max <5){
    String text = value.toInt().toString();
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style:style),
    );
  }else{
    return Container(); // don't display just have a space 
  }
  
}