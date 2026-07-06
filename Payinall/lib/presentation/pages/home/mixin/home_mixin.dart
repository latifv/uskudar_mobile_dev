import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/core/services/permission_service.dart';
import 'package:payinall/core/utils/app_utils.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/home/bloc/home_bloc.dart';
import 'package:payinall/presentation/pages/paycore_cards/paycore_cards_screen.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_dialog.dart';
import 'package:payinall/presentation/widgets/info_dialog.dart';

mixin HomeMixin<T extends StatefulWidget> on State<T> {
  late final HomeBloc bloc;
  late final PermissionService _permissionService;
  late final UserInfoManager userInfoManager;
  late bool _isAvatarFlag = false;

  @override
  void initState() {
    super.initState();
    bloc = getIt<HomeBloc>();
    unawaited(onHomeLoadData());
    _permissionService = getIt<PermissionService>();

    userInfoManager = getIt<UserInfoManager>();
  }

  Future<void> blocListener(_, HomeState state) async {
    if (state.customerType == 1 &&
        state.status == HomeStatus.requiredScoringQuestions) {
      await navigateToScoreQuestion();
    }

    if (state.lastWrongIpAddress != null &&
        state.lastWrongIpAddress!.isNotEmpty) {
      _showWrongPasswordDialog(
        state.lastWrongPasswordDate ?? '',
        state.lastWrongIpAddress!,
      );
    }

    if (state.status == HomeStatus.loaded &&
        state.image == null &&
        !_isAvatarFlag) {
      final isMerchant = userInfoManager.isMerchant;

      if (!isMerchant) {
        unawaited(navigateToAvatarSelection());
      }
    }
  }

  Future<void> onHomeRefreshData() async {
    bloc.add(const HomeRefreshData());
  }

  Future<void> onHomeLoadData() async {
    bloc.add(const HomeLoadData());
  }

  void copyUserNumberToClipboard(String walletAddress) {
    unawaited(AppUtils.copyToClipboard(walletAddress, context));
  }

  Future<void> navigateToFrontIdScan() async {
    final hasCameraPermission = await _permissionService.hasCameraPermission();

    if (hasCameraPermission && mounted) {
      // if (_userInfoManager.isAddedAddress == false) {
      // await context.router.push(const AddressConfirmationRoute());
      // bloc.add(const HomeRefreshUserInfo());
      // } else {
      unawaited(context.router.push(const FrontIdScanRoute()));
      // }
    } else {
      final result = await _showCameraPermissionDialog();
      if (result != null && result) {
        await _permissionService.requestCameraPermission();
        final hasPermissionAfterRequest = await _permissionService
            .hasCameraPermission();

        if (hasPermissionAfterRequest && mounted) {
          // if (_userInfoManager.isAddedAddress == false) {
          // await context.router.push(const AddressConfirmationRoute());
          // bloc.add(const HomeRefreshUserInfo());
          // } else {
          unawaited(context.router.push(const FrontIdScanRoute()));
          // }
        } else {
          _showPermissionDeniedDialog();
        }
      }
    }
  }

  Future<void> navigateToAddressPreview() async {
    await context.router.push(const AddressPreviewRoute());
    bloc.add(const HomeRefreshUserInfo());
  }

  Future<bool?> _showCameraPermissionDialog() async {
    return CustomDialog.show(
      context: context,
      title: LocaleKeys.camera_permission_required.translate,
      description: LocaleKeys.camera_permission_description.translate,
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
        description: LocaleKeys.camera_permission_denied.translate,
        icon: Icons.error_outline,
        color: context.colorScheme.error,
        primaryButtonText: LocaleKeys.open_settings.translate,
        onPrimaryButtonPressed: () {
          unawaited(_permissionService.openAppSettings());
        },
      ),
    );
  }

  void navigateToNotification() {
    unawaited(context.router.push(const NotificationRoute()));
  }

  void navigateToPageSearch() {
    unawaited(context.router.push(const RouteSearchRoute()));
  }

  void navigateToRequestMoney() {
    unawaited(context.router.push(const RequestMoneyRoute()));
  }

  Future<void> navigateToWithdrawMoney() async {
    await context.router.push(TransferMethodRoute(isWithdraw: true));
    bloc
      ..add(const HomeRefreshBalance())
      ..add(const HomeRefreshTransactions());
  }

  Future<void> navigateToScoreQuestion() async {
    final result = await context.router.push(const ScoringQuestionsRoute());
    if (result == true) {
      bloc.add(const HomeRefreshUserInfo());
    }
  }

  Future<void> navigateToSendMoney() async {
    await context.router.push(TransferMethodRoute());
    bloc
      ..add(const HomeRefreshBalance())
      ..add(const HomeRefreshTransactions());
  }

  Future<void> navigateToInternationalTransfer() async {
    await context.router.push(const CountrySelectionRoute());
    bloc
      ..add(const HomeRefreshBalance())
      ..add(const HomeRefreshTransactions());
  }

  void navigateToLoadMoney() {
    unawaited(context.router.push(const BankListRoute()));
  }

  void _showWrongPasswordDialog(String date, String ipAddress) {
    unawaited(
      InfoDialog.show(
        context: context,
        title: LocaleKeys.warning.translate,
        description:
            '${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(date))} tarihinde $ipAddress ip adresinden hatalı giriş denemesi yapıldı.',
        icon: Icons.warning_amber_rounded,
        iconColor: context.colorScheme.error,
      ),
    );
  }

  void dismissScoreQuestionCard() {
    bloc.add(const HomeDismissUserInfoCard(UserInfoCardType.scoreQuestion));
  }

  void dismissArkSignerCard() {
    bloc.add(const HomeDismissUserInfoCard(UserInfoCardType.arkSigner));
  }

  void dismissAddressVerificationCard() {
    bloc.add(
      const HomeDismissUserInfoCard(UserInfoCardType.addressVerification),
    );
  }

  void dismissAddressRejectedCard() {
    bloc.add(const HomeDismissUserInfoCard(UserInfoCardType.addressRejected));
  }

  void dismissAvatarSelectionCard() {
    bloc.add(const HomeDismissUserInfoCard(UserInfoCardType.avatarSelection));
  }

  Future<void> navigateToAvatarSelection() async {
    _isAvatarFlag = true;
    final result = await context.router.push(const AvatarSelectionRoute());
    if (result == true) {
      bloc.add(HomeUpdateAvatarImage(userInfoManager.image));
    } else {
      dismissAvatarSelectionCard();
    }
  }

  void navigateToProfile() {
    unawaited(context.router.push(const ProfileRoute()));
  }

  void navigateToPaycoreCards() {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const PaycoreCardsScreen(),
        ),
      ),
    );
  }
}
