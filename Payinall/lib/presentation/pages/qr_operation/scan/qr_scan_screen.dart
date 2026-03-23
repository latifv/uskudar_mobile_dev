import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';
import 'package:payinall/presentation/pages/qr_operation/scan/bloc/qr_scan_bloc.dart';
import 'package:payinall/presentation/pages/qr_operation/scan/mixin/qr_scan_mixin.dart';
import 'package:payinall/presentation/pages/qr_operation/scan/widget/scanner_overlay_painter.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/presentation/widgets/surface_elevated_button.dart';

@RoutePage()
final class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

final class _QrScanScreenState extends State<QrScanScreen> with QrScanMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startScanning();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: BlocConsumer<QrScanBloc, QrScanState>(
            listener: blocListener,
            builder: (context, state) {
              if (state is QrScanLoading ||
                  state is QrScanRequestingPermission) {
                return _buildLoadingView();
              }
              if (state is QrScanPermissionRequired) {
                return _buildPermissionRequiredView();
              }
              if (state is QrScanPermissionDenied) {
                return _buildPermissionDeniedView();
              }
              if (state is QrScanError) {
                return _buildErrorView(state);
              }
              if (state is QrScanComplete) {
                return _buildCompleteView();
              }
              if (state is QrScanReady) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  bloc.add(const QrScanSessionStarted());
                });
              }
              if (state is QrScanScanning || state is QrScanReady) {
                return _buildScannerView();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Column(
      children: [
        _buildHeader(),
        const Expanded(
          child: Center(child: CustomLoading()),
        ),
      ],
    );
  }

  Widget _buildCompleteView() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Center(
            child: Text(
              LocaleKeys.qr_scan_canceled.translate,
              style: context.textTheme.bodyLarge?.copyWith(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: context.paddingNormalAll,
      child: Column(
        children: [
          context.spacingNormalHeight,
          Text(
            LocaleKeys.qr_scan.translate,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          context.spacingLowHeight,
          Text(
            LocaleKeys.qr_operations_description.translate,
            style: context.textTheme.bodyMedium?.copyWith(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRequiredView() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Center(
            child: Padding(
              padding: context.paddingNormalAll,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: IconSizeConstants.xl,
                  ),
                  context.spacingLowHeight,
                  Text(
                    LocaleKeys.qr_scan_permission_required.translate,
                    style: context.textTheme.titleMedium?.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                  context.spacingNormalHeight,
                  PrimaryElevatedButton(
                    onPressed: requestCameraPermission,
                    text: LocaleKeys.continue_text.translate,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDeniedView() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Center(
            child: Padding(
              padding: context.paddingNormalAll,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.no_photography,
                    size: IconSizeConstants.xl,
                    color: Colors.red,
                  ),
                  context.spacingLowHeight,
                  Text(
                    LocaleKeys.qr_scan_permission_denied.translate,
                    style: context.textTheme.titleMedium?.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                  context.spacingNormalHeight,
                  PrimaryElevatedButton(
                    onPressed: openAppSettings,
                    text: LocaleKeys.open_settings.translate,
                    color: context.colorScheme.error,
                  ),
                  context.spacingLowHeight,
                  SurfaceElevatedButton(
                    onPressed: () {
                      context.router.pop();
                    },
                    text: LocaleKeys.close.translate,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScannerView() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Container(
            margin: context.paddingNormalHorizontal,
            decoration: BoxDecoration(
              borderRadius: context.borderRadiusLowAll,
            ),
            child: ClipRRect(
              borderRadius: context.borderRadiusLowAll,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: scannerController,
                    errorBuilder: (context, error) {
                      LogHelper.log(
                        LogLevel.error,
                        'MobileScanner hatası: $error',
                      );
                      return ColoredBox(
                        color: Colors.black54,
                        child: Center(
                          child: Text(
                            '${LocaleKeys.camera_start_error.translate}: ${error.errorCode}',
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    onDetect: (capture) {
                      final barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty &&
                          barcodes.first.rawValue != null) {
                        LogHelper.log(
                          LogLevel.debug,
                          'QR yakalandı: ${barcodes.first.rawValue}',
                        );
                        bloc.add(QrScanDetected(barcodes.first.rawValue!));
                      }
                    },
                  ),
                  Positioned.fill(
                    child: CustomPaint(painter: ScannerOverlayPainter()),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: context.paddingNormalAll,
          child: SizedBox(
            width: context.dynamicWidth(.5),
            child: SurfaceElevatedButton(
              onPressed: onCancelPressed,
              text: LocaleKeys.close.translate,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(QrScanError state) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Center(
            child: Padding(
              padding: context.paddingNormalAll,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: IconSizeConstants.xl,
                    color: Colors.red,
                  ),
                  context.spacingLowHeight,
                  Text(
                    state.message,
                    style: context.textTheme.titleMedium?.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                  context.spacingNormalHeight,
                  PrimaryElevatedButton(
                    onPressed: startScanning,
                    text: LocaleKeys.try_again.translate,
                  ),
                  context.spacingLowHeight,
                  PrimaryElevatedButton(
                    onPressed: onBackPressed,
                    text: LocaleKeys.back.translate,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
