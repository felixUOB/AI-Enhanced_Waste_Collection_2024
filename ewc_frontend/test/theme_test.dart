import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ewc/theme/theme_constants.dart';

void main() {
  testWidgets('AppTheme light/dark produces expected text color', (tester) async {
    final appTheme = AppTheme();

    // Check bodyLarge colour in Light mode
    expect(appTheme.lightTheme.textTheme.bodyLarge?.color, Colors.black);

    // Check bodyLarge colour in dark mode
    expect(appTheme.darkTheme.textTheme.bodyLarge?.color, Colors.white);
  });
}