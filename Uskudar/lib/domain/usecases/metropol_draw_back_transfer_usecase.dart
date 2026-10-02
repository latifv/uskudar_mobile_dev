import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/metropol_draw_back_transfer_params.dart';
import 'package:uskudar_mobile/domain/repositories/metropols_repository.dart';

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
