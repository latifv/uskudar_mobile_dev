import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/services/permission_service.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/enums/transfer_method.dart';
import 'package:uskudar_mobile/presentation/pages/qr_operation/scan/bloc/qr_scan_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

mixin QrScanMixin<T extends StatefulWidget> on State<T> {
  late final QrScanBloc bloc;
  late final MobileScannerController scannerController;
  late final PermissionService _permissionService;

  @override
  void initState() {
    super.initState();
    bloc = getIt<QrScanBloc>();
    _permissionService = getIt<PermissionService>();
    scannerController = MobileScannerController(
      detectionTimeoutMs: 1000,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    unawaited(scannerController.dispose());
    super.dispose();
  }

  void blocListener(_, QrScanState state) {
    if (state is QrScanSuccess) {
      _processQrData(state.data);
    }
  }

  void startScanning() {
    bloc.add(const QrScanStarted());
  }

  void cancelScanning() {
    bloc.add(const QrScanCancelled());
  }

  void requestCameraPermission() {
    bloc.add(const QrScanPermissionRequested());
  }

  void _processQrData(String data) {
    LogHelper.log(LogLevel.debug, 'QR içeriği işleniyor: $data');

    if (data.startsWith('uskudar://')) {
      final uri = Uri.parse(data);
      final pathSegments = uri.pathSegments;

      if (pathSegments.isNotEmpty) {
        final page = uri.host;

        if (page == 'transfer-amount' && pathSegments.length == 3) {
          // final transferMethod = pathSegments[0];
          final walletAddress = pathSegments[1];
          final amount = double.tryParse(pathSegments[2]);

          if (amount != null) {
            LogHelper.log(
              LogLevel.debug,
              'QR Transfer: Adres=$walletAddress, Miktar=$amount',
            );

            unawaited(context.router.replace(
              TransferAmountRoute(
                transferMethod: TransferMethod.wallet.value,
                walletAddress: walletAddress,
                amount: amount,
              ),
            ));
            return;
          }
        }
      }
    }
    ToastComponent.showErrorToast(
      context: context,
      message: LocaleKeys.qr_scan_invalid_url.translate,
    );
    context.router.pop();
  }

  void onBackPressed() {
    context.router.pop();
  }

  void onCancelPressed() {
    cancelScanning();
    context.router.pop();
  }

  void openAppSettings() {
    unawaited(_permissionService.openAppSettings());
  }
}
