import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/fuel_card_top_up_params.dart';
import 'package:uskudar_mobile/domain/repositories/fuel_cards_repository.dart';

final class FuelCardTopUpUsecase
    implements BaseUsecase<String, FuelCardTopUpParams> {
  FuelCardTopUpUsecase(this.repository);

  final FuelCardsRepository repository;

  @override
  Future<Either<Failure, String>> call(FuelCardTopUpParams params) async {
    return repository.fuelCardTopUp(params);
  }
}
