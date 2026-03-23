import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payinall/presentation/shared/constants/validator_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

final class PinCodeField extends StatelessWidget {
  const PinCodeField({
    required this.onChanged,
    required this.pinController,
    required this.focusNode,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final TextEditingController pinController;
  double get fieldHeight => 0.065;
  double get fieldWidth => 0.15;
  int get withAlpha => 25;
  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      focusNode: focusNode,
      controller: pinController,
      appContext: context,
      backgroundColor: Colors.transparent,
      length: ValidatorConstants.pinLength,
      obscureText: true,
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
        LengthLimitingTextInputFormatter(ValidatorConstants.pinLength),
      ],
      textStyle: context.textTheme.bodyLarge,
      autoDisposeControllers: false,
    );
  }
}
