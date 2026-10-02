import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/metropol_transfer_result.dart';
import 'package:payinall/domain/params/metropol_transfer_params.dart';
import 'package:payinall/domain/repositories/metropols_repository.dart';

final class MetropolTransferUsecase
    implements BaseUsecase<MetropolTransferResult, MetropolTransferParams> {
  MetropolTransferUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, MetropolTransferResult>> call(
    MetropolTransferParams params,
  ) async {
    return repository.metropolTransfer(params);
  }
}
