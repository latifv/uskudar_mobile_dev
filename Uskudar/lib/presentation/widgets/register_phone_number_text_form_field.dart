import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/validators/app_validators.dart';
import 'package:uskudar_mobile/presentation/shared/constants/validator_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';

final class RegisterPhoneNumberTextFormField extends StatelessWidget {
  const RegisterPhoneNumberTextFormField({
    required this.phoneNumberController,
    this.nextFocusNode,
    this.phoneNumberFocusNode,
    this.hintText,
    super.key,
  });

  String get phoneNumberPrefix => '0';
  String get phoneNumberStart => '5';

  final TextEditingController phoneNumberController;
  final FocusNode? phoneNumberFocusNode;
  final FocusNode? nextFocusNode;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: phoneNumberController,
      focusNode: phoneNumberFocusNode,
      unfocusBorderColor: Colors.grey.shade300,
      hintText: hintText ?? LocaleKeys.phone_number.translate,
      validator: AppValidators.phoneNumber,
      keyboardType: TextInputType.number,
      prefixIcon: _buildPrefixIcon(context),
      onChanged: nextFocusNode != null
          ? onPhoneNumberChanged
          : phoneNumberFocusNode != null
          ? onUnfocusedPhoneNumber
          : null,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: '##########',
          filter: {'#': RegExp('[0-9]')},
        ),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

          const maxLength =
              ValidatorConstants.phonePrefixLength +
              ValidatorConstants.phoneLength;
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

          final isPasting = text.length > oldValue.text.length + 1;

          if (isPasting) {
            if (text.startsWith('0') && text.length > 1) {
              text = text.substring(1);
            }

            if (!text.startsWith('5') && text.length > 1) {
              final fiveIndex = text.indexOf('5');
              if (fiveIndex != -1) {
                text = text.substring(fiveIndex);
              } else {
                text = '';
              }
            }
          } else {
            if (!text.startsWith('5')) {
              text = oldValue.text;
            }
          }

          return TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        }),
      ],
    );
  }

  Widget _buildPrefixIcon(BuildContext context) {
    return Container(
      padding: context.paddingNormalHorizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 28,
            width: 28,
            child: ClipRRect(
              borderRadius: context.borderRadiusNormalAll,
              child: Flag.fromCode(
                FlagsCode.TR,
                fit: BoxFit.cover,
              ),
            ),
          ),
          context.spacingNormalWidth,
          Text(
            '+90',
            style: context.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          context.spacingNormalWidth,
          Container(
            height: 32,
            width: 2,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  void onPhoneNumberChanged(String? value) {
    if (value == null || value.isEmpty || nextFocusNode == null) return;

    final isValidLength =
        (value[0] == phoneNumberStart &&
            value.length == ValidatorConstants.phoneLength) ||
        (value[0] == phoneNumberPrefix &&
            value.length ==
                ValidatorConstants.phonePrefixLength +
                    ValidatorConstants.phoneLength);

    if (isValidLength) {
      nextFocusNode!.requestFocus();
    }
  }

  void onUnfocusedPhoneNumber(String? value) {
    if (value == null || value.isEmpty || phoneNumberFocusNode == null) return;

    final isValidLength =
        (value[0] == phoneNumberStart &&
            value.length == ValidatorConstants.phoneLength) ||
        (value[0] == phoneNumberPrefix &&
            value.length ==
                ValidatorConstants.phonePrefixLength +
                    ValidatorConstants.phoneLength);

    if (isValidLength) {
      phoneNumberFocusNode!.unfocus();
    }
  }
}
