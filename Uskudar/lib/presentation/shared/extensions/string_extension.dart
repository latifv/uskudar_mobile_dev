import 'package:easy_localization/easy_localization.dart';
import 'package:uskudar_mobile/core/constants/app_constants.dart';

extension StringExtension on String? {
  String get translate => this?.tr() ?? '404';

  String translateWithNamedArgs(Map<String, String> namedArgs) =>
      this?.tr(namedArgs: namedArgs) ?? '404';

  String? capitalizeFirstLetter() {
    if (this == null) return null;
    if (this!.isEmpty) return this;
    return this![0].toUpperCase() + this!.substring(1);
  }

  String? capitalizeFirstLetterOfEachWord() {
    if (this == null) return null;
    if (this!.isEmpty) return this;
    return this!
        .split(' ')
        .map((word) => word.capitalizeFirstLetter())
        .join(' ');
  }

  double toDoubleFromCurrency() {
    if (this == null || this!.isEmpty) return 0;
    final price = this!.replaceAll(AppConstants.currencySymbol, '').trim();
    final priceWithoutThousandSeparator = price.replaceAll('.', '');
    final priceWithDecimalPoint = priceWithoutThousandSeparator.replaceAll(
      ',',
      '.',
    );
    return double.tryParse(priceWithDecimalPoint) ?? 0;
  }

  DateTime? toDateFromTurkishFormat() {
    if (this == null || this!.isEmpty) return null;
    try {
      final parts = this!.split('.');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } on Exception catch (_) {
      return null;
    }
  }
}
