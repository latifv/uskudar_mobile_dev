import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class CustomLoading extends StatelessWidget {
  const CustomLoading({
    super.key,
    this.color,
    this.strokeWidth,
    this.dynamicSize = 0.14,
  });

  final Color? color;
  final double? strokeWidth;
  final double dynamicSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.dynamicWidth(dynamicSize),
      height: context.dynamicHeight(dynamicSize),
      child: LoadingIndicator(
        indicatorType: Indicator.ballSpinFadeLoader,
        colors: [color ?? context.colorScheme.primary],
        strokeWidth: strokeWidth,
      ),
    );
  }
}
