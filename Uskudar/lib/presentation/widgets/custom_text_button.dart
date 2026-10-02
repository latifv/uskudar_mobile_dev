import 'package:flutter/material.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.color,
    this.textStyle,
  });

  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: SizedBox(
          width: width,
          height: height,
          child: _buildTextButton(context),
        ),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(onPressed: onPressed, child: _buildText(context));
  }

  Widget _buildText(BuildContext context) {
    return Text(
      text,
      style:
          textStyle ??
          context.textTheme.bodyLarge?.copyWith(
            color: color ?? context.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }
}
