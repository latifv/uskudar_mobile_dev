import 'package:flutter/material.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';

final class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.onPressed,
    required this.icon,
    super.key,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.color,
    this.size,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: SizedBox(
          width: width,
          height: height,
          child: _buildIconButton(),
        ),
      ),
    );
  }

  Widget _buildIconButton() {
    return IconButton(
      onPressed: onPressed,
      icon: _buildIcon(),
      iconSize: size ?? IconSizeConstants.m,
    );
  }

  Widget _buildIcon() {
    return Icon(icon, color: color);
  }
}
