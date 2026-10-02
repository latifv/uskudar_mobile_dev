import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/fuel_card.dart';
import 'package:payinall/domain/repositories/fuel_cards_repository.dart';

final class GetFuelCardsUsecase
    implements BaseUsecaseWithoutParams<List<FuelCard>> {
  GetFuelCardsUsecase(this.repository);

  final FuelCardsRepository repository;

  @override
  Future<Either<Failure, List<FuelCard>>> call() async {
    return repository.getFuelCards();
  }
}
