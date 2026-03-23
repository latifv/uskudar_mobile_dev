import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/fuel_card.dart';
import 'package:payinall/domain/params/create_fuel_card_params.dart';
import 'package:payinall/domain/params/fuel_card_top_up_params.dart';

abstract interface class FuelCardsRepository {
  Future<Either<Failure, String>> createFuelCard(CreateFuelCardParams params);
  Future<Either<Failure, List<FuelCard>>> getFuelCards();
  Future<Either<Failure, String>> deleteFuelCard(int id);
  Future<Either<Failure, String>> fuelCardTopUp(FuelCardTopUpParams params);
  Future<Either<Failure, double>> getFuelCardBalance(int id);
}
