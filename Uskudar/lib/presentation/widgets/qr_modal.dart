import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class QrModal extends StatelessWidget {
  const QrModal({
    required this.onClose,
    super.key,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: context.dynamicHeight(0.18),
        margin: context.paddingNormalAll,
        padding: context.paddingNormalAll,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: context.borderRadiusNormalAll,
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.onSurface.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildQrOption(
                    context: context,
                    icon: Icons.qr_code_scanner_outlined,
                    title: LocaleKeys.qr_scan.translate,
                    onTap: () {
                      onClose();
                      unawaited(context.router.push(const QrScanRoute()));
                    },
                  ),
                  VerticalDivider(
                    color: context.colorScheme.outlineVariant,
                    thickness: 1,
                  ),
                  _buildQrOption(
                    context: context,
                    icon: Icons.credit_card_rounded,
                    title: LocaleKeys.metropol.translate,
                    onTap: () {
                      onClose();
                      unawaited(
                        context.router.push(const MetropolTransferRoute()),
                      );
                    },
                  ),
                  VerticalDivider(
                    color: context.colorScheme.outlineVariant,
                    thickness: 1,
                  ),
                  _buildQrOption(
                    context: context,
                    icon: Icons.qr_code_2_outlined,
                    title: LocaleKeys.qr_generate.translate,
                    onTap: () {
                      onClose();
                      unawaited(context.router.push(const QrGenerateRoute()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: context.borderRadiusLowAll,
        child: Container(
          padding: context.paddingLowAll,
          decoration: BoxDecoration(
            borderRadius: context.borderRadiusLowAll,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: IconSizeConstants.l,
              ),
              context.spacingLowHeight,
              Text(
                title,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
