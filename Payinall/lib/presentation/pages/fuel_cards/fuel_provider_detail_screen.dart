import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/fuel_provider.dart';
import 'package:payinall/presentation/pages/add_fuel_card/add_fuel_card_screen.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class FuelProviderDetailScreen extends StatefulWidget {
  const FuelProviderDetailScreen({required this.provider, super.key});

  final FuelProvider provider;

  @override
  State<FuelProviderDetailScreen> createState() =>
      _FuelProviderDetailScreenState();
}

final class _FuelProviderDetailScreenState
    extends State<FuelProviderDetailScreen> {
  FuelProvider get provider => widget.provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(provider.name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            _FuelHero(provider: provider),
            const SizedBox(height: 14),
            _FuelStats(provider: provider),
            const SizedBox(height: 14),
            _HowItWorks(provider: provider),
            const SizedBox(height: 14),
            _FuelNotice(provider: provider),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () async {
                await Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) => AddFuelCardScreen(provider: provider),
                  ),
                );
              },
              icon: const Icon(Icons.add_card_rounded),
              label: Text(LocaleKeys.fuel_link_card.translate),
            ),
          ],
        ),
      ),
    );
  }
}

final class _FuelHero extends StatelessWidget {
  const _FuelHero({required this.provider});

  final FuelProvider provider;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 132,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: provider.brandColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      LocaleKeys.fuel_hero_description.translate,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 104,
              child: ColoredBox(
                color: context.colorScheme.primaryContainer,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_gas_station_rounded,
                        color: context.colorScheme.onPrimaryContainer,
                        size: 30,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        LocaleKeys.card_type.translate,
                        textAlign: TextAlign.center,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _FuelStats extends StatelessWidget {
  const _FuelStats({required this.provider});

  final FuelProvider provider;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: _Stat(
              icon: Icons.local_gas_station_outlined,
              label: LocaleKeys.fuel_payment_method.translate,
              value: provider.cardNumberHint,
            ),
          ),
          Expanded(
            child: _Stat(
              icon: Icons.money_off_csred_outlined,
              label: LocaleKeys.fuel_minimum_spend.translate,
              value: LocaleKeys.none.translate,
            ),
          ),
          Expanded(
            child: _Stat(
              icon: Icons.schedule_rounded,
              label: LocaleKeys.fuel_refund_time.translate,
              value: LocaleKeys.fuel_instant.translate,
            ),
          ),
        ],
      ),
    );
  }
}

final class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          IntegrationIconBox(icon: icon, size: 42),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

final class _HowItWorks extends StatelessWidget {
  const _HowItWorks({required this.provider});

  final FuelProvider provider;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.gift_check_how_it_works.translate,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Step(
                  number: 1,
                  icon: Icons.account_balance_wallet_outlined,
                  title: LocaleKeys.fuel_load_balance.translate,
                ),
              ),
              Expanded(
                child: _Step(
                  number: 2,
                  icon: Icons.local_gas_station_outlined,
                  title: LocaleKeys.fuel_use_card.translate,
                ),
              ),
              Expanded(
                child: _Step(
                  number: 3,
                  icon: Icons.savings_outlined,
                  title: LocaleKeys.fuel_earn_cashback.translate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _Step extends StatelessWidget {
  const _Step({required this.number, required this.icon, required this.title});

  final int number;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntegrationIconBox(icon: icon, size: 46),
        Transform.translate(
          offset: const Offset(0, -5),
          child: CircleAvatar(
            radius: 11,
            backgroundColor: context.colorScheme.primary,
            child: Text(
              '$number',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

final class _FuelNotice extends StatelessWidget {
  const _FuelNotice({required this.provider});

  final FuelProvider provider;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      backgroundColor: context.colorScheme.secondaryContainer,
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: context.colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.fuel_get_card_first.translate,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  LocaleKeys.fuel_link_card_description.translate,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
