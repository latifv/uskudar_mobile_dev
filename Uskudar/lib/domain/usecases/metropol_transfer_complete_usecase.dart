import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/metropol_transfer_complete_params.dart';
import 'package:payinall/domain/repositories/metropols_repository.dart';

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
