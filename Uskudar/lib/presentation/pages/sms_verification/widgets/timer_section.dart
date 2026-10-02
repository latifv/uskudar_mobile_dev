import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class TimerSection extends StatelessWidget {
  const TimerSection({
    required this.remainingTime,
    required this.timerDuration,
    super.key,
  });
  double get _size => 0.45;
  final int remainingTime;
  final int timerDuration;

  @override
  Widget build(BuildContext context) {
    final size = context.dynamicWidth(_size);
    final progress = remainingTime / timerDuration;

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: CircularTimerPainter(
              progress: progress,
              backgroundColor: context.colorScheme.surface,
              progressColor: context.colorScheme.primary,
            ),
          ),
        ),
        context.spacingMediumHeight,
        Text(
          _formatTime(remainingTime),
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

final class CircularTimerPainter extends CustomPainter {
  const CircularTimerPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.fill;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CircularTimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor;
  }
}
