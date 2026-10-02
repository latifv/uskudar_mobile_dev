import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/international_transfer_result.dart';
import 'package:payinall/presentation/pages/international_money_transfer/widgets/international_transfer_details_card.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class InternationalTransferResultScreen extends StatelessWidget {
  const InternationalTransferResultScreen({
    required this.transferResult,
    super.key,
  });

  final InternationalTransferResult transferResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.transfer_result.translate),
      ),
      body: SafeArea(
        child: Padding(
          padding: context.paddingNormalAll,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSuccessIcon(context),
                      context.spacingNormalHeight,
                      Text(
                        LocaleKeys.transfer_success.translate,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      context.spacingMediumHeight,
                      InternationalTransferDetailsCard(
                        transferResult: transferResult,
                      ),
                    ],
                  ),
                ),
              ),
              context.spacingNormalHeight,
              SizedBox(
                width: double.infinity,
                child: PrimaryElevatedButton(
                  text: LocaleKeys.go_main_page.translate,
                  onPressed: () {
                    unawaited(context.router.replaceAll([const HomeRoute()]));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 50,
      ),
    );
  }
}
