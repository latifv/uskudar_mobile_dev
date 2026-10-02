import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/shared/constants/validator_constants.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';

final class TcNumberTextFormField extends StatelessWidget {
  const TcNumberTextFormField({
    required this.tcNumberController,
    this.tcNumberFocusNode,
    this.nextFocusNode,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController tcNumberController;
  final FocusNode? tcNumberFocusNode;
  final FocusNode? nextFocusNode;
  final void Function(String?)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      focusNode: tcNumberFocusNode,
      suffixIcon: const Icon(Icons.perm_identity_outlined),
      controller: tcNumberController,
      hintText: LocaleKeys.tc_number.translate,
      validator: AppValidators.tcNumber,
      keyboardType: TextInputType.number,
      onChanged: onTcNumberChanged,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(ValidatorConstants.tcLength),
      ],
    );
  }

  void onTcNumberChanged(String? value) {
    if (value?.isEmpty ?? true) return;
    if (nextFocusNode == null) return;
    if (value!.length == ValidatorConstants.tcLength) {
      nextFocusNode!.requestFocus();
    }
  }
}
