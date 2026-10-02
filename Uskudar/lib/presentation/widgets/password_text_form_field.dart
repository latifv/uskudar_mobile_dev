import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/shared/constants/validator_constants.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';

final class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    required this.passwordController,
    required this.nextFocusNode,
    this.passwordFocusNode,
    this.hintText,
    this.textInputAction = TextInputAction.done,
    this.validator,
    super.key,
  });

  final TextEditingController passwordController;
  final FocusNode? passwordFocusNode;
  final FocusNode nextFocusNode;
  final String? hintText;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

final class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      focusNode: widget.passwordFocusNode,
      suffixIcon: InkWell(
        onTap: _togglePasswordVisibility,
        child: Icon(
          !_isPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
      controller: widget.passwordController,
      hintText: widget.hintText ?? LocaleKeys.password.translate,
      obscure: !_isPasswordVisible,
      validator: widget.validator ?? AppValidators.password,
      keyboardType: TextInputType.number,
      textInputAction: widget.textInputAction,
      onChanged: _onPasswordChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(ValidatorConstants.passwordLength),
      ],
    );
  }

  void _onPasswordChanged(String? value) {
    if (value?.length == ValidatorConstants.passwordLength) {
      widget.nextFocusNode.requestFocus();
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }
}
