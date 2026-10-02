import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uskudar_mobile/presentation/shared/constants/validator_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

final class PasswordField extends StatelessWidget {
  const PasswordField({
    required this.onChanged,
    required this.focusNode,
    required this.passwordController,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final TextEditingController passwordController;
  double get fieldHeight => 0.065;
  double get fieldWidth => 0.15;
  int get withAlpha => 25;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: passwordController,
      focusNode: focusNode,
      appContext: context,
      obscureText: true,
      backgroundColor: Colors.transparent,
      length: ValidatorConstants.passwordLength,
      onChanged: onChanged,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: context.borderRadiusNormalAll,
        fieldHeight: context.dynamicHeight(fieldHeight),
        fieldWidth: context.dynamicWidth(fieldWidth),
        activeFillColor: context.colorScheme.surface,
        activeColor: context.colorScheme.primary,
        inactiveColor: context.colorScheme.onSurface.withAlpha(withAlpha),
        selectedColor: context.colorScheme.primary,
        selectedFillColor: context.colorScheme.primary.withAlpha(withAlpha),
        inactiveFillColor: context.colorScheme.surface,
      ),
      cursorColor: context.colorScheme.primary,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      animationDuration: Durations.medium2,
      enableActiveFill: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(ValidatorConstants.passwordLength),
      ],
      autoDisposeControllers: false,
      textStyle: context.textTheme.bodyLarge,
    );
  }
}
