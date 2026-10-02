import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

enum LoginType {
  individual,
  merchant;

  bool get isMerchant => this == merchant;

  String get title {
    switch (this) {
      case LoginType.individual:
        return LocaleKeys.login_type_individual.translate;
      case LoginType.merchant:
        return LocaleKeys.login_type_merchant.translate;
    }
  }

  IconData get icon {
    switch (this) {
      case LoginType.individual:
        return Icons.person_outline;
      case LoginType.merchant:
        return Icons.business_outlined;
    }
  }
}
