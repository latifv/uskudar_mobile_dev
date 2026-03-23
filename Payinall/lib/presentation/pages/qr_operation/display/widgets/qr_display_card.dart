import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/double_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class QrDisplayCard extends StatelessWidget {
  const QrDisplayCard({required this.qrImage, required this.amount, super.key});

  final Uint8List qrImage;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          LocaleKeys.qr_display_title.translate,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          LocaleKeys.qr_display_description.translate,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
          textAlign: TextAlign.center,
        ),
        _buildQrImage(context),
        _buildAmountRow(context),
      ],
    );
  }

  Widget _buildQrImage(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(.375),
      child: Image.memory(qrImage, fit: BoxFit.contain),
    );
  }

  Widget _buildAmountRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${LocaleKeys.amount.translate}:',
          style: context.textTheme.titleSmall,
        ),
        context.spacingLowWidth,
        Text(
          amount.toFormattedCurrency(),
          style: context.textTheme.titleMedium,
        ),
      ],
    );
  }
}
