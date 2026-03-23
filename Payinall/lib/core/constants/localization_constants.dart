import 'package:flutter/material.dart';

final class LocalizationConstants {
  LocalizationConstants._();
  static const Locale tr = Locale('tr');
  static const Locale en = Locale('en');
  static const Locale de = Locale('de');
  static const Locale fr = Locale('fr');

  static const List<Locale> supportedLocales = [tr, en, de, fr];

  static const Locale fallbackLocale = tr;

  static const String path = 'assets/translations';
}
