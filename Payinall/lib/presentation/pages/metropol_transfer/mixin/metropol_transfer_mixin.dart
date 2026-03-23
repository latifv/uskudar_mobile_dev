import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:payinall/core/services/permission_service.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/metropol_transfer/bloc/metropol_transfer_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

mixin MetropolTransferMixin<T extends StatefulWidget> on State<T> {
  late final MetropolTransferBloc bloc;
  late final TextEditingController codeController;
  late final GlobalKey<FormState> formKey;
  late final PermissionService _permissionService;

  int selectedCodeType = 0;

  @override
  void initState() {
    super.initState();
    bloc = getIt<MetropolTransferBloc>();
    codeController = TextEditingController();
    formKey = GlobalKey<FormState>();
    _permissionService = getIt<PermissionService>();
  }

  @override
  void dispose() {
    codeController.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void onCodeTypeChanged(int type) {
    if (!mounted) return;
    setState(() {
      selectedCodeType = type;
      codeController.clear();
    });
  }

  void onSubmitTransfer() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) return;
    bloc.add(
      MetropolTransferSubmit(
        codeTypes: selectedCodeType,
        code: codeController.text,
      ),
    );
  }

  void onConfirmTransfer(String transactionId) {
    bloc.add(MetropolTransferConfirm(transactionId: transactionId));
  }

  void onDrawBack() {
    bloc.add(const MetropolTransferDrawBack());
  }

  Future<void> onQrScanPressed() async {
    final hasCameraPermission = await _permissionService.hasCameraPermission();

    if (hasCameraPermission && mounted) {
      _showQrScanModal();
    } else {
      await _permissionService.requestCameraPermission();
      final hasPermissionAfterRequest =
          await _permissionService.hasCameraPermission();

      if (hasPermissionAfterRequest && mounted) {
        _showQrScanModal();
      } else if (mounted) {
        ToastComponent.showErrorToast(
          context: context,
          message: 'Kamera izni gereklidir.',
        );
      }
    }
  }

  void _showQrScanModal() {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _MetropolQrScanModal(
          onQrScanned: _processQrData,
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _processQrData(String data) {
    LogHelper.log(LogLevel.debug, 'Metropol QR içeriği: $data');

    if (data.isNotEmpty) {
      codeController.text = data;
      if (mounted) {
        Navigator.of(context).pop();
        ToastComponent.showSuccessToast(
          context: context,
          message: 'QR kod başarıyla okundu.',
        );
      }
    } else {
      ToastComponent.showErrorToast(
        context: context,
        message: 'Geçersiz QR kod.',
      );
    }
  }

  void blocListener(BuildContext context, MetropolTransferState state) {
    if (state.status == MetropolTransferStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message ?? '',
      );
    }
    if (state.status == MetropolTransferStatus.completed) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message ?? 'İşlem başarılı!',
      );
      context.router.maybePop();
    }
    if (state.status == MetropolTransferStatus.drawBackCompleted) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message ?? 'Geri yükleme başarılı!',
      );
    }
  }
}

final class _MetropolQrScanModal extends StatefulWidget {
  const _MetropolQrScanModal({
    required this.onQrScanned,
    required this.onClose,
  });

  final void Function(String) onQrScanned;
  final VoidCallback onClose;

  @override
  State<_MetropolQrScanModal> createState() => _MetropolQrScanModalState();
}

final class _MetropolQrScanModalState extends State<_MetropolQrScanModal> {
  late final MobileScannerController scannerController;
  bool hasScanned = false;

  @override
  void initState() {
    super.initState();
    scannerController = MobileScannerController(
      detectionTimeoutMs: 1000,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    unawaited(scannerController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dynamicHeight(.75),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: context.borderRadiusNormalTop,
      ),
      child: Column(
        children: [
          Container(
            padding: context.paddingNormalAll,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'QR Kod Okut',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.surface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: context.borderRadiusLowAll,
              child: MobileScanner(
                controller: scannerController,
                onDetect: (capture) {
                  if (!hasScanned && capture.barcodes.isNotEmpty) {
                    final barcode = capture.barcodes.first;
                    if (barcode.rawValue != null) {
                      hasScanned = true;
                      LogHelper.log(
                        LogLevel.debug,
                        'QR yakalandı: ${barcode.rawValue}',
                      );
                      widget.onQrScanned(barcode.rawValue!);
                    }
                  }
                },
              ),
            ),
          ),
          Container(
            padding: context.paddingNormalVertical,
            child: Text(
              'QR kodu kameranın önüne tutunuz.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.surface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
