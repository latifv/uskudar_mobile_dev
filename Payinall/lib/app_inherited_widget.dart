import 'package:flutter/material.dart';

final class AppInheritedWidget extends InheritedWidget {
  const AppInheritedWidget({
    required this.updateThemeMode,
    required this.updateLocale,
    required super.child,
    super.key,
  });

  final void Function(bool isDarkMode) updateThemeMode;
  final Future<void> Function(Locale locale) updateLocale;

  static AppInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppInheritedWidget>();
  }

  @override
  bool updateShouldNotify(AppInheritedWidget oldWidget) {
    return updateThemeMode != oldWidget.updateThemeMode ||
        updateLocale != oldWidget.updateLocale;
  }
}
