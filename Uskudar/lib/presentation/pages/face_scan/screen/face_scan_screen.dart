import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/face_scan/bloc/face_scan_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/face_scan/mixin/face_scan_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/home/bloc/home_bloc.dart';
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
final class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({
    required this.processId,
    required this.image,
    super.key,
  });

  final String processId;
  final String? image;

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

final class _FaceScanScreenState extends State<FaceScanScreen>
    with FaceScanMixin {
  @override
  void initState() {
    super.initState();
    processId = widget.processId;
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<FaceScanBloc, FaceScanState>(
        listener: (context, state) async {
          if (state.status == FaceScanStatus.success) {
            await Future<void>.delayed(const Duration(seconds: 3));
            if (context.mounted) {
              await context.router.push(const AddressPreviewRoute());
              getIt<HomeBloc>().add(const HomeRefreshUserInfo());
              if (context.mounted) {
                context.router.pop();
              }
            }
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(LocaleKeys.face_scan_title.translate),
          ),
          body: BlocBuilder<FaceScanBloc, FaceScanState>(
            builder: _buildBody,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, FaceScanState state) {
    switch (state.status) {
      case FaceScanStatus.initial:
        return _buildAgreementView(context);
      case FaceScanStatus.agreementsCompleted:
        return _buildInitialView(context);
      case FaceScanStatus.loading:
        return Center(child: _buildLoadingView(context));
      case FaceScanStatus.success:
        return Center(child: _buildSuccessView(context));
      case FaceScanStatus.error:
        return _buildErrorView(context, state.message);
    }
  }

  Widget _buildAgreementView(BuildContext context) {
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
              Icons.description,
              size: IconSizeConstants.xl,
              color: context.colorScheme.primary,
            ),
          ),
          context.spacingNormalHeight,
          Text(
            LocaleKeys.face_scan_agreement_title.translate,
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
              LocaleKeys.face_scan_agreement_description.translate,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          context.spacingMediumHeight,
          PrimaryElevatedButton(
            text: LocaleKeys.view_agreements.translate,
            onPressed: showAgreements,
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
              Icons.face,
              size: IconSizeConstants.xl,
              color: context.colorScheme.primary,
            ),
          ),
          context.spacingNormalHeight,
          Text(
            LocaleKeys.face_scan_title.translate,
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
              LocaleKeys.face_scan_description.translate,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          context.spacingMediumHeight,
          PrimaryElevatedButton(
            text: LocaleKeys.continue_button.translate,
            onPressed: onFaceScanStart,
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
            LocaleKeys.success_and_send_to_review.translate,
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
            onPressed: onFaceScanStart,
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
