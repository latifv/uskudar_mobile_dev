import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/constants/app_constants.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/transaction_detail/bloc/transaction_detail_bloc.dart';
import 'package:payinall/presentation/pages/transaction_detail/mixin/transaction_detail_mixin.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/datetime_extension.dart';
import 'package:payinall/presentation/shared/extensions/double_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({required this.transactionId, super.key});

  final String transactionId;

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

final class _TransactionDetailScreenState extends State<TransactionDetailScreen>
    with TransactionDetailMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc..add(TransactionDetailLoadData(widget.transactionId)),
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(LocaleKeys.transfer_details.translate),
        ),
        body: SafeArea(
          child: BlocConsumer<TransactionDetailBloc, TransactionDetailState>(
            listener: blocListener,
            builder: (_, state) {
              if (state.status == TransactionDetailStatus.loading) {
                return const Center(child: CustomLoading());
              }
              if (state.status == TransactionDetailStatus.error) {
                return _buildErrorBody();
              }
              return _buildBody(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(TransactionDetailState state) {
    if (state.receipt == null) {
      return Center(child: Text(LocaleKeys.no_data.translate));
    }

    final receipt = state.receipt!;
    final safeAmount = receipt.amount;
    final safeCommission = receipt.commissionAmount;

    return SingleChildScrollView(
      padding: context.paddingNormalAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: context.borderRadiusLowAll,
            ),
            child: Container(
              padding: context.paddingNormalAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.transfer_details.translate,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  context.spacingNormalHeight,
                  _buildDetailRow(
                    context,
                    LocaleKeys.recipient.translate,
                    receipt.toCustomerFullName,
                  ),
                  _buildDetailRow(
                    context,
                    LocaleKeys.address.translate,
                    receipt.toCustomerNumber,
                  ),
                  _buildDetailRow(
                    context,
                    LocaleKeys.transfer_amount.translate,
                    safeAmount.toFormattedCurrency(),
                  ),
                  _buildDetailRow(
                    context,
                    LocaleKeys.transaction_fee.translate,
                    safeCommission.toFormattedCurrency(),
                  ),
                  if (safeCommission > 0)
                    _buildDetailRow(
                      context,
                      LocaleKeys.commission_from.translate,
                      receipt.commissionFromTypeName,
                    ),
                  _buildDetailRow(
                    context,
                    LocaleKeys.date.translate,
                    receipt.createdDate.toFormattedDateTime(),
                  ),
                  if (receipt.description.isNotEmpty)
                    _buildDetailRow(
                      context,
                      LocaleKeys.description.translate,
                      receipt.description,
                    ),
                ],
              ),
            ),
          ),
          context.spacingNormalHeight,
          _buildViewReceiptButton(
            AppConstants.receiptUrl(widget.transactionId),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String? value, {
    bool isHighlighted = false,
  }) {
    if (value == null) return const SizedBox.shrink();

    return Container(
      padding: context.paddingLowVertical,
      decoration: isHighlighted
          ? BoxDecoration(
              color: context.colorScheme.primary.withAlpha(26),
              borderRadius: context.borderRadiusLowAll,
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? context.colorScheme.primary : null,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: isHighlighted
                        ? context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          )
                        : context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewReceiptButton(String receiptUrl) {
    return PrimaryElevatedButton(
      onPressed: () => onOpenReceiptUrl(receiptUrl),
      text: LocaleKeys.view_receipt.translate,
    );
  }

  Widget _buildErrorBody() {
    return ErrorTryAgain(
      message: LocaleKeys.unknown_error.translate,
      onTryAgain: () => onLoadData(widget.transactionId),
    );
  }
}
