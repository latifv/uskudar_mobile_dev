import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

final class AppUtils {
  AppUtils._();

  static Future<void> copyToClipboard(
    String? text, [
    BuildContext? context,
  ]) async {
    if (text == null || text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (context != null && context.mounted) {
      ToastComponent.showSuccessToast(
        context: context,
        message: LocaleKeys.copied_to_clipboard.translate,
      );
    }
  }
}
