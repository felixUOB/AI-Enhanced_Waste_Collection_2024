
import 'package:ewc/widgets/graphs/line-graph/individual_line_data.dart';

/// This file contains the line data for the line graph.
///
/// Functions:
/// - `initializeLineData()`: Initializes the line data.

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

  // initialise the line data
  void initializeLineData(){
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