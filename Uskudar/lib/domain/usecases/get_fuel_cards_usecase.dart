import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/fuel_card.dart';
import 'package:uskudar_mobile/domain/repositories/fuel_cards_repository.dart';

final class GetFuelCardsUsecase
    implements BaseUsecaseWithoutParams<List<FuelCard>> {
  GetFuelCardsUsecase(this.repository);

  final FuelCardsRepository repository;

  @override
  Future<Either<Failure, List<FuelCard>>> call() async {
    return repository.getFuelCards();
  }
}
