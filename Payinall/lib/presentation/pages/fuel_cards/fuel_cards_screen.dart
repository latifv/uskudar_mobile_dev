import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/fuel_provider.dart';
import 'package:payinall/presentation/pages/fuel_cards/bloc/fuel_cards_bloc.dart';
import 'package:payinall/presentation/pages/fuel_cards/fuel_provider_detail_screen.dart';
import 'package:payinall/presentation/pages/fuel_cards/mixin/fuel_cards_mixin.dart';
import 'package:payinall/presentation/pages/fuel_cards/widgets/fuel_card_item.dart';
import 'package:payinall/presentation/pages/fuel_cards/widgets/fuel_provider_card.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
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
      ),
      body: BlocConsumer<FuelCardsBloc, FuelCardsState>(
        bloc: bloc,
        listener: blocListener,
        builder: (context, state) {
          return switch (state.status) {
            FuelCardsStatus.initial ||
            FuelCardsStatus.loading => const Center(child: CustomLoading()),
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
    return RefreshIndicator(
      onRefresh: () async => loadCards(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Text(
            LocaleKeys.fuel_choose_provider.translate,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: FuelProvider.values.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 112,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final provider = FuelProvider.values[index];
              return FuelProviderCard(
                provider: provider,
                onTap: () => _openProvider(provider),
              );
            },
          ),
          const SizedBox(height: 22),
          Text(
            LocaleKeys.fuel_linked_cards.translate,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          if (state.cards.isEmpty)
            _buildEmptyState()
          else
            ...state.cards.map(
              (card) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: FuelCardItem(
                  card: card,
                  balance: state.balances[card.id],
                  onTopUp: () => navigateToTopUp(card),
                  onDelete: () => onDeleteCard(card.id),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openProvider(FuelProvider provider) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => FuelProviderDetailScreen(provider: provider),
      ),
    );
    loadCards();
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_gas_station_outlined,
            size: 40,
            color: context.colorScheme.onSurfaceVariant.withAlpha(100),
          ),
          context.spacingNormalHeight,
          Text(
            LocaleKeys.fuel_card_empty.translate,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
