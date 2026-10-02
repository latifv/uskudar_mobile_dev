import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class SurfaceElevatedButton extends StatefulWidget {
  const SurfaceElevatedButton({
    required this.onPressed,
    required this.text,
    this.iconPath,
    this.color,
    this.textColor,
    super.key,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.padding,
    this.isPng = false,
    this.focusNode,
  });

  final VoidCallback onPressed;
  final String text;
  final String? iconPath;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final bool isPng;
  @override
  State<SurfaceElevatedButton> createState() => _SurfaceElevatedButtonState();
}

final class _SurfaceElevatedButtonState extends State<SurfaceElevatedButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
          focusNode: widget.focusNode,
          style: _buildButtonStyle(context),
          onPressed: _handlePress,
          child: Padding(
            padding: widget.padding ?? context.paddingLowVertical,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildContentWithOpacity(),
                if (_isLoading) _buildLoadingIndicator(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle? _buildButtonStyle(BuildContext context) {
    final borderColor = widget.color ?? context.colorScheme.primary;

    return context.theme.elevatedButtonTheme.style?.copyWith(
      backgroundColor: WidgetStateProperty.all<Color>(
        Colors.transparent,
      ),
      foregroundColor: WidgetStateProperty.all<Color>(
        widget.textColor ?? context.colorScheme.primary,
      ),
      side: WidgetStateProperty.all<BorderSide>(
        BorderSide(
          color: borderColor,
          width: 1.5,
        ),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: context.borderRadiusNormalAll,
        ),
      ),
      elevation: WidgetStateProperty.all<double>(0),
    );
  }

  Future<void> _handlePress() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future.microtask(widget.onPressed);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildContentWithOpacity() {
    return AnimatedOpacity(
      opacity: _isLoading ? 0 : 1,
      duration: Durations.long1,
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    return Row(
      children: [
        _buildIcon(),
        Expanded(child: _buildText(context)),
      ],
    );
  }

  Widget _buildIcon() {
    if (widget.iconPath?.isEmpty ?? true) return const SizedBox.shrink();
    return Expanded(child: widget.isPng ? _buildPngIcon() : _buildSvgIcon());
  }

  Widget _buildPngIcon() {
    return Image.asset(widget.iconPath!, height: IconSizeConstants.m);
  }

  Widget _buildSvgIcon() {
    return SvgPicture.asset(widget.iconPath!, height: IconSizeConstants.m);
  }

  Widget _buildText(BuildContext context) {
    return Text(
      widget.text,
      style: context.textTheme.displayMedium?.copyWith(
        color: widget.textColor ?? context.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return SizedBox(
      height: IconSizeConstants.m,
      width: IconSizeConstants.m,
      child: CircularProgressIndicator(
        color: widget.textColor ?? context.colorScheme.primary,
        strokeWidth: 2,
      ),
    );
  }
}
