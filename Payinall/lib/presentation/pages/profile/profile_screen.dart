import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:payinall/presentation/pages/profile/mixin/profile_mixin.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/double_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_dialog.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final class _ProfileScreenState extends State<ProfileScreen> with ProfileMixin {
  final _circleAvatarRadius = 40.0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadDarkMode());
  }

  Future<void> _loadDarkMode() async {
    final isDarkMode = await getIsDarkMode();
    if (mounted) {
      setState(() {
        _isDarkMode = isDarkMode;
      });
    }
  }

  Future<void> _onDarkModeChanged(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    await toggleDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.loggedOut) {
            unawaited(context.router.replaceAll([LoginRoute()]));
            if (state.message != null) {
              ToastComponent.showSuccessToast(
                context: context,
                message: state.message,
              );
            }
          } else if (state.status == ProfileStatus.error) {
            ToastComponent.showErrorToast(
              context: context,
              message: state.message,
            );
          } else if (state.status == ProfileStatus.balanceChecked) {
            _handleBalanceCheckResult(state);
          } else if (state.status == ProfileStatus.emailUpdateCodeSent) {
            unawaited(onEmailUpdateCodeSent(state.emailProcessCode ?? ''));
          }
        },
        builder: (_, state) {
          return Scaffold(body: _buildBody(state));
        },
      ),
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state.status == ProfileStatus.loading) {
      return const Center(child: CustomLoading());
    }

    if (state.status == ProfileStatus.error) {
      return ErrorTryAgain(
        message: state.message ?? LocaleKeys.unknown_error.translate,
        onTryAgain: loadProfile,
      );
    }

    if (state.status == ProfileStatus.loaded ||
        state.status == ProfileStatus.balanceChecked ||
        state.status == ProfileStatus.emailUpdateCodeSent) {
      return _buildContent(state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildContent(ProfileState state) {
    return SafeArea(
      child: Column(
        children: [
          context.spacingNormalHeight,
          _buildHeader(state),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshProfile,
              color: context.colorScheme.primary,
              child: ListView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: context.paddingNormalAll,
                children: _buildMenuItems(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ProfileState state) {
    return Container(
      width: double.infinity,
      padding:
          context.paddingLowHorizontal + (context.paddingLowVertical * 0.225),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.router.pop(),
            icon: Icon(
              Icons.close,
              size: IconSizeConstants.m,
              color: context.colorScheme.onSurface,
            ),
          ),
          context.spacingNormalWidth,
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 60,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: _buildAvatar(state),
          ),
          context.spacingMediumWidth,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${state.name ?? ''} ${state.surname ?? ''}',
                style: context.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              context.spacingLowHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.walletAddress ?? '',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                  context.spacingLowWidth,
                  InkWell(
                    onTap: () =>
                        copyWalletAddressToClipboard(state.walletAddress ?? ''),
                    child: Icon(
                      Icons.copy,
                      size: IconSizeConstants.s,
                      color: context.colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    return [
      _buildDarkModeSwitch(),
      _buildDivider(),
      _buildMenuItem(
        LocaleKeys.language.translate,
        Icons.language_outlined,
        showLanguageSelectionDialog,
      ),
      _buildDivider(),
      if (!userInfoManager.isMerchant) ...[
        _buildMenuItem(
          LocaleKeys.change_password.translate,
          Icons.lock_outlined,
          navigateToChangePassword,
        ),
        _buildDivider(),
        if (userInfoManager.isMailConfirmed == true) ...[
          _buildMenuItem(
            LocaleKeys.change_email.translate,
            Icons.email_outlined,
            navigateToEmailChange,
          ),
          _buildDivider(),
        ] else ...[
          _buildMenuItem(
            LocaleKeys.update_email.translate,
            Icons.email_outlined,
            navigateToEmailUpdate,
          ),
          _buildDivider(),
        ],
      ],
      if (userInfoManager.isAdmin && !userInfoManager.isMerchant) ...[
        _buildMenuItem(
          LocaleKeys.admin_panel.translate,
          Icons.security_outlined,
          navigateToAdminPanel,
        ),
        _buildDivider(),
      ],
      if (!userInfoManager.isMerchant) ...[
        _buildMenuItem(
          LocaleKeys.change_phone.translate,
          Icons.phone_outlined,
          navigateToChangePhoneNumber,
        ),
        _buildDivider(),
      ],
      _buildMenuItem(
        LocaleKeys.wrong_login_attempts_title.translate,
        Icons.warning_outlined,
        navigateToWrongLoginAttempts,
      ),
      _buildDivider(),
      if (!userInfoManager.isMerchant) ...[
        _buildMenuItem(
          LocaleKeys.notification_settings.translate,
          Icons.notifications_outlined,
          navigateToNotificationSettings,
        ),
        _buildDivider(),
      ],
      _buildMenuItem(
        LocaleKeys.bank_accounts.translate,
        Icons.account_balance_outlined,
        navigateToBankAccounts,
      ),
      _buildDivider(),
      if (!userInfoManager.isMerchant) ...[
        _buildMenuItem(
          LocaleKeys.pending_money_requests.translate,
          Icons.access_time_outlined,
          navigateToPendingMoneyRequests,
        ),
        _buildDivider(),
        if (userInfoManager.isUserQuestionChange) ...[
          _buildMenuItem(
            LocaleKeys.update_secret_question.translate,
            Icons.security_outlined,
            navigateToSecretQuestion,
          ),
          _buildDivider(),
        ],
        _buildMenuItem(
          LocaleKeys.select_your_avatar.translate,
          Icons.person_outlined,
          navigateToAvatarSelection,
        ),
        _buildDivider(),
      ],
      // _buildMenuItem(
      //   LocaleKeys.logout.translate,
      //   Icons.logout_outlined,
      //   _showLogoutDialog,
      //   isDestructive: true,
      // ),
      // _buildDivider(),
      _buildMenuItem(
        LocaleKeys.delete_account.translate,
        Icons.person_remove_outlined,
        _showDeleteAccountDialog,
        isDestructive: true,
      ),
    ];
  }

  Divider _buildDivider() {
    return Divider(
      color: context.colorScheme.onSurface.withValues(alpha: 0.15),
      thickness: 0.5,
      height: 1,
    );
  }

  Widget _buildDarkModeSwitch() {
    return Container(
      margin: context.paddingLowVertical * .3,
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.dark_mode_outlined,
            color: context.colorScheme.primary,
            size: IconSizeConstants.m,
          ),
        ),
        title: Text(
          LocaleKeys.dark_mode.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Switch(
          value: _isDarkMode,
          onChanged: _onDarkModeChanged,
          activeColor: context.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final iconColor = isDestructive
        ? context.colorScheme.error
        : context.colorScheme.primary;
    final textColor = isDestructive
        ? context.colorScheme.error
        : context.colorScheme.onSurface;

    return Container(
      margin: context.paddingLowVertical * .3,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: IconSizeConstants.m,
          ),
        ),
        title: Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: IconSizeConstants.s,
          color: context.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  // void _showLogoutDialog() {
  //   CustomDialog.show(
  //     context: context,
  //     title: LocaleKeys.logout.translate,
  //     description: LocaleKeys.logout_description.translate,
  //     icon: Icons.logout,
  //     color: context.colorScheme.error,
  //     textColor: context.colorScheme.surface,
  //     primaryButtonText: LocaleKeys.logout.translate,
  //     onPrimaryButtonPressed: onLogoutPressed,
  //   );
  // }

  void _showDeleteAccountDialog() {
    bloc.add(const ProfileCheckBalance());
  }

  void _handleBalanceCheckResult(ProfileState state) {
    if (state.hasBalance) {
      unawaited(
        CustomDialog.show(
          context: context,
          title: LocaleKeys.warning.translate,
          description: LocaleKeys.delete_account_has_balance.translate
              .replaceAll('{amount}', state.balance.toFormattedCurrency()),
          icon: Icons.warning_amber_rounded,
          color: context.colorScheme.error,
          textColor: context.colorScheme.surface,
          primaryButtonText: LocaleKeys.ok.translate,
          onPrimaryButtonPressed: () {},
          surfaceButtonActive: false,
        ),
      );
    } else {
      unawaited(
        CustomDialog.show(
          context: context,
          title: LocaleKeys.delete_account.translate,
          description: LocaleKeys.delete_account_description.translate,
          icon: Icons.delete,
          color: context.colorScheme.error,
          textColor: context.colorScheme.surface,
          primaryButtonText: LocaleKeys.delete_account.translate,
          onPrimaryButtonPressed: onDeleteAccountPressed,
        ),
      );
    }
  }

  Widget _buildAvatar(ProfileState state) {
    if (state.image != null && state.image!.isNotEmpty) {
      return _buildCircleAvatar(state.image!);
    }
    return _buildInitialsAvatar(state);
  }

  Widget _buildCircleAvatar(String base64Image) {
    return CircleAvatar(
      radius: _circleAvatarRadius,
      backgroundColor: context.colorScheme.surface,
      backgroundImage: NetworkImage(base64Image),
    );
  }

  Widget _buildInitialsAvatar(ProfileState state) {
    return CircleAvatar(
      radius: _circleAvatarRadius,
      backgroundColor: context.colorScheme.surface,
      child: Text(
        (state.name?[0].toUpperCase() ?? '') +
            (state.surname?[0].toUpperCase() ?? ''),
        style: context.textTheme.headlineMedium?.copyWith(
          color: context.colorScheme.onSurface,
        ),
      ),
    );
  }
}
