import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uskudar_mobile/core/constants/app_constants.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/validators/app_validators.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';

final class PriceTextFormField extends StatelessWidget {
  const PriceTextFormField({
    required this.priceController,
    this.priceFocusNode,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.next,
    this.hideSuffixText = false,
    super.key,
  });

  final TextEditingController priceController;
  final FocusNode? priceFocusNode;
  final FocusNode? nextFocusNode;
  final void Function(String?)? onFieldSubmitted;
  final TextInputAction textInputAction;
  final bool hideSuffixText;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      focusNode: priceFocusNode,
      suffixText: hideSuffixText ? null : AppConstants.currencySymbol,
      controller: priceController,
      hintText: LocaleKeys.amount.translate,
      validator: AppValidators.price,
      suffixIcon: const FaIcon(FontAwesomeIcons.moneyBills),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      inputFormatters: [_PriceFormatter()],
    );
  }
}

final class _PriceFormatter extends TextInputFormatter {
  static const _decimalDigits = 2;
  static const _decimalSeparator = ',';
  static const _thousandsSeparator = '.';
  static final RegExp _onlyDigits = RegExp(r'[^\d]');
  static const _maxAmount = 99999999;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (_isCommaDeleted(oldValue, newValue)) {
      return _handleCommaDeleted(oldValue);
    }

    if (newValue.text.contains(_decimalSeparator)) {
      return _handleTextWithComma(oldValue, newValue);
    }

    return _handleTextWithoutComma(newValue);
  }

  bool _isCommaDeleted(TextEditingValue oldValue, TextEditingValue newValue) {
    final isDeletingText = newValue.text.length < oldValue.text.length;
    final oldHasComma = oldValue.text.contains(_decimalSeparator);
    final newHasComma = newValue.text.contains(_decimalSeparator);

    return oldHasComma && !newHasComma && isDeletingText;
  }

  TextEditingValue _handleCommaDeleted(TextEditingValue oldValue) {
    final commaIndex = oldValue.text.indexOf(_decimalSeparator);
    final leftPart = oldValue.text.substring(0, commaIndex);
    var rightPart = '';

    if (commaIndex < oldValue.text.length - 1) {
      rightPart = oldValue.text.substring(commaIndex + 1);
    }

    return TextEditingValue(
      text: '$leftPart$_decimalSeparator$rightPart',
      selection: TextSelection.collapsed(offset: commaIndex + 1),
    );
  }

  TextEditingValue _handleTextWithComma(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final commaIndex = newValue.text.indexOf(_decimalSeparator);

    var wholePart = _sanitizeWholePart(newValue.text.substring(0, commaIndex));

    wholePart = _applyMaximumValueLimit(wholePart);

    final formattedWhole = _addThousandsSeparator(wholePart);

    final decimalPart = _sanitizeDecimalPart(newValue, commaIndex);

    final formatted = '$formattedWhole$_decimalSeparator$decimalPart';
    final cursorPosition = _calculateCursorPosition(
      newValue,
      commaIndex,
      formattedWhole,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  String _sanitizeWholePart(String wholePart) {
    var sanitized = wholePart.replaceAll(_onlyDigits, '');

    if (sanitized.isEmpty) return '0';

    if (sanitized.startsWith('0') && sanitized.length > 1) {
      sanitized = sanitized.substring(1);
    }

    return sanitized;
  }

  String _applyMaximumValueLimit(String wholePart) {
    if (wholePart.isEmpty) return wholePart;

    try {
      final value = int.parse(wholePart);
      if (value > _maxAmount) {
        return _maxAmount.toString();
      }
    } on Exception catch (_) {}

    return wholePart;
  }

  String _sanitizeDecimalPart(TextEditingValue newValue, int commaIndex) {
    var decimalPart = '';

    if (commaIndex < newValue.text.length - 1) {
      decimalPart = newValue.text
          .substring(commaIndex + 1)
          .replaceAll(_onlyDigits, '');

      if (decimalPart.length > _decimalDigits) {
        decimalPart = decimalPart.substring(0, _decimalDigits);
      }
    }

    return decimalPart.padRight(_decimalDigits, '0');
  }

  int _calculateCursorPosition(
    TextEditingValue newValue,
    int commaIndex,
    String formattedWhole,
  ) {
    if (newValue.selection.baseOffset > commaIndex) {
      final decimalOffset = math.min(
        newValue.selection.baseOffset - commaIndex - 1,
        _decimalDigits,
      );
      return formattedWhole.length + 1 + decimalOffset;
    } else {
      return _calculateWholePartCursorPosition(newValue, formattedWhole);
    }
  }

  int _calculateWholePartCursorPosition(
    TextEditingValue newValue,
    String formattedWhole,
  ) {
    var digitCount = 0;
    for (var i = 0; i < newValue.selection.baseOffset; i++) {
      if (RegExp(r'\d').hasMatch(newValue.text[i])) {
        digitCount++;
      }
    }

    var cursorPos = 0;
    var foundDigits = 0;
    for (var i = 0; i < formattedWhole.length; i++) {
      if (RegExp(r'\d').hasMatch(formattedWhole[i])) {
        foundDigits++;
        if (foundDigits == digitCount) {
          cursorPos = i + 1;
          break;
        }
      }
      cursorPos = i + 1;
    }

    return cursorPos;
  }

  TextEditingValue _handleTextWithoutComma(TextEditingValue newValue) {
    var digitsOnly = newValue.text.replaceAll(_onlyDigits, '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (digitsOnly.startsWith('0') && digitsOnly.length > 1) {
      digitsOnly = digitsOnly.substring(1);
    }

    digitsOnly = _applyMaximumValueLimit(digitsOnly);

    final formattedWhole = _addThousandsSeparator(digitsOnly);
    final cursorPosition = _calculateWholePartCursorPosition(
      newValue,
      formattedWhole,
    );
    final formatted = '$formattedWhole${_decimalSeparator}00';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  String _addThousandsSeparator(String value) {
    if (value.isEmpty) return '0';

    var cleanValue = value;
    while (cleanValue.startsWith('0') && cleanValue.length > 1) {
      cleanValue = cleanValue.substring(1);
    }

    final result = StringBuffer();
    for (var i = 0; i < cleanValue.length; i++) {
      if (i > 0 && (cleanValue.length - i) % 3 == 0) {
        result.write(_thousandsSeparator);
      }
      result.write(cleanValue[i]);
    }
    return result.toString();
  }
}
