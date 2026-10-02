import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/services/permission_service.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/add_bank_account/bloc/add_bank_account_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_dialog.dart';

mixin AddBankAccountMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController accountNameController;
  late final TextEditingController ibanController;

  late final FocusNode ibanFocusNode;
  late final FocusNode submitFocusNode;

  late final GlobalKey<FormState> formKey;

  late final AddBankAccountBloc bloc;
  late final PermissionService _permissionService;

  @override
  void initState() {
    accountNameController = TextEditingController();
    ibanController = TextEditingController();

    ibanFocusNode = FocusNode();
    submitFocusNode = FocusNode();

    formKey = GlobalKey<FormState>();

    bloc = getIt<AddBankAccountBloc>();
    _permissionService = getIt<PermissionService>();
    super.initState();
  }

  @override
  void dispose() {
    accountNameController.dispose();
    ibanController.dispose();

    submitFocusNode.dispose();
    ibanFocusNode.dispose();

    formKey.currentState?.dispose();

    unawaited(bloc.close());

    super.dispose();
  }

  void blocListener(_, AddBankAccountState state) {
    if (state.state == AddBankAccountBlocState.success) {
      ToastComponent.showSuccessToast(
        context: context,
        message: LocaleKeys.bank_account_saved.translate,
      );
      context.router.pop();
    } else if (state.state == AddBankAccountBlocState.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  Future<void> onSubmitPressed() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final title = accountNameController.text;
    final iban = ibanController.text.trim();

    bloc.add(AddBankAccountSave(title: title, iban: iban));
  }

  Future<void> onQrScanPressed() async {
    final hasCameraPermission = await _permissionService.hasCameraPermission();

    if (hasCameraPermission && mounted) {
      _showQrScanModal();
    } else {
      final result = await _showCameraPermissionDialog();
      if (result != null && result) {
        await _permissionService.requestCameraPermission();
        final hasPermissionAfterRequest = await _permissionService
            .hasCameraPermission();

        if (hasPermissionAfterRequest && mounted) {
          _showQrScanModal();
        } else {
          _showPermissionDeniedDialog();
        }
      }
    }
  }

  void _showQrScanModal() {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _QrScanModal(
          onQrScanned: _processQrData,
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _processQrData(String data) {
    LogHelper.log(LogLevel.debug, 'QR içeriği işleniyor: $data');

    final iban = _extractIbanFromQr(data);
    if (iban != null) {
      ibanController.text = iban;
      context.router.pop();
      ToastComponent.showSuccessToast(
        context: context,
        message: LocaleKeys.iban_scanned.translate,
      );
    } else {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.invalid_iban_qr.translate,
      );
    }
  }

  String? _extractIbanFromQr(String qrData) {
    final cleanData = qrData.replaceAll(RegExp(r'\s+'), '').toUpperCase();

    if (_isValidIbanFormat(cleanData)) {
      return _formatIban(cleanData);
    }

    final fastQrPattern = RegExp(r'(TR\d{2}[A-Z0-9]{22})');
    final fastMatch = fastQrPattern.firstMatch(cleanData);
    if (fastMatch != null) {
      final rawIban = fastMatch.group(1);
      if (rawIban != null && _isValidIbanFormat(rawIban)) {
        LogHelper.log(LogLevel.debug, 'FAST QRdan IBAN çıkarıldı: $rawIban');
        return _formatIban(rawIban);
      }
    }

    final patterns = [
      RegExp(r'IBAN[:=]\s*([A-Z]{2}\d{2}[\s\d]{20,})', caseSensitive: false),
      RegExp(r'(TR\d{2}[\s\d]{20,})', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(qrData);
      if (match != null) {
        final rawIban = match
            .group(1)
            ?.replaceAll(RegExp(r'\s+'), '')
            .toUpperCase();
        if (rawIban != null && _isValidIbanFormat(rawIban)) {
          return _formatIban(rawIban);
        }
      }
    }

    return null;
  }

  bool _isValidIbanFormat(String iban) {
    final regex = RegExp(r'^TR\d{2}[A-Z0-9]{22}$');
    return regex.hasMatch(iban);
  }

  String _formatIban(String iban) {
    if (iban.length != 26 || !iban.startsWith('TR')) {
      return iban;
    }

    final formatted = StringBuffer()..write(iban.substring(0, 4));

    for (var i = 4; i < iban.length; i += 4) {
      formatted.write(' ');
      final endIndex = (i + 4 < iban.length) ? i + 4 : iban.length;
      formatted.write(iban.substring(i, endIndex));
    }

    return formatted.toString();
  }

  Future<bool?> _showCameraPermissionDialog() async {
    return CustomDialog.show(
      context: context,
      title: LocaleKeys.camera_permission_required.translate,
      description: LocaleKeys.qr_scan_permission_required.translate,
      icon: Icons.camera_alt,
      primaryButtonText: LocaleKeys.continue_text.translate,
      onPrimaryButtonPressed: () {},
      surfaceButtonActive: false,
      barrierDismissible: false,
    );
  }

  void _showPermissionDeniedDialog() {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.failed.translate,
        description: LocaleKeys.qr_scan_permission_denied.translate,
        icon: Icons.error_outline,
        color: context.colorScheme.error,
        primaryButtonText: LocaleKeys.open_settings.translate,
        onPrimaryButtonPressed: () {
          unawaited(_permissionService.openAppSettings());
        },
      ),
    );
  }
}

final class _QrScanModal extends StatefulWidget {
  const _QrScanModal({required this.onQrScanned, required this.onClose});

  final ValueChanged<String> onQrScanned;
  final VoidCallback onClose;

  @override
  State<_QrScanModal> createState() => _QrScanModalState();
}

final class _QrScanModalState extends State<_QrScanModal> {
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
                    LocaleKeys.scan_iban_qr.translate,
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
              LocaleKeys.scan_iban_qr_instruction.translate,
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
