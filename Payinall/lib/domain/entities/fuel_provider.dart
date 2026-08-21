import 'package:flutter/material.dart';

enum FuelType {
  gasoline(1),
  diesel(2);

  const FuelType(this.apiValue);

  final int apiValue;
}

final class FuelProvider {
  const FuelProvider({
    required this.cardType,
    required this.name,
    required this.brandColor,
    required this.cardNumberHint,
    this.requiresVehicleDetails = false,
  });

  final int cardType;
  final String name;
  final Color brandColor;
  final String cardNumberHint;
  final bool requiresVehicleDetails;

  static const opet = FuelProvider(
    cardType: 1,
    name: 'Opet',
    brandColor: Color(0xFF1686C9),
    cardNumberHint: 'Opet Kart',
  );

  static const petrolOfisi = FuelProvider(
    cardType: 2,
    name: 'Petrol Ofisi',
    brandColor: Color(0xFFE31E2F),
    cardNumberHint: 'Positive Card',
    requiresVehicleDetails: true,
  );

  static const shell = FuelProvider(
    cardType: 3,
    name: 'Shell',
    brandColor: Color(0xFFE51B23),
    cardNumberHint: 'Shell ClubSmart',
  );

  static const List<FuelProvider> values = [shell, opet, petrolOfisi];

  static FuelProvider fromCardType(int cardType) {
    return values.firstWhere(
      (provider) => provider.cardType == cardType,
      orElse: () => shell,
    );
  }
}
