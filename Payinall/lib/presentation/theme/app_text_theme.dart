import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payinall/presentation/shared/constants/size_constants.dart';

final class AppTextTheme {
  factory AppTextTheme(Color color) {
    return AppTextTheme._(
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          headlineLarge: TextStyle(
            fontSize: Sizes.k48,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          headlineMedium: TextStyle(
            fontSize: Sizes.k32,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          headlineSmall: TextStyle(
            fontSize: Sizes.k28,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          titleLarge: TextStyle(
            fontSize: Sizes.k28,
            fontWeight: FontWeight.w500,
            color: color,
          ),
          titleMedium: TextStyle(
            fontSize: Sizes.k24,
            fontWeight: FontWeight.w500,
            color: color,
          ),
          titleSmall: TextStyle(
            fontSize: Sizes.k22,
            fontWeight: FontWeight.w500,
            color: color,
          ),
          displayLarge: TextStyle(
            fontSize: Sizes.k20,
            fontWeight: FontWeight.w500,
            color: color,
          ),
          displayMedium: TextStyle(
            fontSize: Sizes.k18,
            fontWeight: FontWeight.w500,
            color: color,
          ),
          displaySmall: TextStyle(
            fontSize: Sizes.k16,
            fontWeight: FontWeight.w500,
            color: color,
          ),
          bodyLarge: TextStyle(
            fontSize: Sizes.k18,
            fontWeight: FontWeight.w400,
            color: color,
          ),
          bodyMedium: TextStyle(
            fontSize: Sizes.k16,
            fontWeight: FontWeight.w400,
            color: color,
          ),
          bodySmall: TextStyle(
            fontSize: Sizes.k14,
            fontWeight: FontWeight.w400,
            color: color,
          ),
          labelLarge: TextStyle(
            fontSize: Sizes.k16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          labelMedium: TextStyle(
            fontSize: Sizes.k14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
          labelSmall: TextStyle(
            fontSize: Sizes.k12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }

  const AppTextTheme._({required this.textTheme});

  final TextTheme textTheme;
}
