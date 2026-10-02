import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class PrimaryElevatedButton extends StatefulWidget {
  const PrimaryElevatedButton({
    required this.onPressed,
    required this.text,
    this.textColor,
    this.iconPath,
    super.key,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.padding,
    this.isPng = false,
    this.focusNode,
    this.color,
  });

  final Color? color;
  final VoidCallback onPressed;
  final String text;
  final Color? textColor;
  final String? iconPath;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final bool isPng;
  final FocusNode? focusNode;
  @override
  State<PrimaryElevatedButton> createState() => _PrimaryElevatedButtonState();
}

final class _PrimaryElevatedButtonState extends State<PrimaryElevatedButton> {
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
    return context.theme.elevatedButtonTheme.style?.copyWith(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: context.borderRadiusNormalAll),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(
        widget.color ?? context.colorScheme.primary,
      ),
    );
  }

  Future<void> _handlePress() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future.microtask(widget.onPressed);
    if (mounted) setState(() => _isLoading = false);
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
      textAlign: TextAlign.center,
      style: context.textTheme.displayMedium?.copyWith(
        color: widget.textColor ?? context.colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return SizedBox(
      height: IconSizeConstants.m,
      width: IconSizeConstants.m,
      child: CircularProgressIndicator(
        color: context.theme.colorScheme.surface,
      ),
    );
  }
}
