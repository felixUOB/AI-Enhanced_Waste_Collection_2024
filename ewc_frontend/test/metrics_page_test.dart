import 'package:ewc/screens/metrics/metrics.dart';
import 'package:ewc/widgets/graphs/bar-graph/bar_graph.dart';
import 'package:ewc/widgets/graphs/line-graph/line_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  testWidgets('MetricsPage renders correctly', (WidgetTester tester) async {
    // Build the MetricsPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: MetricsPage(testingMode: true),
      ),
    );

    // Verify that the key UI elements are present
    expect(find.text('Carbon Footprint Bar Graph'), findsOneWidget);
    expect(find.text('Weekly Distance Summary'), findsOneWidget);
    expect(find.text('MPG over time'), findsOneWidget);
    expect(find.text('Distance Over Time'), findsOneWidget);
    expect(find.text('Gallons of Fuel Consumed'), findsOneWidget);
    expect(find.text('KG of CO2 per Journey'), findsOneWidget);

    // Verify that the graphs are present
    expect(find.byType(MyBarGraph), findsOneWidget);
    expect(find.byType(MyLineGraph), findsNWidgets(4)); // Multiple line graphs
  });

}