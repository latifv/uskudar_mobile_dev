import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/international_money_transfer/screen/country_selection_screen.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';

@RoutePage()
final class InternationalTransferSelectionScreen extends StatelessWidget {
  const InternationalTransferSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMerchant = getIt<UserInfoManager>().isMerchant;

    if (isMerchant) {
      return const CountrySelectionScreen();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.international_transfer_selection.translate),
      ),
      body: SafeArea(
        child: Padding(
          padding: context.paddingNormalAll,
          child: Column(
            children: [
              _buildOptionCard(
                context,
                icon: FontAwesomeIcons.paperPlane,
                title: LocaleKeys.send_money.translate,
                description: LocaleKeys.send_money_description.translate,
                onTap: () => _navigateToCountrySelection(context),
              ),
              context.spacingNormalHeight,
              _buildOptionCard(
                context,
                icon: FontAwesomeIcons.handHoldingDollar,
                title: LocaleKeys.receive_money.translate,
                description: LocaleKeys.receive_money_description.translate,
                onTap: () => _navigateToReceiveMoney(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: context.borderRadiusNormalAll,
        child: Padding(
          padding: context.paddingMediumAll,
          child: Row(
            children: [
              Container(
                padding: context.paddingNormalAll,
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: context.borderRadiusNormalAll,
                ),
                child: FaIcon(
                  icon,
                  color: context.colorScheme.onPrimaryContainer,
                ),
              ),
              context.spacingNormalWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    context.spacingLowHeight,
                    Text(
                      description,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCountrySelection(BuildContext context) {
    unawaited(context.router.push(const CountrySelectionRoute()));
  }

  void _navigateToReceiveMoney(BuildContext context) {
    unawaited(context.router.push(const ReceiveMoneyRoute()));
  }
}
