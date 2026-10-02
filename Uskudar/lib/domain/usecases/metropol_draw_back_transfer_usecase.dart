import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/metropol_draw_back_transfer_params.dart';
import 'package:payinall/domain/repositories/metropols_repository.dart';

final class MetropolDrawBackTransferUsecase
    implements BaseUsecase<String, MetropolDrawBackTransferParams> {
  MetropolDrawBackTransferUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, String>> call(
    MetropolDrawBackTransferParams params,
  ) async {
    return repository.metropolDrawBackTransfer(params);
  }
}
