import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/fuel_cards/bloc/fuel_cards_bloc.dart';
import 'package:payinall/presentation/pages/fuel_cards/mixin/fuel_cards_mixin.dart';
import 'package:payinall/presentation/pages/fuel_cards/widgets/fuel_card_item.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class FuelCardsScreen extends StatefulWidget {
  const FuelCardsScreen({super.key});

  @override
  State<FuelCardsScreen> createState() => _FuelCardsScreenState();
}

final class _FuelCardsScreenState extends State<FuelCardsScreen>
    with FuelCardsMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.fuel_cards.translate),
        actions: [
          IconButton(
            onPressed: navigateToAddFuelCard,
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: context.colorScheme.primary,
            ),
            tooltip: LocaleKeys.add_card.translate,
          ),
        ],
      ),
      body: BlocConsumer<FuelCardsBloc, FuelCardsState>(
        bloc: bloc,
        listener: blocListener,
        builder: (context, state) {
          return switch (state.status) {
            FuelCardsStatus.initial || FuelCardsStatus.loading =>
              const Center(child: CustomLoading()),
            FuelCardsStatus.error when state.cards.isEmpty => Center(
                child: ErrorTryAgain(
                  message: state.message,
                  onTryAgain: loadCards,
                ),
              ),
            _ => _buildContent(state),
          };
        },
      ),
    );
  }

  Widget _buildContent(FuelCardsState state) {
    if (state.cards.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => loadCards(),
      child: ListView.separated(
        padding: context.paddingNormalAll,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.cards.length,
        separatorBuilder: (_, __) => context.spacingNormalHeight,
        itemBuilder: (context, index) {
          final card = state.cards[index];
          return FuelCardItem(
            card: card,
            balance: state.balances[card.id],
            onTopUp: () => navigateToTopUp(card),
            onDelete: () => onDeleteCard(card.id),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_gas_station_outlined,
            size: 64,
            color: context.colorScheme.onSurfaceVariant.withAlpha(100),
          ),
          context.spacingNormalHeight,
          Text(
            LocaleKeys.fuel_card_empty.translate,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          context.spacingNormalHeight,
          FilledButton.icon(
            onPressed: navigateToAddFuelCard,
            icon: const Icon(Icons.add_rounded),
            label: Text(LocaleKeys.add_card.translate),
          ),
        ],
      ),
    );
  }
}
