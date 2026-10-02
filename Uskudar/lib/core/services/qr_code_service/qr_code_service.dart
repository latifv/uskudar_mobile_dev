import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uskudar_mobile/core/services/qr_code_service/completer.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:qr_flutter/qr_flutter.dart';

abstract interface class QRCodeService {
  Future<Uint8List?> generateQRCode({
    required String data,
    int size = 300,
    ui.Image? embeddedImage,
    Color? color,
  });
  Future<String?> scanQRCode();
  Future<String?> scanQRCodeFromImage(Uint8List imageBytes);
  Future<void> startQRScanSession({
    required void Function(String) onDetect,
    void Function()? onSessionClosed,
  });
  Future<void> stopQRScanSession();
}

final class QRCodeServiceImpl implements QRCodeService {
  QRCodeServiceImpl();

  MobileScannerController? _scannerController;
  StreamSubscription<BarcodeCapture>? _barcodeSubscription;

  @override
  Future<Uint8List?> generateQRCode({
    required String data,
    int size = 300,
    ui.Image? embeddedImage,
    Color? color,
  }) async {
    try {
      final qrValidationResult = QrValidator.validate(
        data: data,
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      );

      if (!qrValidationResult.isValid) {
        return null;
      }

      final qrCode = qrValidationResult.qrCode!;

      final painter = QrPainter.withQr(
        qr: qrCode,
        gapless: true,
        embeddedImage: embeddedImage,
        color: color ?? Colors.black,
      );

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      painter.paint(canvas, Size(size.toDouble(), size.toDouble()));
      final picture = recorder.endRecording();
      final img = await picture.toImage(size, size);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  Future<String?> scanQRCode() async {
    final completer = Completer<String?>();

    try {
      await startQRScanSession(
        onDetect: (data) {
          if (!completer.isCompleted) {
            completer.complete(data);
          }
          unawaited(stopQRScanSession());
        },
        onSessionClosed: () {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        },
      );

      return completer.future;
    } on Exception catch (_) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
      return null;
    }
  }

  @override
  Future<String?> scanQRCodeFromImage(Uint8List imageBytes) async {
    try {
      final completer = Completer<String?>();
      final controller = MobileScannerController(
        formats: const [BarcodeFormat.qrCode],
      );

      final subscription = controller.barcodes.listen(
        (capture) {
          if (capture.barcodes.isNotEmpty) {
            for (final barcode in capture.barcodes) {
              if (barcode.rawValue != null) {
                if (!completer.isCompleted) {
                  completer.complete(barcode.rawValue);
                }
                break;
              }
            }
          }
        },
        onError: (_) {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        },
      );

      try {
        final result = await completer.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () => null,
        );
        return result;
      } finally {
        await subscription.cancel();
        await controller.dispose();
      }
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  Future<void> startQRScanSession({
    required void Function(String) onDetect,
    void Function()? onSessionClosed,
  }) async {
    _scannerController = MobileScannerController(
      detectionTimeoutMs: 1000,
      formats: const [BarcodeFormat.qrCode],
    );

    _barcodeSubscription = _scannerController!.barcodes.listen(
      (capture) {
        if (capture.barcodes.isNotEmpty) {
          for (final barcode in capture.barcodes) {
            if (barcode.rawValue != null) {
              onDetect(barcode.rawValue!);
              break;
            }
          }
        }
      },
      onError: (_) {
        if (onSessionClosed != null) {
          onSessionClosed();
        }
      },
      onDone: () {
        if (onSessionClosed != null) {
          onSessionClosed();
        }
      },
    );

    try {
      await _scannerController!.start();
    } on Exception catch (e) {
      LogHelper.log(LogLevel.error, 'QR tarama başlatılırken hata: $e');
      if (onSessionClosed != null) {
        onSessionClosed();
      }
    }
  }

  @override
  Future<void> stopQRScanSession() async {
    await _barcodeSubscription?.cancel();
    _barcodeSubscription = null;

    if (_scannerController != null) {
      try {
        await _scannerController!.stop();
      } on Exception catch (_) {}

      await _scannerController!.dispose();
      _scannerController = null;
    }
  }

  // Future<ui.Image> _loadImageFromAsset(String assetPath) async {
  //   final data = await rootBundle.load(assetPath);
  //   final bytes = data.buffer.asUint8List();
  //   final codec = await ui.instantiateImageCodec(bytes);
  //   final frameInfo = await codec.getNextFrame();
  //   return frameInfo.image;
  // }
}
