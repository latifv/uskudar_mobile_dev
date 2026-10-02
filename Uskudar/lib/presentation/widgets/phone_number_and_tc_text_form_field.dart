import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/validators/app_validators.dart';

import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';

final class PhoneNumberAndTCTextFormField extends StatelessWidget {
  const PhoneNumberAndTCTextFormField({
    required this.phoneNumberController,
    this.nextFocusNode,
    this.phoneNumberFocusNode,
    this.hintText,
    super.key,
  });

  final TextEditingController phoneNumberController;
  final FocusNode? phoneNumberFocusNode;
  final FocusNode? nextFocusNode;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      suffixIcon: const Icon(Icons.perm_identity),
      controller: phoneNumberController,
      focusNode: phoneNumberFocusNode,
      hintText: hintText ?? LocaleKeys.phone_number_or_tc_number.translate,
      validator: AppValidators.phoneNumberOrTcNumber,
      keyboardType: TextInputType.number,
      onChanged: nextFocusNode != null
          ? onPhoneNumberChanged
          : phoneNumberFocusNode != null
          ? onUnfocusedPhoneNumber
          : null,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: '###########',
          filter: {'#': RegExp('[0-9]')},
        ),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

          const maxLength = 11;
          final limitedText = newText.length > maxLength
              ? newText.substring(0, maxLength)
              : newText;

          return TextEditingValue(
            text: limitedText,
            selection: newValue.selection,
          );
        }),
        TextInputFormatter.withFunction((oldValue, newValue) {
          var text = newValue.text;

          if (text.isEmpty) return newValue;

          final isDeleting = newValue.text.length < oldValue.text.length;

          if (isDeleting) {
            return newValue;
          }

          if (text.startsWith('0')) {
            text = oldValue.text;
          }

          return TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        }),
      ],
    );
  }

  void onPhoneNumberChanged(String? value) {
    if (value == null || value.isEmpty || nextFocusNode == null) return;

    if (value.length == 11) {
      nextFocusNode!.requestFocus();
    }
  }

  void onUnfocusedPhoneNumber(String? value) {
    if (value == null || value.isEmpty || phoneNumberFocusNode == null) return;

    if (value.length == 11) {
      phoneNumberFocusNode!.unfocus();
    }
  }
}
