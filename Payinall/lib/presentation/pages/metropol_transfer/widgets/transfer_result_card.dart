import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/metropol_transfer_result.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

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
    return IntegrationSurface(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(context, 'Mağaza', result.merchantName),
          const SizedBox(height: 8),
          _buildRow(
            context,
            'Konum',
            '${result.districtName}/${result.cityName}',
          ),
          const SizedBox(height: 8),
          _buildRow(context, 'Tutar', '${result.requestAmount} ₺'),
          if (result.productName.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildRow(context, 'Ürün', result.productName),
          ],
          if (result.kdv.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildRow(context, 'KDV', '${result.kdv} ₺'),
          ],
          const SizedBox(height: 14),
          PrimaryElevatedButton(
            onPressed: onConfirm,
            text: 'Onayla',
            height: 48,
          ),
        ],
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
