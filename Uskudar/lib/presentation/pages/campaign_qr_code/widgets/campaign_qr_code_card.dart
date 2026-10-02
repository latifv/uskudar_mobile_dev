import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:qr_flutter/qr_flutter.dart';

final class CampaignQrCodeCard extends StatelessWidget {
  const CampaignQrCodeCard({
    required this.qrCode,
    required this.remainingTime,
    super.key,
  });

  final String qrCode;
  final String remainingTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildQrCode(context),
        context.spacingLowHeight,
        _buildTimerSection(context),
      ],
    );
  }

  Widget _buildQrCode(BuildContext context) {
    return Container(
      padding: context.paddingLowAll,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: context.borderRadiusNormalAll,
      ),
      child: QrImageView(
        data: qrCode,
        size: context.dynamicHeight(.25),
        foregroundColor: context.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildTimerSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.remaining_time.translate,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
        ),
        context.spacingLowHeight,
        Container(
          padding: context.paddingNormalAll,
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            borderRadius: context.borderRadiusNormalAll,
          ),
          child: Text(
            remainingTime,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.qr_expires_in.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(128),
          ),
        ),
      ],
    );
  }
}
