import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/repositories/fuel_cards_repository.dart';

final class GetFuelCardBalanceUsecase implements BaseUsecase<double, int> {
  GetFuelCardBalanceUsecase(this.repository);

  final FuelCardsRepository repository;

  @override
  Future<Either<Failure, double>> call(int id) async {
    return repository.getFuelCardBalance(id);
  }
}
