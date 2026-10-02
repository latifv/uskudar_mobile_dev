import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/back_id_scan/bloc/back_id_scan_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/back_id_scan/mixin/back_id_scan_mixin.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';
import 'package:uskudar_mobile/presentation/widgets/surface_elevated_button.dart';

@RoutePage()
final class BackIdScanScreen extends StatefulWidget {
  const BackIdScanScreen({required this.processId, super.key});

  final String processId;
  @override
  State<BackIdScanScreen> createState() => _BackIdScanScreenState();
}

final class _BackIdScanScreenState extends State<BackIdScanScreen>
    with BackIdScanMixin {
  @override
  void initState() {
    super.initState();
    processId = widget.processId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<BackIdScanBloc, BackIdScanState>(
        listener: (context, state) async {
          if (state.status == BackIdScanStatus.success) {
            if (mrz == null) {
              // MRZ bulunamazsa error state'e geç
              return;
            }
            await Future<void>.delayed(const Duration(seconds: 2));
            if (context.mounted) {
              unawaited(
                context.router.replace(
                  NfcScanRoute(processId: widget.processId, mrz: mrz!),
                ),
              );
            }
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(LocaleKeys.back_side_scan_title.translate),
          ),
          body: BlocBuilder<BackIdScanBloc, BackIdScanState>(
            builder: _buildBody,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BackIdScanState state) {
    switch (state.status) {
      case BackIdScanStatus.initial:
        return _buildInitialView(context);
      case BackIdScanStatus.loading:
        return Center(child: _buildLoadingView(context));
      case BackIdScanStatus.success:
        return Center(child: _buildSuccessView(context));
      case BackIdScanStatus.error:
        return _buildErrorView(context, state.message);
      default:
        return _buildInitialView(context);
    }
  }

  Widget _buildInitialView(BuildContext context) {
    return Padding(
      padding: context.paddingBase,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: IconSizeConstants.xl * 2,
            height: IconSizeConstants.xl * 2,
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.badge_outlined,
              size: IconSizeConstants.xl,
              color: context.colorScheme.primary,
            ),
          ),
          context.spacingNormalHeight,
          Text(
            LocaleKeys.back_side_scan_title.translate,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          context.spacingLowHeight,
          Padding(
            padding: context.paddingLowHorizontal,
            child: Text(
              LocaleKeys.back_side_scan_description.translate,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          context.spacingMediumHeight,
          PrimaryElevatedButton(
            text: LocaleKeys.continue_button.translate,
            onPressed: onBackIdScanStart,
          ),
          context.spacingNormalHeight,
          SurfaceElevatedButton(
            text: LocaleKeys.cancel.translate,
            onPressed: () => context.router.pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Padding(
      padding: context.paddingLowAll,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.upload,
            size: IconSizeConstants.xl * 2,
            color: context.colorScheme.primary,
          ),
          context.spacingLowHeight,
          Text(
            LocaleKeys.uploading.translate,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          context.spacingLowHeight,
          Text(
            LocaleKeys.uploading_description.translate,
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          context.spacingHighHeight,
          CircularProgressIndicator(
            color: context.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Padding(
      padding: context.paddingLowAll,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: IconSizeConstants.xl * 2,
            color: Colors.green,
          ),
          context.spacingLowHeight,
          Text(
            LocaleKeys.success.translate,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          context.spacingLowHeight,
          Text(
            LocaleKeys.success_and_navigate.translate,
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String? message) {
    return Padding(
      padding: context.paddingLowAll,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.refresh,
            size: IconSizeConstants.xl * 2,
            color: Colors.red,
          ),
          context.spacingLowHeight,
          Text(
            LocaleKeys.error.translate,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          context.spacingLowHeight,
          Text(
            message ?? LocaleKeys.unknown_error.translate,
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          context.spacingHighHeight,
          PrimaryElevatedButton(
            text: LocaleKeys.try_again.translate,
            onPressed: onBackIdScanStart,
            color: Colors.red,
          ),
          context.spacingLowHeight,
          SurfaceElevatedButton(
            text: LocaleKeys.back.translate,
            onPressed: () => context.router.pop(),
          ),
        ],
      ),
    );
  }
}
