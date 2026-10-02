import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/services/permission_service.dart';
import 'package:uskudar_mobile/core/services/qr_code_service/qr_code_service.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';

part 'qr_scan_event.dart';
part 'qr_scan_state.dart';

final class QrScanBloc extends Bloc<QrScanEvent, QrScanState> {
  QrScanBloc({required this.qrCodeService, required this.permissionService})
    : super(const QrScanInitial()) {
    on<QrScanStarted>(_onScanStarted);
    on<QrScanDetected>(_onScanDetected);
    on<QrScanCancelled>(_onScanCancelled);
    on<QrScanPermissionRequested>(_onPermissionRequested);
    on<QrScanSessionStarted>(_onScanSessionStarted);
  }

  final QRCodeService qrCodeService;
  final PermissionService permissionService;
  QrScanSuccess? _lastSuccess;

  Future<void> _onScanStarted(
    QrScanStarted event,
    Emitter<QrScanState> emit,
  ) async {
    LogHelper.log(LogLevel.debug, 'QR tarama başlatılıyor...');
    emit(const QrScanLoading());

    final hasCameraPermission = await permissionService.hasCameraPermission();
    if (!hasCameraPermission) {
      LogHelper.log(LogLevel.debug, 'Kamera izni yok, izin isteniyor');
      emit(const QrScanPermissionRequired());
      return;
    }

    emit(const QrScanReady());
  }

  Future<void> _onScanSessionStarted(
    QrScanSessionStarted event,
    Emitter<QrScanState> emit,
  ) async {
    LogHelper.log(LogLevel.debug, 'QR tarama oturumu aktif');
    emit(const QrScanScanning());
  }

  Future<void> _onPermissionRequested(
    QrScanPermissionRequested event,
    Emitter<QrScanState> emit,
  ) async {
    LogHelper.log(LogLevel.debug, 'Kamera izni isteniyor');
    emit(const QrScanRequestingPermission());

    await permissionService.requestCameraPermission();
    final hasCameraPermission = await permissionService.hasCameraPermission();

    if (hasCameraPermission) {
      LogHelper.log(LogLevel.debug, 'Kamera izni verildi, tarama başlatılıyor');
      add(const QrScanStarted());
    } else {
      LogHelper.log(LogLevel.debug, 'Kamera izni reddedildi');
      emit(const QrScanPermissionDenied());
    }
  }

  void _onScanDetected(QrScanDetected event, Emitter<QrScanState> emit) {
    if (_lastSuccess?.data == event.data) {
      return;
    }
    LogHelper.log(LogLevel.debug, 'QR kod tespit edildi: ${event.data}');
    _lastSuccess = QrScanSuccess(data: event.data);
    emit(_lastSuccess!);
  }

  void _onScanCancelled(QrScanCancelled event, Emitter<QrScanState> emit) {
    LogHelper.log(LogLevel.debug, 'QR tarama iptal edildi');
    emit(const QrScanComplete());
  }
}
