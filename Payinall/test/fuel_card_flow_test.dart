import 'package:flutter_test/flutter_test.dart';
import 'package:payinall/data/dtos/requests/create_fuel_card_request.dart';
import 'package:payinall/domain/entities/fuel_provider.dart';
import 'package:payinall/domain/params/create_fuel_card_params.dart';

void main() {
  test('fuel providers use the documented card type values', () {
    expect(FuelProvider.opet.cardType, 1);
    expect(FuelProvider.petrolOfisi.cardType, 2);
    expect(FuelProvider.shell.cardType, 3);
  });

  test('Petrol Ofisi activation fields are serialized', () {
    final request = CreateFuelCardRequest.fromParams(
      const CreateFuelCardParams(
        cardNo: '7000782130318182',
        cardType: 2,
        plate: '06ABC123',
        fuelType: 1,
      ),
    );

    expect(request.toJson(), {
      'cardNo': '7000782130318182',
      'cardType': 2,
      'plate': '06ABC123',
      'fuelType': 1,
    });
  });
}
