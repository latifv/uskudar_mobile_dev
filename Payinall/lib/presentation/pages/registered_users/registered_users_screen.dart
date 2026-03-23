import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/registered_users/bloc/registered_users_bloc.dart';
import 'package:payinall/presentation/pages/registered_users/mixin/registered_users_mixin.dart';
import 'package:payinall/presentation/pages/registered_users/widgets/frequent_iban_card.dart';
import 'package:payinall/presentation/pages/registered_users/widgets/frequently_sent_card.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_empty_list.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class RegisteredUsersScreen extends StatefulWidget {
  const RegisteredUsersScreen({super.key});

  @override
  State<RegisteredUsersScreen> createState() => _RegisteredUsersScreenState();
}

final class _RegisteredUsersScreenState extends State<RegisteredUsersScreen>
    with TickerProviderStateMixin, RegisteredUsersMixin {
  @override
  void initState() {
    super.initState();
    initRegisteredUsersMixin(this);
  }

  @override
  void dispose() {
    disposeRegisteredUsersMixin();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<RegisteredUsersBloc, RegisteredUsersState>(
        listener: blocListener,
        builder: (_, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Text(LocaleKeys.registered_users_title.translate),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: isMerchant ? onAddIbanPressed : onAddUserPressed,
              child: const Icon(Icons.add),
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(RegisteredUsersState state) {
    if (state.status == RegisteredUsersStatus.loading ||
        state.status == RegisteredUsersStatus.initial) {
      return const Center(child: CustomLoading());
    }

    if (state.status == RegisteredUsersStatus.error) {
      return ErrorTryAgain(
        message: state.message ?? LocaleKeys.unknown_error.translate,
        onTryAgain: loadData,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => loadData(),
      child: Padding(
        padding: context.paddingBaseLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.registered_users_description.translate,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(179),
              ),
            ),
            context.spacingNormalHeight,
            Expanded(
              child: isMerchant ? _buildIbanList(state) : _buildUserList(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(RegisteredUsersState state) {
    if (state.frequentlySents.isEmpty) {
      return CustomEmptyList(
        iconData: Icons.people_outline,
        title: LocaleKeys.registered_users_tab.translate,
        description: LocaleKeys.registered_users_empty.translate,
      );
    }

    return ListView.separated(
      itemCount: state.frequentlySents.length,
      separatorBuilder: (_, __) => context.spacingLowHeight,
      itemBuilder: (_, index) {
        final user = state.frequentlySents[index];
        return FrequentlySentCard(
          user: user,
          onDelete: () => onDeleteUser(user),
        );
      },
    );
  }

  Widget _buildIbanList(RegisteredUsersState state) {
    if (state.frequentIbans.isEmpty) {
      return CustomEmptyList(
        iconData: Icons.account_balance_outlined,
        title: LocaleKeys.registered_ibans_tab.translate,
        description: LocaleKeys.registered_ibans_empty.translate,
      );
    }

    return ListView.separated(
      itemCount: state.frequentIbans.length,
      separatorBuilder: (_, __) => context.spacingLowHeight,
      itemBuilder: (_, index) {
        final iban = state.frequentIbans[index];
        return FrequentIbanCard(
          iban: iban,
          onDelete: () => onDeleteIban(iban),
        );
      },
    );
  }
}
