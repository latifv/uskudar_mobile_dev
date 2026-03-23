import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/bill_inquiry.dart';
import 'package:payinall/domain/entities/bill_product.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

final class BillPaymentConfirmationSection extends StatelessWidget {
  const BillPaymentConfirmationSection({
    required this.selectedProduct,
    required this.billInquiry,
    required this.onPayment,
    required this.onGoBack,
    required this.isLoading,
    required this.formatCurrency,
    required this.formatDate,
    super.key,
  });

  final BillProduct selectedProduct;
  final BillInquiry billInquiry;
  final VoidCallback onPayment;
  final VoidCallback onGoBack;
  final bool isLoading;
  final String Function(double) formatCurrency;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onGoBack,
              icon: const Icon(
                Icons.arrow_back,
                size: IconSizeConstants.m,
              ),
            ),
            context.spacingLowWidth,
            Expanded(
              child: Text(
                LocaleKeys.bill_payment_confirmation.translate,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        context.spacingNormalHeight,
        Center(
          child: CircleAvatar(
            radius: IconSizeConstants.xl,
            backgroundColor: context.colorScheme.primary.withValues(
              alpha: 0.05,
            ),
            child: Icon(
              Icons.receipt_long,
              color: context.colorScheme.primary,
              size: IconSizeConstants.xl,
            ),
          ),
        ),
        Center(
          child: Text(
            LocaleKeys.bill_details.translate,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        context.spacingNormalHeight,
        Column(
          children: [
            _DetailRow(
              label: LocaleKeys.institution.translate,
              value: selectedProduct.productName,
            ),
            _DetailRow(
              label: LocaleKeys.subscriber_name.translate,
              value: billInquiry.subscriberName,
            ),
            _DetailRow(
              label: LocaleKeys.bill_number.translate,
              value: billInquiry.billNo,
            ),
            _DetailRow(
              label: LocaleKeys.due_date.translate,
              value: formatDate(billInquiry.billDueDate),
              valueColor: _getDueDateColor(
                context,
                billInquiry.billDueDate,
              ),
            ),
            Divider(color: context.colorScheme.outline.withValues(alpha: 0.3)),
            _DetailRow(
              label: LocaleKeys.amount.translate,
              value: formatCurrency(billInquiry.invoiceAmount),
              valueColor: context.colorScheme.primary,
              isAmount: true,
            ),
          ],
        ),
        context.spacingNormalHeight,
        SizedBox(
          width: double.infinity,
          child: PrimaryElevatedButton(
            text:
                '${LocaleKeys.pay_now.translate} ${formatCurrency(billInquiry.invoiceAmount)}',
            onPressed: onPayment,
          ),
        ),
        context.spacingNormalHeight,
        ListTile(
          leading: Icon(
            Icons.warning_amber_outlined,
            color: context.colorScheme.error,
          ),
          title: Text(
            LocaleKeys.payment_warning.translate,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.error,
            ),
          ),
          contentPadding: context.paddingLowHorizontal,
        ),
      ],
    );
  }

  Color? _getDueDateColor(BuildContext context, DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    if (difference < 0) {
      return context.colorScheme.error;
    } else if (difference <= 3) {
      return Colors.orange;
    } else {
      return null;
    }
  }
}

final class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isAmount = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isAmount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: Text(
        value,
        style: isAmount
            ? context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: valueColor ?? context.colorScheme.primary,
              )
            : context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
      ),
    );
  }
}
