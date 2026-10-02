import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/create_card_params.dart';
import 'package:uskudar_mobile/domain/repositories/campaigns_repository.dart';

final class CreateCardUsecase implements BaseUsecase<void, CreateCardParams> {
  CreateCardUsecase(this.repository);

  final CampaignsRepository repository;

  @override
  Future<Either<Failure, void>> call(
    CreateCardParams params,
  ) async {
    final result = await repository.createCard(params);
    return result;
  }
}
