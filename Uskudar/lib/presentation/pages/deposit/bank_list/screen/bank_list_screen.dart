import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/app_bank.dart';
import 'package:uskudar_mobile/presentation/pages/deposit/bank_list/bloc/bank_list_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/deposit/bank_list/bloc/bank_list_event.dart';
import 'package:uskudar_mobile/presentation/pages/deposit/bank_list/bloc/bank_list_state.dart';
import 'package:uskudar_mobile/presentation/pages/deposit/bank_list/mixin/bank_list_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/deposit/bank_list/widgets/bank_card.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';

@RoutePage()
final class BankListScreen extends StatefulWidget {
  const BankListScreen({super.key});

  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

final class _BankListScreenState extends State<BankListScreen>
    with BankListMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(const BankListFetched());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.load.translate)),
      body: Padding(padding: context.paddingBaseLow, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<BankListBloc, BankListState>(
        listener: (_, state) {
          if (state.status == BankListStatus.error) {
            onError(state.message ?? LocaleKeys.unknown_error.translate);
          }
        },
        builder: (_, state) {
          if (state.status == BankListStatus.initial) {
            return const Center(child: CustomLoading());
          } else if (state.status == BankListStatus.loading) {
            return const Center(child: CustomLoading());
          } else if (state.status == BankListStatus.loaded) {
            return _buildBankList(state.banks ?? [], state.selectedBankId);
          } else if (state.status == BankListStatus.error) {
            return ErrorTryAgain(
              message: state.message,
              onTryAgain: () => bloc.add(const BankListFetched()),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBankList(List<AppBank> banks, int? selectedBankId) {
    if (banks.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys.no_data.translate,
          style: context.textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: context.paddingLowVertical,
      itemCount: banks.length,
      itemBuilder: (context, index) {
        final bank = banks[index];
        return BankCard(bank: bank, onTap: onBankSelected);
      },
    );
  }
}
