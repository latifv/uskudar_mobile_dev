import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/models/paycore_mobile_models.dart';
import 'package:uskudar_mobile/presentation/shared/constants/paycore_card_asset_constants.dart';

final class PaycoreCardVisual extends StatefulWidget {
  const PaycoreCardVisual({
    required this.card,
    required this.frontChild,
    this.backChild,
    this.onTap,
    this.shouldIgnoreFlipTap,
    this.enableFlip = false,
    this.margin,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.boxShadow,
    this.aspectRatio,
    super.key,
  });

  final PaycoreCardSummary card;
  final Widget frontChild;
  final Widget? backChild;
  final VoidCallback? onTap;
  final bool Function(
    Offset localPosition,
    Size size, {
    required bool isBackVisible,
  })?
  shouldIgnoreFlipTap;
  final bool enableFlip;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? aspectRatio;

  @override
  State<PaycoreCardVisual> createState() => _PaycoreCardVisualState();
}

final class _PaycoreCardVisualState extends State<PaycoreCardVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _ignoreNextFlipTap = false;

  bool get _isFlippable => widget.enableFlip && widget.backChild != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void didUpdateWidget(covariant PaycoreCardVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isFlippable && _controller.value != 0) {
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isFlippable) {
      if (_controller.value >= 0.5) {
        unawaited(_controller.reverse());
      } else {
        unawaited(_controller.forward());
      }
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              _ignoreNextFlipTap =
                  widget.shouldIgnoreFlipTap?.call(
                    details.localPosition,
                    size,
                    isBackVisible: _controller.value >= 0.5,
                  ) ??
                  false;
            },
            onTap: () {
              if (_ignoreNextFlipTap) {
                _ignoreNextFlipTap = false;
                return;
              }
              _handleTap();
            },
            child: AnimatedBuilder(
              animation: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOutCubic,
              ),
              builder: (context, _) {
                final angle = _controller.value * math.pi;
                final showBack = angle > math.pi / 2;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0012)
                    ..rotateY(angle),
                  child: showBack
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(math.pi),
                          child: _buildFace(
                            isBack: true,
                            child: widget.backChild ?? widget.frontChild,
                          ),
                        )
                      : _buildFace(
                          isBack: false,
                          child: widget.frontChild,
                        ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFace({
    required bool isBack,
    required Widget child,
  }) {
    final backgroundAsset = isBack
        ? PaycoreCardAssetConstants.backForSummary(widget.card)
        : PaycoreCardAssetConstants.frontForSummary(widget.card);

    final content = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        image: DecorationImage(
          image: AssetImage(backgroundAsset),
          fit: BoxFit.cover,
        ),
        boxShadow:
            widget.boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          gradient: LinearGradient(
            colors: isBack
                ? [
                    Colors.black.withValues(alpha: 0.04),
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.18),
                  ]
                : [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.16),
                    Colors.black.withValues(alpha: 0.3),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: widget.padding,
        child: child,
      ),
    );

    final aspectRatio = widget.aspectRatio;
    if (aspectRatio == null) {
      return content;
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: content,
    );
  }
}
