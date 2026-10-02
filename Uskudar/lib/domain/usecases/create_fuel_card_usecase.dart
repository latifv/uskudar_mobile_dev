import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/create_fuel_card_params.dart';
import 'package:uskudar_mobile/domain/repositories/fuel_cards_repository.dart';

final class CreateFuelCardUsecase
    implements BaseUsecase<String, CreateFuelCardParams> {
  CreateFuelCardUsecase(this.repository);

  final FuelCardsRepository repository;

  @override
  Future<Either<Failure, String>> call(CreateFuelCardParams params) async {
    return repository.createFuelCard(params);
  }
}
