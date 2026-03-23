import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/fuel_card_top_up_params.dart';
import 'package:payinall/domain/repositories/fuel_cards_repository.dart';

final class FuelCardTopUpUsecase
    implements BaseUsecase<String, FuelCardTopUpParams> {
  FuelCardTopUpUsecase(this.repository);

  final FuelCardsRepository repository;

  @override
  Future<Either<Failure, String>> call(FuelCardTopUpParams params) async {
    return repository.fuelCardTopUp(params);
  }
}
