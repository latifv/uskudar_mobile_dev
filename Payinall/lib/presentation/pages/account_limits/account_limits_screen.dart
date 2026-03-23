import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/customer_process.dart';
import 'package:payinall/presentation/pages/account_limits/bloc/account_limits_bloc.dart';
import 'package:payinall/presentation/pages/account_limits/mixin/account_limits_mixin.dart';
import 'package:payinall/presentation/pages/account_limits/widgets/account_limit_item.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_empty_list.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class AccountLimitsScreen extends StatefulWidget {
  const AccountLimitsScreen({super.key});

  @override
  State<AccountLimitsScreen> createState() => _AccountLimitsScreenState();
}

final class _AccountLimitsScreenState extends State<AccountLimitsScreen>
    with AccountLimitsMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: CustomAppBar(title: Text(LocaleKeys.account_limits.translate)),
        body: BlocBuilder<AccountLimitsBloc, AccountLimitsState>(
          builder: (_, state) {
            switch (state.status) {
              case AccountLimitsStatus.initial:
              case AccountLimitsStatus.loading:
                return const Center(child: CustomLoading());
              case AccountLimitsStatus.error:
                return ErrorTryAgain(
                  message: state.message ?? LocaleKeys.unknown_error.translate,
                  onTryAgain: loadAccountLimits,
                );
              case AccountLimitsStatus.loaded:
                if (state.limits?.isEmpty ?? true) {
                  return CustomEmptyList(
                    iconData: Icons.account_balance_wallet_outlined,
                    title: LocaleKeys.account_limits.translate,
                    description:
                        LocaleKeys.account_limits_empty_description.translate,
                  );
                }
                return Padding(
                  padding: context.paddingBase,
                  child: _buildBody(state.limits),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody(List<CustomerProcess>? limits) {
    return RefreshIndicator(
      onRefresh: () async {
        refreshAccountLimits();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.spacingLowHeight,
          Text(
            LocaleKeys.my_limits.translate,
            style: context.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          context.spacingLowHeight,
          Text(
            LocaleKeys.my_limits_description.translate,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(164),
            ),
          ),
          context.spacingNormalHeight,
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: limits?.length ?? 0,
              itemBuilder: (context, index) {
                final limit = limits![index];
                return AccountLimitItem(limit: limit);
              },
            ),
          ),
        ],
      ),
    );
  }
}
