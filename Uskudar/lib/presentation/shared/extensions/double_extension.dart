import 'package:uskudar_mobile/core/constants/app_constants.dart';

extension DoubleExtension on double? {
  String toFormattedCurrency() {
    if (this == null) return '0,00 ${AppConstants.currencySymbol}';
    final price = this!.toStringAsFixed(2);
    final priceWithoutDot = price.replaceAll('.', ',');
    final parts = priceWithoutDot.split(',');
    final integerPart = parts[0];
    final decimalPart = parts[1];
    final chunks = <String>[];
    var startIndex = integerPart.length;
    while (startIndex > 0) {
      final endIndex = startIndex;
      startIndex = startIndex - 3 >= 0 ? startIndex - 3 : 0;
      chunks.add(integerPart.substring(startIndex, endIndex));
    }
    final formattedInteger = chunks.reversed.join('.');
    return '$formattedInteger,$decimalPart${AppConstants.currencySymbol}';
  }

  String toFormattedCurrencyWithOutSymbol() {
    if (this == null) return '0,00';
    final price = this!.toStringAsFixed(2);
    final priceWithoutDot = price.replaceAll('.', ',');
    final parts = priceWithoutDot.split(',');
    final integerPart = parts[0];
    final decimalPart = parts[1];
    final chunks = <String>[];
    var startIndex = integerPart.length;
    while (startIndex > 0) {
      final endIndex = startIndex;
      startIndex = startIndex - 3 >= 0 ? startIndex - 3 : 0;
      chunks.add(integerPart.substring(startIndex, endIndex));
    }
    final formattedInteger = chunks.reversed.join('.');
    return '$formattedInteger,$decimalPart';
  }
}
