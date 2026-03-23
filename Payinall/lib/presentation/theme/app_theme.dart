// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:payinall/presentation/theme/app_colors_dark.dart';
import 'package:payinall/presentation/theme/app_colors_light.dart';
import 'package:payinall/presentation/theme/app_text_theme.dart';

final class AppTheme {
  factory AppTheme.light() {
    final theme = ThemeData.light();
    final textTheme = AppTextTheme(AppColorsLight.onSurface).textTheme;
    return AppTheme._(
      mode: ThemeMode.light,
      data: theme.copyWith(
        primaryColor: AppColorsLight.primary,
        textTheme: textTheme,
        scaffoldBackgroundColor: AppColorsLight.background,
        splashColor: Colors.transparent,
        canvasColor: AppColorsLight.surface,
        highlightColor: Colors.transparent,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColorsLight.primary,
          onPrimary: AppColorsLight.onPrimary,
          secondary: AppColorsLight.secondary,
          onSecondary: AppColorsLight.onSecondary,
          surface: AppColorsLight.surface,
          onSurface: AppColorsLight.onSurface,
          background: AppColorsLight.background,
          onBackground: AppColorsLight.onBackground,
          error: AppColorsLight.error,
          onError: AppColorsLight.onError,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColorsLight.surface,
          selectedItemColor: AppColorsLight.secondary,
          unselectedItemColor: AppColorsLight.onSurface,
          type: BottomNavigationBarType.fixed,
          elevation: _elevation,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColorsLight.background,
          surfaceTintColor: AppColorsLight.background,
          centerTitle: true,
          elevation: _elevation,
          titleTextStyle: textTheme.titleSmall?.copyWith(
            color: AppColorsLight.onBackground,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: AppColorsLight.onBackground),
        ),
        cardTheme: CardThemeData(
          color: AppColorsLight.surface,
          elevation: _elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadiusCircular),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColorsLight.onSurface,
          thickness: _thickness,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColorsLight.primary,
            foregroundColor: AppColorsLight.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadiusCircular),
            ),
            textStyle: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            minimumSize: const Size(double.infinity, _minimumSize),
            elevation: _elevation,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColorsLight.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadiusCircular),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadiusCircular),
            borderSide: const BorderSide(
              color: AppColorsLight.primary,
              width: _inputBorderWidth,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadiusCircular),
            borderSide: const BorderSide(
              color: AppColorsLight.error,
              width: _inputBorderWidth,
            ),
          ),
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: AppColorsLight.onSurface.withAlpha(
              (AppColorsLight.onSurface.a * _opacity).round(),
            ),
          ),
          labelStyle: textTheme.bodyLarge?.copyWith(
            color: AppColorsLight.onSurface,
          ),
          prefixIconColor: AppColorsLight.onSurface,
          suffixIconColor: AppColorsLight.onSurface,
        ),
      ),
    );
  }

  factory AppTheme.dark() {
    final theme = ThemeData.dark();
    final textTheme = AppTextTheme(AppColorsDark.onSurface).textTheme;
    return AppTheme._(
      mode: ThemeMode.dark,
      data: theme.copyWith(
        primaryColor: AppColorsDark.primary,
        textTheme: textTheme,
        scaffoldBackgroundColor: AppColorsDark.background,
        splashColor: Colors.transparent,
        canvasColor: AppColorsDark.surface,
        highlightColor: Colors.transparent,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColorsDark.primary,
          onPrimary: AppColorsDark.onPrimary,
          secondary: AppColorsDark.secondary,
          onSecondary: AppColorsDark.onSecondary,
          surface: AppColorsDark.surface,
          onSurface: AppColorsDark.onSurface,
          background: AppColorsDark.background,
          onBackground: AppColorsDark.onBackground,
          error: AppColorsDark.error,
          onError: AppColorsDark.onError,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColorsDark.surface,
          selectedItemColor: AppColorsDark.secondary,
          unselectedItemColor: AppColorsDark.onSurface,
          type: BottomNavigationBarType.fixed,
          elevation: _elevation,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColorsDark.background,
          surfaceTintColor: AppColorsDark.background,
          centerTitle: true,
          elevation: _elevation,
          titleTextStyle: textTheme.titleMedium?.copyWith(
            color: AppColorsDark.onBackground,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: AppColorsDark.onBackground),
        ),
        cardTheme: CardThemeData(
          color: AppColorsDark.surface,
          elevation: _elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadiusCircular),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColorsDark.onSurface,
          thickness: _thickness,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColorsDark.primary,
            foregroundColor: AppColorsDark.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadiusCircular),
            ),
            textStyle: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            minimumSize: const Size(double.infinity, _minimumSize),
            elevation: _elevation,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColorsDark.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadiusCircular),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadiusCircular),
            borderSide: const BorderSide(
              color: AppColorsDark.primary,
              width: _inputBorderWidth,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadiusCircular),
            borderSide: const BorderSide(
              color: AppColorsDark.error,
              width: _inputBorderWidth,
            ),
          ),
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: AppColorsDark.onSurface.withAlpha(
              (AppColorsDark.onSurface.a * _opacity).round(),
            ),
          ),
          labelStyle: textTheme.bodyLarge?.copyWith(
            color: AppColorsDark.onSurface,
          ),
          prefixIconColor: AppColorsDark.onSurface,
          suffixIconColor: AppColorsDark.onSurface,
        ),
      ),
    );
  }

  const AppTheme._({required this.mode, required this.data});

  static const _opacity = .6;
  static const _minimumSize = 56.0;
  static const _borderRadiusCircular = 12.0;
  static const _elevation = 2.0;
  static const _thickness = 0.5;
  static const _inputBorderWidth = 2.0;

  final ThemeMode mode;
  final ThemeData data;
}
