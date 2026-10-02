import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/metropol_transfer_complete_params.dart';
import 'package:uskudar_mobile/domain/repositories/metropols_repository.dart';

final class MetropolTransferCompleteUsecase
    implements BaseUsecase<String, MetropolTransferCompleteParams> {
  MetropolTransferCompleteUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, String>> call(
    MetropolTransferCompleteParams params,
  ) async {
    return repository.metropolTransferComplete(params);
  }
}
