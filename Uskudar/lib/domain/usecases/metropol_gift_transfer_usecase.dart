import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/metropol_gift_transfer_params.dart';
import 'package:uskudar_mobile/domain/repositories/metropols_repository.dart';

final class MetropolGiftTransferUsecase
    implements BaseUsecase<String, MetropolGiftTransferParams> {
  MetropolGiftTransferUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, String>> call(
    MetropolGiftTransferParams params,
  ) async {
    return repository.metropolGiftTransfer(params);
  }
}
