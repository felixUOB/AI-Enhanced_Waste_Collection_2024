import 'package:ewc/screens/metrics/graphs/pie-chart/individual-sector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyPieChart extends StatelessWidget {
  final List<double> sectors;

  const MyPieChart({
    super.key,
    required this.sectors,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: _chartSections(_makeSectors(sectors)),
        centerSpaceRadius: 48.0,
      ),
    );
  }

  List<Sector> _makeSectors(List<double> values){
    final List<Sector> sectors = [];
    for (var x in values){
      Sector sec = Sector(value: x);
      sectors.add(sec);
    }
    return sectors;
  }

  List<PieChartSectionData> _chartSections(List<Sector> sectors){
    final List<PieChartSectionData> list = [];
    for (var sector in sectors){
      const double radius = 40;
      final data = PieChartSectionData(
        color: Color.fromARGB(255, math.Random().nextInt(256), math.Random().nextInt(256), math.Random().nextInt(256),),
        value: sector.value,
        radius: radius,
        title: '',
      );
      list.add(data);
    }
    return list;
  }
}