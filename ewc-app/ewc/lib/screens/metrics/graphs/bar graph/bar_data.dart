import 'package:ewc/screens/metrics/graphs/bar%20graph/individual_bar.dart';

class BarData {
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  BarData({
    required this.sunAmount,
    required this.satAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
  });

  List<IndividualBar> barData = [];

  // initaiize bar data
  void initializeBarData(){
    barData = [
      IndividualBar(x: 0, y: sunAmount),
      IndividualBar(x: 0, y: monAmount),
      IndividualBar(x: 0, y: tueAmount),
      IndividualBar(x: 0, y: wedAmount),
      IndividualBar(x: 0, y: thuAmount),
      IndividualBar(x: 0, y: friAmount),
      IndividualBar(x: 0, y: satAmount),
    ];
  }
}