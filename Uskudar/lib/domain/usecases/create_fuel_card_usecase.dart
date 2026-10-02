import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/create_fuel_card_params.dart';
import 'package:payinall/domain/repositories/fuel_cards_repository.dart';

final class CreateFuelCardUsecase
    implements BaseUsecase<String, CreateFuelCardParams> {
  CreateFuelCardUsecase(this.repository);

  final FuelCardsRepository repository;

  @override
  Future<Either<Failure, String>> call(CreateFuelCardParams params) async {
    return repository.createFuelCard(params);
  }
}
