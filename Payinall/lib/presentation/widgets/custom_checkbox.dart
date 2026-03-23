import 'package:flutter/material.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.size = 21.5,
    this.borderWidth = 1.5,
    this.color,
    this.checkColor,
    this.backgroundColor,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final double size;
  final double borderWidth;
  final Color? color;
  final Color? checkColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: _buildCheckbox(context),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    final primaryColor = color ?? context.colorScheme.primary;
    final tickColor = checkColor ?? primaryColor;
    final bgColor = backgroundColor ?? Colors.transparent;
    final radius = borderRadius ?? context.borderRadiusLowAll;

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!(value ?? false)) : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: primaryColor,
            width: borderWidth,
          ),
          borderRadius: radius,
        ),
        child: _buildCheckIcon(tickColor),
      ),
    );
  }

  Widget _buildCheckIcon(Color tickColor) {
    if (value != true) return const SizedBox.shrink();

    return Center(
      child: Icon(
        Icons.check,
        size: size * 0.75,
        color: tickColor,
      ),
    );
  }
}
