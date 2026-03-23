import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/constants/icon_asset_constants.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/enums/bottom_page_enum.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_dialog.dart';

final class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

final class _AppDrawerState extends State<AppDrawer> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = getIt<ProfileBloc>();
  }

  @override
  void dispose() {
    unawaited(_profileBloc.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: BlocListener<ProfileBloc, ProfileState>(
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
          }
        },
        child: ClipRect(
          child: Drawer(
            width: context.dynamicWidth(0.85),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(child: _buildNavigationItems(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding:
                  context.paddingNormalHorizontal + context.paddingLowVertical,
              margin: context.paddingMediumLeft,
              decoration: BoxDecoration(
                borderRadius: context.borderRadiusLowAll,
                border: Border.all(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  context.router.pop();
                },
                child: Icon(
                  Icons.close,
                  size: IconSizeConstants.m,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          Image.asset(
            IconAssetsConstants.logo,
            height: context.dynamicHeight(0.15),
            width: context.dynamicWidth(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItems(BuildContext context) {
    return ListView(
      padding: context.paddingLowVertical,
      children: [
        _buildSectionHeader(
          context,
          title: LocaleKeys.drawer_money_transfer.translate,
        ),
        _buildNavigationItem(
          context,
          title: LocaleKeys.transfer_money.translate,
          icon: Icons.send_outlined,
          onTap: () {
            unawaited(context.router.push(TransferMethodRoute()));
          },
        ),
        _buildNavigationItem(
          context,
          title: LocaleKeys.drawer_abroad_transfer.translate,
          icon: Icons.public_outlined,
          onTap: () {
            context.router.pop();
            final tabsRouter = context.tabsRouter;
            final isMerchant = getIt<UserInfoManager>().isMerchant;
            tabsRouter.setActiveIndex(
              isMerchant
                  ? BottomPageEnum.payments.index
                  : BottomPageEnum.international.index,
            );
          },
        ),
        _buildNavigationItem(
          context,
          title: LocaleKeys.drawer_registered_users.translate,
          icon: Icons.people_outline,
          onTap: () {
            unawaited(context.router.push(const RegisteredUsersRoute()));
          },
        ),
        _buildNavigationItem(
          context,
          title: LocaleKeys.drawer_my_transactions.translate,
          icon: Icons.receipt_long_outlined,
          onTap: () {
            context.router.pop();
            context.tabsRouter.setActiveIndex(
              BottomPageEnum.transactions.index,
            );
          },
        ),
        _buildDivider(context),
        _buildSectionHeader(
          context,
          title: LocaleKeys.drawer_my_info.translate,
        ),
        _buildNavigationItem(
          context,
          title: LocaleKeys.commission_rates.translate,
          icon: Icons.monetization_on_outlined,
          onTap: () {
            unawaited(context.router.push(const CommissionRatesRoute()));
          },
        ),
        _buildNavigationItem(
          context,
          title: LocaleKeys.account_limits.translate,
          icon: Icons.account_balance_wallet_outlined,
          onTap: () {
            unawaited(context.router.push(const AccountLimitsRoute()));
          },
        ),
        _buildDivider(context),

        _buildSectionHeader(
          context,
          title: LocaleKeys.drawer_support.translate,
        ),
        _buildNavigationItem(
          context,
          title: LocaleKeys.faq.translate,
          icon: Icons.help_center_outlined,
          onTap: () {
            unawaited(context.router.push(const FaqRoute()));
          },
        ),
        _buildNavigationItem(
          context,
          title: LocaleKeys.contact_us.translate,
          icon: Icons.contact_mail_outlined,
          onTap: () {
            unawaited(context.router.push(const ContactInfoRoute()));
          },
        ),
        _buildNavigationItem(
          context,
          title: LocaleKeys.customer_demand_title.translate,
          icon: Icons.message_outlined,
          onTap: () {
            unawaited(context.router.push(const CustomerDemandRoute()));
          },
        ),
        _buildNavigationItem(
          context,
          title: LocaleKeys.agreements_and_policies.translate,
          icon: Icons.description_outlined,
          onTap: () {
            unawaited(context.router.push(const AgreementsRoute()));
          },
        ),
        _buildDivider(context),

        _buildNavigationItem(
          context,
          title: LocaleKeys.logout.translate,
          icon: Icons.logout_outlined,
          onTap: _showLogoutDialog,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Padding(
      padding: context.paddingMediumHorizontal + context.paddingLowVertical,
      child: Text(
        title,
        style: context.textTheme.titleSmall?.copyWith(
          color: context.colorScheme.onSurface.withValues(alpha: 0.5),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: context.paddingMediumHorizontal,
      child: Divider(
        color: context.colorScheme.onSurface.withValues(alpha: 0.175),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final iconColor = isDestructive
        ? context.colorScheme.error
        : context.colorScheme.primary;
    final textColor = isDestructive
        ? context.colorScheme.error
        : context.colorScheme.onSurface;

    return ListTile(
      leading: Container(
        padding: context.paddingNormalAll,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: IconSizeConstants.n,
        ),
      ),
      title: Text(
        title,
        style: context.textTheme.bodyMedium?.copyWith(
          color: textColor,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.logout.translate,
        description: LocaleKeys.logout_description.translate,
        icon: Icons.logout,
        color: context.colorScheme.error,
        textColor: context.colorScheme.surface,
        primaryButtonText: LocaleKeys.logout.translate,
        onPrimaryButtonPressed: () {
          _profileBloc.add(const ProfileLogout());
        },
      ),
    );
  }
}
