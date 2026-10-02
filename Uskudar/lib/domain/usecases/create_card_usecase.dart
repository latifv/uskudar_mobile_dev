import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/create_card_params.dart';
import 'package:payinall/domain/repositories/campaigns_repository.dart';

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
