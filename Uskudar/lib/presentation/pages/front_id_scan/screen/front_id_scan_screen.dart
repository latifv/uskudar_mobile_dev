import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/front_id_scan/bloc/front_id_scan_bloc.dart';
import 'package:payinall/presentation/pages/front_id_scan/mixin/front_id_scan_mixin.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/presentation/widgets/surface_elevated_button.dart';

@RoutePage()
final class FrontIdScanScreen extends StatefulWidget {
  const FrontIdScanScreen({super.key});

  @override
  State<FrontIdScanScreen> createState() => _FrontIdScanScreenState();
}

final class _FrontIdScanScreenState extends State<FrontIdScanScreen>
    with FrontIdScanMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<FrontIdScanBloc, FrontIdScanState>(
        listener: (context, state) async {
          if (state.status == FrontIdScanStatus.success) {
            if (state.processId == null) {
              return;
            }
            await Future<void>.delayed(const Duration(seconds: 2));
            if (context.mounted) {
              unawaited(
                context.router.replace(
                  BackIdScanRoute(processId: state.processId!),
                ),
              );
            }
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(LocaleKeys.front_side_scan_title.translate),
          ),
          body: BlocBuilder<FrontIdScanBloc, FrontIdScanState>(
            builder: _buildBody,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, FrontIdScanState state) {
    switch (state.status) {
      case FrontIdScanStatus.initial:
        return _buildInitialView(context);
      case FrontIdScanStatus.loading:
        return Center(child: _buildLoadingView(context));
      case FrontIdScanStatus.success:
        return Center(child: _buildSuccessView(context));
      case FrontIdScanStatus.error:
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
            LocaleKeys.front_side_scan_title.translate,
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
              LocaleKeys.front_side_scan_description.translate,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          context.spacingMediumHeight,
          PrimaryElevatedButton(
            text: LocaleKeys.continue_button.translate,
            onPressed: onFrontIdScanStart,
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
            onPressed: onFrontIdScanStart,
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
