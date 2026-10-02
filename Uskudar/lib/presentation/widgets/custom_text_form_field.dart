import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payinall/presentation/shared/components/snackbar_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.controller,
    required this.hintText,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.style,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.obscure = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.unfocusBorderColor,
    this.fillColor,
    this.errorStyle,
    this.contentPadding,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onEditingComplete,
    super.key,
  });

  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String hintText;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final bool obscure;
  final String? prefixText;
  final String? suffixText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction textInputAction;
  final int? maxLines;
  final int? minLines;
  final VoidCallback? onEditingComplete;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final Color? unfocusBorderColor;
  final Color? fillColor;
  final TextStyle? errorStyle;
  final EdgeInsetsGeometry? contentPadding;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final AutovalidateMode autovalidateMode;
  double get _width => 1.5;
  int get _alpha => 128;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) {
        if (validator != null) {
          final error = validator!(value);
          if (error != null) {
            SnackBarComponent.showErrorSnackBar(
              context: context,
              message: error,
            );
          }
          return error;
        }
        return null;
      },
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      textAlign: textAlign,
      onEditingComplete: onEditingComplete,
      textCapitalization: textCapitalization,
      autovalidateMode: autovalidateMode,
      cursorColor: theme.colorScheme.primary,
      style:
          style ??
          context.textTheme.bodyLarge?.copyWith(
            color: enabled
                ? (theme.brightness == Brightness.dark
                      ? context.colorScheme.onSurface
                      : context.colorScheme.primary)
                : (theme.brightness == Brightness.dark
                      ? context.colorScheme.onSurface.withAlpha(_alpha)
                      : context.colorScheme.primary.withAlpha(_alpha)),
          ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            hintStyle ??
            context.textTheme.bodyLarge?.copyWith(
              color: enabled
                  ? theme.colorScheme.onSurface.withAlpha(_alpha)
                  : theme.colorScheme.onSurface.withAlpha(_alpha ~/ 2),
            ),
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: prefixIcon,
        prefixIconColor: theme.colorScheme.onSurface,
        prefixText: prefixText,
        suffixText: suffixText,
        suffixIcon: suffixIcon,
        suffixIconColor: theme.colorScheme.onSurface,
        filled: true,
        fillColor: fillColor ?? theme.colorScheme.surface,
        contentPadding: contentPadding,
        errorStyle: errorStyle ?? const TextStyle(fontSize: 0),
        border: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: unfocusBorderColor != null
              ? BorderSide(
                  color: unfocusBorderColor!,
                  width: _width,
                )
              : BorderSide(
                  color: theme.colorScheme.onSurface.withAlpha(128),
                  width: _width,
                ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: _width,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide(color: theme.colorScheme.error, width: _width),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide(color: theme.colorScheme.error, width: _width),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
