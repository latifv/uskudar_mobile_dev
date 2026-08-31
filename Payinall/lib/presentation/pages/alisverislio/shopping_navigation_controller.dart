import 'package:flutter/foundation.dart';

enum ShoppingDestination {
  discountPoints,
  giftChecks,
  fuel,
}

final class ShoppingNavigationController
    extends ValueNotifier<ShoppingDestination> {
  ShoppingNavigationController() : super(ShoppingDestination.discountPoints);

  void show(ShoppingDestination destination) {
    if (value != destination) value = destination;
  }
}

final shoppingNavigationController = ShoppingNavigationController();
