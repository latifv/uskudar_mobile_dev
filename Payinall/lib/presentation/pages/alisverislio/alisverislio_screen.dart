import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/presentation/pages/alisverislio/shopping_navigation_controller.dart';
import 'package:payinall/presentation/pages/fuel_cards/fuel_cards_screen.dart';
import 'package:payinall/presentation/pages/gift_checks/gift_checks_screen.dart';
import 'package:payinall/presentation/pages/metropol_locations/metropol_locations_screen.dart';

@RoutePage()
final class AlisverislioScreen extends StatefulWidget {
  const AlisverislioScreen({super.key});

  @override
  State<AlisverislioScreen> createState() => _AlisverislioScreenState();
}

final class _AlisverislioScreenState extends State<AlisverislioScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ShoppingDestination>(
      valueListenable: shoppingNavigationController,
      builder: (context, destination, _) {
        return PopScope(
          canPop: destination == ShoppingDestination.discountPoints,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              shoppingNavigationController.show(
                ShoppingDestination.discountPoints,
              );
            }
          },
          child: KeyedSubtree(
            key: ValueKey(destination),
            child: switch (destination) {
              ShoppingDestination.discountPoints =>
                const MetropolLocationsScreen(),
              ShoppingDestination.giftChecks => const GiftChecksScreen(),
              ShoppingDestination.fuel => const FuelCardsScreen(),
            },
          ),
        );
      },
    );
  }
}
