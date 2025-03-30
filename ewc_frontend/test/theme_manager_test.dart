import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ewc/theme/theme_manager.dart';

void main() {
  test('toggleTheme changes themeMode correctly', () {
    final manager = ThemeManager();

    // Default: ThemeMode.light
    expect(manager.themeMode, ThemeMode.light);

    // toggleTheme(true) -> dark
    manager.toggleTheme(true);
    expect(manager.themeMode, ThemeMode.dark);

    // toggleTheme(false) -> light
    manager.toggleTheme(false);
    expect(manager.themeMode, ThemeMode.light);
  });

  test('notifyListeners is called on toggleTheme', () {
    final manager = ThemeManager();
    bool notified = false;

    manager.addListener(() {
      notified = true;
    });

    manager.toggleTheme(true);
    expect(notified, isTrue);
  });
}