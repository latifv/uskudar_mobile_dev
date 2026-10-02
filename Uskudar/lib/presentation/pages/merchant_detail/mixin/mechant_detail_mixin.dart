import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/merchant_detail/bloc/merchant_detail_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/snackbar_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin MerchantDetailMixin<T extends StatefulWidget> on State<T> {
  late final MerchantDetailBloc bloc;
  late final UserInfoManager userInfoManager;

  @override
  void initState() {
    super.initState();
    bloc = getIt<MerchantDetailBloc>();
    userInfoManager = getIt<UserInfoManager>();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(_, MerchantDetailState state) {
    switch (state.status) {
      case MerchantDetailStatus.initial:
      case MerchantDetailStatus.processing:
        break;
      case MerchantDetailStatus.cardSuccess:
        unawaited(createQrCode());
      case MerchantDetailStatus.qrCodeSuccess:
        _navigateToQrCodeScreen(state.qrCode, getImageUrl());
      case MerchantDetailStatus.error:
        SnackBarComponent.showErrorSnackBar(
          context: context,
          message: state.message,
        );
    }
  }

  void _navigateToQrCodeScreen(String? qrCode, String imageUrl) {
    if (qrCode == null) {
      SnackBarComponent.showErrorSnackBar(
        context: context,
        message: LocaleKeys.unknown_error.translate,
      );
      return;
    }
    unawaited(
      context.router.push(
        CampaignQrCodeRoute(qrCode: qrCode, imageUrl: imageUrl),
      ),
    );
  }

  String getImageUrl();

  Future<void> createQrCode() async {
    if (userInfoManager.isExWallet ?? false) {
      bloc.add(const MerchantDetailCreateQrCode());
      return;
    }

    final agreementsAccepted = await _checkAndAcceptIWalletAgreements();

    if (agreementsAccepted != true) {
      return;
    }

    bloc.add(const MerchantDetailCreateCard());
  }

  Future<bool?> _checkAndAcceptIWalletAgreements() async {
    try {
      final result = await context.router.push<bool>(
        const IWalletAgreementsRoute(),
      );
      return result;
    } on Exception {
      return false;
    }
  }
}
