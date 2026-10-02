import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/wallet_transfer.dart';
import 'package:uskudar_mobile/domain/entities/withdraw_transfer.dart';
import 'package:uskudar_mobile/domain/enums/transfer_method.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/confirmation/bloc/transfer_confirmation_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/confirmation/mixin/transfer_confirmation_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/confirmation/widgets/transfer_details_card.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class TransferConfirmationScreen extends StatefulWidget {
  const TransferConfirmationScreen({
    required this.transferMethod,
    super.key,
    this.walletTransfer,
    this.withdrawTransfer,
  });

  final TransferMethod transferMethod;
  final WalletTransfer? walletTransfer;
  final WithdrawTransfer? withdrawTransfer;

  @override
  State<TransferConfirmationScreen> createState() =>
      _TransferConfirmationScreenState();
}

final class _TransferConfirmationScreenState
    extends State<TransferConfirmationScreen>
    with TransferConfirmationMixin {
  @override
  void initState() {
    super.initState();
    walletTransfer = widget.walletTransfer;
    withdrawTransfer = widget.withdrawTransfer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.transfer_confirmation.translate),
      ),
      body: BlocProvider(
        create: (_) => bloc,
        child:
            BlocListener<TransferConfirmationBloc, TransferConfirmationState>(
              listener: (context, state) {
                if (state.status == TransferConfirmationStatus.success) {
                  onTransferSuccess(
                    widget.walletTransfer?.transactionNumber ??
                        widget.withdrawTransfer?.transactionNumber ??
                        '',
                  );
                  ToastComponent.showSuccessToast(
                    context: context,
                    message: state.message,
                  );
                } else if (state.status == TransferConfirmationStatus.error) {
                  onTransferError(
                    widget.walletTransfer?.transactionNumber ?? '',
                    state.message ?? LocaleKeys.unknown_error.translate,
                  );
                  ToastComponent.showErrorToast(
                    context: context,
                    message: state.message,
                  );
                }
              },
              child:
                  BlocBuilder<
                    TransferConfirmationBloc,
                    TransferConfirmationState
                  >(
                    builder: (context, state) {
                      if (state.status == TransferConfirmationStatus.loading) {
                        return const Center(child: CustomLoading());
                      }
                      return _buildContent(context, state);
                    },
                  ),
            ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransferConfirmationState state) {
    return SafeArea(
      child: Padding(
        padding: context.paddingBaseLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(context),
                context.spacingLowHeight,
                TransferDetailsCard(
                  walletTransfer: widget.walletTransfer,
                  withdrawTransfer: widget.withdrawTransfer,
                ),
              ],
            ),
            context.spacingLowHeight,
            _buildWarningSection(context),
            context.spacingNormalHeight,
            PrimaryElevatedButton(
              text: LocaleKeys.confirm_transfer.translate,
              onPressed: onConfirmPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Text(
      LocaleKeys.transfer_confirmation_description.translate,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurface.withAlpha(204),
      ),
    );
  }

  Widget _buildWarningSection(BuildContext context) {
    return Container(
      padding: context.paddingNormalAll,
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(30),
        border: Border.all(color: Colors.green),
        borderRadius: context.borderRadiusLowAll,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.green,
            size: IconSizeConstants.m,
          ),
          context.spacingLowWidth,
          Expanded(
            child: Text(
              LocaleKeys.transfer_confirmation_warning.translate,
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
