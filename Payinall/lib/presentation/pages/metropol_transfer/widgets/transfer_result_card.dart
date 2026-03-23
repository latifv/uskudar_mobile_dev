import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/metropol_transfer_result.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

final class TransferResultCard extends StatelessWidget {
  const TransferResultCard({
    required this.result,
    required this.onConfirm,
    super.key,
  });

  final MetropolTransferResult result;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusNormalAll,
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: context.paddingNormalAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(context, 'Mağaza', result.merchantName),
            context.spacingLowHeight,
            _buildRow(
              context,
              'Konum',
              '${result.districtName}/${result.cityName}',
            ),
            context.spacingLowHeight,
            _buildRow(context, 'Tutar', '${result.requestAmount} ₺'),
            if (result.productName.isNotEmpty) ...[
              context.spacingLowHeight,
              _buildRow(context, 'Ürün', result.productName),
            ],
            if (result.kdv.isNotEmpty) ...[
              context.spacingLowHeight,
              _buildRow(context, 'KDV', '${result.kdv} ₺'),
            ],
            context.spacingNormalHeight,
            PrimaryElevatedButton(
              onPressed: onConfirm,
              text: 'Onayla',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
