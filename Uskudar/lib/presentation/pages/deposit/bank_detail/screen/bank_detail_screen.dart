import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/utils/app_utils.dart';
import 'package:payinall/domain/entities/app_bank.dart';
import 'package:payinall/presentation/pages/deposit/bank_detail/bloc/bank_detail_bloc.dart';
import 'package:payinall/presentation/pages/deposit/bank_detail/bloc/bank_detail_event.dart';
import 'package:payinall/presentation/pages/deposit/bank_detail/bloc/bank_detail_state.dart';
import 'package:payinall/presentation/pages/deposit/bank_detail/mixin/bank_detail_mixin.dart';
import 'package:payinall/presentation/pages/deposit/bank_detail/widgets/bank_detail_card.dart';
import 'package:payinall/presentation/pages/deposit/bank_detail/widgets/wallet_address_section.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class BankDetailScreen extends StatefulWidget {
  const BankDetailScreen({required this.bank, super.key});

  final AppBank bank;

  @override
  State<BankDetailScreen> createState() => _BankDetailScreenState();
}

final class _BankDetailScreenState extends State<BankDetailScreen>
    with BankDetailMixin {
  @override
  void initState() {
    bank = widget.bank;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc
        ..add(BankDetailFetched(bank: bank))
        ..add(const BankDetailWalletAddressFetched());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.bank_account.translate)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<BankDetailBloc, BankDetailState>(
        listener: (_, state) {
          if (state.status == BankDetailStatus.error) {
            ToastComponent.showErrorToast(
              context: context,
              message: state.message ?? LocaleKeys.unknown_error.translate,
            );
          }
        },
        builder: (context, state) {
          if (state.status == BankDetailStatus.initial ||
              state.status == BankDetailStatus.loading) {
            return const Center(child: CustomLoading());
          } else if (state.status == BankDetailStatus.loaded) {
            return _buildBankDetail(state);
          } else if (state.status == BankDetailStatus.error) {
            return Center(
              child: ErrorTryAgain(
                message: state.message,
                onTryAgain: () => bloc.add(BankDetailFetched(bank: bank)),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBankDetail(BankDetailState state) {
    return SingleChildScrollView(
      padding: context.paddingBase,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.deposit_description.translate,
            style: context.textTheme.bodyMedium,
          ),
          context.spacingMediumHeight,
          _buildInfoBox(),
          context.spacingMediumHeight,
          if (state.bank != null)
            BankDetailCard(
              bank: state.bank!,
              onCopyIban: (text) => AppUtils.copyToClipboard(text, context),
            ),
          context.spacingNormalHeight,
          if (state.walletAddress != null)
            WalletAddressSection(
              walletAddress: state.walletAddress!,
              onCopyWalletAddress: (text) =>
                  AppUtils.copyToClipboard(text, context),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: context.paddingLowAll,
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withAlpha(26),
        borderRadius: context.borderRadiusLowAll,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: context.colorScheme.primary,
            size: IconSizeConstants.m,
          ),
          context.spacingLowWidth,
          Expanded(
            child: Text(
              LocaleKeys.deposit_description_wallet_address.translate,
              style: context.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
