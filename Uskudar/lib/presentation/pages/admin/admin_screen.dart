import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/admin/bloc/admin_bloc.dart';
import 'package:payinall/presentation/pages/admin/mixin/admin_mixin.dart';
import 'package:payinall/presentation/pages/admin/widgets/admin_stat_card.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

final class _AdminScreenState extends State<AdminScreen> with AdminMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(LocaleKeys.admin_panel.translate),
        ),
        body: SafeArea(
          child: BlocBuilder<AdminBloc, AdminState>(
            builder: (_, state) {
              if (state.status == AdminStatus.loading) {
                return const Center(child: CustomLoading());
              }
              if (state.status == AdminStatus.error) {
                return _buildErrorBody(state.message);
              }
              return SingleChildScrollView(
                padding: context.paddingBase,
                child: _buildBody(state),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AdminState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminStatCard(
          title: LocaleKeys.user_count.translate,
          value: state.userCountSummary?.count.toString() ?? '0',
          description: state.userCountSummary?.timeTypeDescription ?? '',
          onTimeTypeChanged: onRefreshUserCount,
          icon: Icons.people,
          iconColor: context.colorScheme.primary,
        ),
        context.spacingLowHeight,
        AdminStatCard(
          title: LocaleKeys.merchant_count.translate,
          value: state.merchantCountSummary?.count.toString() ?? '0',
          description: state.merchantCountSummary?.timeTypeDescription ?? '',
          onTimeTypeChanged: onRefreshMerchantCount,
          icon: Icons.store,
          iconColor: context.colorScheme.secondary,
        ),
        context.spacingLowHeight,
        AdminStatCard(
          title: LocaleKeys.commission.translate,
          value:
              '${state.commissionSummary?.amount.toStringAsFixed(2) ?? '0.00'} ₺',
          description: state.commissionSummary?.timeTypeDescription ?? '',
          onTimeTypeChanged: onRefreshCommissionSummary,
          icon: Icons.attach_money,
          iconColor: Colors.green,
        ),
        context.spacingLowHeight,
        AdminStatCard(
          title: LocaleKeys.wallet_transfer_total.translate,
          value:
              '${state.walletTransferSummary?.amount.toStringAsFixed(2) ?? '0.00'} ₺',
          description: state.walletTransferSummary?.timeTypeDescription ?? '',
          onTimeTypeChanged: onRefreshWalletTransferSummary,
          icon: Icons.swap_horiz,
          iconColor: Colors.blue,
        ),
        context.spacingLowHeight,
        AdminStatCard(
          title: LocaleKeys.deposit_total.translate,
          value:
              '${state.depositTransferSummary?.amount.toStringAsFixed(2) ?? '0.00'} ₺',
          description: state.depositTransferSummary?.timeTypeDescription ?? '',
          onTimeTypeChanged: onRefreshDepositTransferSummary,
          icon: Icons.add_circle,
          iconColor: Colors.orange,
        ),
        context.spacingLowHeight,
        AdminStatCard(
          title: LocaleKeys.withdraw_total.translate,
          value:
              '${state.withdrawTransferSummary?.amount.toStringAsFixed(2) ?? '0.00'} ₺',
          description: state.withdrawTransferSummary?.timeTypeDescription ?? '',
          onTimeTypeChanged: onRefreshWithdrawTransferSummary,
          icon: Icons.remove_circle,
          iconColor: Colors.red,
        ),
        context.spacingLowHeight,
      ],
    );
  }

  Widget _buildErrorBody(String? message) {
    return ErrorTryAgain(
      message: message ?? LocaleKeys.unknown_error.translate,
      onTryAgain: onAdminLoadData,
    );
  }
}
