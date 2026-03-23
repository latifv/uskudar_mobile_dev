import 'package:easy_localization/easy_localization.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/constants/validator_constants.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

final class AppValidators {
  const AppValidators._();

  static String? email(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_email.translate;
    }
    return null;
  }

  static String? firstName(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_first_name.translate;
    }

    if (value!.length < ValidatorConstants.firstNameMinLength) {
      return LocaleKeys.first_name_length.translate;
    }

    return null;
  }

  static String? customerNumber(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_customer_number.translate;
    }
    if (value!.length != ValidatorConstants.customerNumberLength) {
      return LocaleKeys.customer_number_length.translate;
    }

    return null;
  }

  static String? lastName(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_last_name.translate;
    }

    if (value!.length < ValidatorConstants.lastNameMinLength) {
      return LocaleKeys.last_name_length.translate;
    }

    return null;
  }

  static String? password(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_password.translate;
    }

    if (value!.length != ValidatorConstants.passwordLength) {
      return LocaleKeys.password_length.translate;
    }

    return null;
  }

  static String? confirmPassword(String? value, String otherPassword) {
    final passwordError = password(otherPassword);
    if (passwordError != null) {
      return passwordError;
    }

    if (value != otherPassword) {
      return LocaleKeys.passwords_not_match.translate;
    }

    return null;
  }

  static String? phoneNumber(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_phone_number.translate;
    }

    final phoneRegex = RegExp(r'^(\+90|90|0)?5[0-9]{9}$');

    if (!phoneRegex.hasMatch(value!)) {
      return LocaleKeys.invalid_phone_number.translate;
    }

    return null;
  }

  static String? phoneNumberOrTcNumber(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_phone_number.translate;
    }

    return null;
  }

  static String? tcNumber(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_tc_number.translate;
    }

    if (value!.length != ValidatorConstants.tcLength) {
      return LocaleKeys.invalid_tc_number.translate;
    }

    return null;
  }

  static String? pin(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_pin.translate;
    }

    if (value!.length != ValidatorConstants.pinLength) {
      return LocaleKeys.invalid_pin.translate;
    }

    return null;
  }

  static String? pinWith6(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_pin.translate;
    }

    if (value!.length != ValidatorConstants.pinLength + 1) {
      return LocaleKeys.invalid_pin.translate;
    }

    return null;
  }

  static String? required(String? value, [String? errorMessage]) {
    if (value?.isEmpty ?? true) {
      return errorMessage ?? LocaleKeys.required_field.translate;
    }
    return null;
  }

  static String? seriNo(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.required_field.translate;
    }

    if (value!.length != ValidatorConstants.seriNoLength) {
      return LocaleKeys.seri_no_length.translate;
    }

    return null;
  }

  static String? requiredDate(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.required_field.translate;
    }

    final dateRegex = RegExp(r'^\d{2}\.\d{2}\.\d{4}$');
    if (!dateRegex.hasMatch(value!)) {
      return LocaleKeys.invalid_date.translate;
    }

    final date = DateFormat('dd.MM.yyyy').tryParse(value);
    if (date == null) {
      return LocaleKeys.invalid_date.translate;
    }

    final now = DateTime.now();
    final eighteenYearsAgo = now.subtract(const Duration(days: 18 * 365));
    if (date.isAfter(eighteenYearsAgo)) {
      return LocaleKeys.under_18.translate;
    }

    return null;
  }

  static String? validateIban(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.enter_iban.translate;
    }

    final cleanIban = value.replaceAll(' ', '');
    if (cleanIban.length < 20 || !cleanIban.startsWith('TR')) {
      return LocaleKeys.invalid_iban.translate;
    }

    return null;
  }

  static String? price(String? value) {
    if (value?.isEmpty ?? true) {
      return LocaleKeys.enter_amount.translate;
    }

    final engPriceRegex = RegExp(r'^\d{1,3}(,\d{3})*(\.\d{1,2})?$');
    final turPriceRegex = RegExp(r'^\d{1,3}(\.\d{3})*(,\d{1,2})?$');

    if (engPriceRegex.hasMatch(value!)) {
      final cleanValue = value.replaceAll(',', '');
      final price = double.tryParse(cleanValue);
      if (price == null || price <= 0) {
        return LocaleKeys.invalid_amount.translate;
      }
    } else if (turPriceRegex.hasMatch(value)) {
      final cleanValue = value.replaceAll('.', '').replaceAll(',', '.');
      final price = double.tryParse(cleanValue);
      if (price == null || price <= 0) {
        return LocaleKeys.invalid_amount.translate;
      }
    } else {
      return LocaleKeys.invalid_amount.translate;
    }

    return null;
  }
}
