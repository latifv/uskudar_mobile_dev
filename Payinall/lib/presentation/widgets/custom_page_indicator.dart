import 'package:flutter/material.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final class CustomPageIndicator extends StatelessWidget {
  const CustomPageIndicator({
    required this.pageController,
    required this.count,
    super.key,
    this.dotHeight = 8,
    this.dotWidth = 8,
  });

  final PageController pageController;
  final int count;
  final double dotHeight;
  final double dotWidth;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: pageController,
      count: count,
      effect: _buildWormEffect(context),
    );
  }

  WormEffect _buildWormEffect(BuildContext context) {
    return WormEffect(
      dotHeight: dotHeight,
      dotWidth: dotWidth,
      activeDotColor: context.colorScheme.primary,
      dotColor: context.colorScheme.primary.withValues(alpha: 0.3),
    );
  }
}
