import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/constants/app_constants.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/result/bloc/transfer_result_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/result/mixin/transfer_result_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/result/widgets/transfer_result_card.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

@RoutePage()
final class TransferResultScreen extends StatefulWidget {
  const TransferResultScreen({
    required this.transactionId,
    this.isSuccess = true,
    this.errorMessage,
    super.key,
  });

  final String transactionId;
  final bool isSuccess;
  final String? errorMessage;

  @override
  State<TransferResultScreen> createState() => _TransferResultScreenState();
}

final class _TransferResultScreenState extends State<TransferResultScreen>
    with TransferResultMixin {
  @override
  void initState() {
    transactionId = widget.transactionId;
    isSuccess = widget.isSuccess;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TransferResultBloc, TransferResultState>(
          bloc: transferResultBloc,
          builder: (context, state) {
            if (state.status == TransferResultStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == TransferResultStatus.error || !isSuccess) {
              return Center(
                child: Padding(
                  padding: context.paddingBase,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error,
                        size: IconSizeConstants.xxl,
                        color: Colors.red,
                      ),
                      context.spacingNormalHeight,
                      Text(
                        LocaleKeys.failed.translate,
                        style: context.textTheme.titleMedium,
                      ),
                      context.spacingNormalHeight,
                      Text(
                        state.errorMessage ??
                            widget.errorMessage ??
                            LocaleKeys.unknown_error.translate,
                        style: context.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      context.spacingNormalHeight,
                      ElevatedButton(
                        onPressed: onHomePressed,
                        child: Text(LocaleKeys.go_to_home.translate),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: context.paddingNormalHorizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    context.spacingLowHeight,
                    _buildStatusSuccess(),
                    if (state.receipt != null)
                      TransferResultCard(receipt: state.receipt!),
                    _buildActions(state),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusSuccess() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: IconSizeConstants.xxl,
          color: context.colorScheme.primary,
        ),
        context.spacingNormalWidth,
        Text(
          LocaleKeys.transfer_success.translate,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(TransferResultState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onHomePressed,
                child: Text(LocaleKeys.go_to_home.translate),
              ),
            ),
          ],
        ),
        context.spacingLowHeight,
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => openReceiptURL(
                  AppConstants.receiptUrl(widget.transactionId),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.surfaceVariant,
                  foregroundColor: context.colorScheme.onSurfaceVariant,
                ),
                child: Text(LocaleKeys.open_in_browser.translate),
              ),
            ),
          ],
        ),
        context.spacingMediumHeight,
      ],
    );
  }
}
