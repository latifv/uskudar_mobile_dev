import 'package:flutter/material.dart';

final class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final center = Offset(width / 2, height / 2);

    final scanAreaSize = width < height ? width * 0.7 : height * 0.7;
    final scanRect = Rect.fromCenter(
      center: center,
      width: scanAreaSize,
      height: scanAreaSize,
    );

    final topRect = Rect.fromLTRB(0, 0, width, scanRect.top);
    final bottomRect = Rect.fromLTRB(0, scanRect.bottom, width, height);
    final leftRect = Rect.fromLTRB(
      0,
      scanRect.top,
      scanRect.left,
      scanRect.bottom,
    );
    final rightRect = Rect.fromLTRB(
      scanRect.right,
      scanRect.top,
      width,
      scanRect.bottom,
    );

    final background = Paint()
      ..color = Colors.black.withAlpha(128)
      ..style = PaintingStyle.fill;

    canvas
      ..drawRect(topRect, background)
      ..drawRect(bottomRect, background)
      ..drawRect(leftRect, background)
      ..drawRect(rightRect, background);

    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final cornerLength = scanAreaSize * 0.1;

    canvas
      ..drawLine(
        scanRect.topLeft,
        scanRect.topLeft.translate(cornerLength, 0),
        cornerPaint,
      )
      ..drawLine(
        scanRect.topLeft,
        scanRect.topLeft.translate(0, cornerLength),
        cornerPaint,
      )
      ..drawLine(
        scanRect.topRight,
        scanRect.topRight.translate(-cornerLength, 0),
        cornerPaint,
      )
      ..drawLine(
        scanRect.topRight,
        scanRect.topRight.translate(0, cornerLength),
        cornerPaint,
      )
      ..drawLine(
        scanRect.bottomLeft,
        scanRect.bottomLeft.translate(cornerLength, 0),
        cornerPaint,
      )
      ..drawLine(
        scanRect.bottomLeft,
        scanRect.bottomLeft.translate(0, -cornerLength),
        cornerPaint,
      )
      ..drawLine(
        scanRect.bottomRight,
        scanRect.bottomRight.translate(-cornerLength, 0),
        cornerPaint,
      )
      ..drawLine(
        scanRect.bottomRight,
        scanRect.bottomRight.translate(0, -cornerLength),
        cornerPaint,
      );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
