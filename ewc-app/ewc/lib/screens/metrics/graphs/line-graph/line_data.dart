
import 'package:ewc/screens/metrics/graphs/line-graph/chart_data.dart';

// class storing the structure of the data in the graph 

class LineData {
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  // constructor
  LineData({
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
    required this.sunAmount,
  });

  List<IndividualLineData> lineData = [];

  // initaiise the bar data
  void initializeBarData(){
    lineData = [
      IndividualLineData(x: 0, y: monAmount),
      IndividualLineData(x: 1, y: tueAmount),
      IndividualLineData(x: 2, y: wedAmount),
      IndividualLineData(x: 3, y: thuAmount),
      IndividualLineData(x: 4, y: friAmount),
      IndividualLineData(x: 5, y: satAmount),
      IndividualLineData(x: 6, y: sunAmount),
    ];
  }
}