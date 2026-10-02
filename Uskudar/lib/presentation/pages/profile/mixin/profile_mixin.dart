import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/app_inherited_widget.dart';
import 'package:uskudar_mobile/core/constants/localization_constants.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/core/utils/app_utils.dart';
import 'package:uskudar_mobile/data/datasources/local/app_local_data_source.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/home/bloc/home_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/paycore_cards/paycore_cards_screen.dart';
import 'package:uskudar_mobile/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/widgets/language_selection_dialog.dart';

mixin ProfileMixin<T extends StatefulWidget> on State<T> {
  late final ProfileBloc bloc;
  late final HomeBloc homeBloc;
  late final ScrollController scrollController;
  late final UserInfoManager userInfoManager;
  late final AppLocalDataSource _appLocalDataSource;

  @override
  void initState() {
    super.initState();
    bloc = getIt<ProfileBloc>();
    homeBloc = getIt<HomeBloc>();
    scrollController = ScrollController();
    userInfoManager = getIt<UserInfoManager>();
    _appLocalDataSource = getIt<AppLocalDataSource>();
    loadProfile();
  }

  @override
  void dispose() {
    scrollController.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void loadProfile() {
    bloc.add(const ProfileLoadData());
  }

  Future<void> refreshProfile() async {
    bloc.add(const ProfileLoadData(refresh: true));
  }

  void onLogoutPressed() {
    bloc.add(const ProfileLogout());
  }

  void onDeleteAccountPressed() {
    bloc.add(const ProfileDeleteAccount());
  }

  void navigateToPendingMoneyRequests() {
    unawaited(context.router.push(const PendingMoneyRequestsRoute()));
  }

  void navigateToChangePassword() {
    unawaited(context.router.push(const ChangePasswordRoute()));
  }

  void navigateToBankAccounts() {
    unawaited(context.router.push(const BankAccountsRoute()));
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

  void navigateToNotificationSettings() {
    unawaited(context.router.push(const NotificationSettingsRoute()));
  }

  void copyWalletAddressToClipboard(String walletAddress) {
    unawaited(AppUtils.copyToClipboard(walletAddress, context));
  }

  void navigateToChangePhoneNumber() {
    unawaited(context.router.push(const SecurityChangePhoneRoute()));
  }

  void navigateToWrongLoginAttempts() {
    unawaited(context.router.push(const WrongLoginAttemptsRoute()));
  }

  void navigateToAdminPanel() {
    unawaited(context.router.push(const AdminRoute()));
  }

  void navigateToSecretQuestion() {
    unawaited(context.router.push(const SecretQuestionRoute()));
  }

  Future<void> navigateToAvatarSelection() async {
    final result = await context.router.push<bool>(
      const AvatarSelectionRoute(),
    );
    if (result ?? false) {
      bloc.add(const ProfileLoadData());
      homeBloc.add(HomeUpdateAvatarImage(userInfoManager.image));
    }
  }

  Future<bool> getIsDarkMode() async {
    final result = await _appLocalDataSource.getIsDarkMode();
    return result;
  }

  Future<void> toggleDarkMode(bool isDarkMode) async {
    await _appLocalDataSource.setIsDarkMode(isDarkMode);
    if (mounted) {
      final appInherited = AppInheritedWidget.of(context);
      appInherited?.updateThemeMode(isDarkMode);
    }
  }

  Future<String> getSelectedLanguage() async {
    final savedLanguage = await _appLocalDataSource.getSelectedLanguage();
    if (savedLanguage == null) {
      if (mounted) {
        return context.locale.languageCode;
      }
      return LocalizationConstants.fallbackLocale.languageCode;
    }
    return savedLanguage;
  }

  Future<void> changeLanguage(Locale locale) async {
    if (mounted) {
      final appInherited = AppInheritedWidget.of(context);
      if (appInherited != null) {
        await appInherited.updateLocale(locale);
      } else {
        await _appLocalDataSource.setSelectedLanguage(locale.languageCode);
        if (mounted) {
          unawaited(context.setLocale(locale));
        }
      }
    }
  }

  void showLanguageSelectionDialog() {
    unawaited(
      getSelectedLanguage().then((selectedLanguage) {
        if (mounted) {
          unawaited(
            LanguageSelectionDialog.show(
              context: context,
              selectedLanguage: selectedLanguage,
              onLanguageSelected: changeLanguage,
            ),
          );
        }
      }),
    );
  }

  Future<void> navigateToEmailUpdate() async {
    bloc.add(const ProfileSendEmailUpdateCode());
  }

  Future<void> navigateToEmailChange() async {
    final result = await context.router.push<bool>(
      const ChangeEmailRoute(),
    );
    if (result ?? false) {
      bloc.add(const ProfileLoadData());
    }
  }

  Future<void> onEmailUpdateCodeSent(String processCode) async {
    final result = await context.router.push<bool>(
      EmailVerificationRoute(
        email: userInfoManager.email,
        emailVerificationType: 0,
        processCode: processCode,
      ),
    );

    if (mounted) {
      if (result ?? false) {
        bloc.add(const ProfileLoadData(refresh: true));
      } else {
        bloc.add(const ProfileLoadData());
      }
    }
  }
}
