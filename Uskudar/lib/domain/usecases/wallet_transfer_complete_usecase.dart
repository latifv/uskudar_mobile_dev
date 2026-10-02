import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/repositories/transfers_repository.dart';

final class WalletTransferCompleteUsecase
    implements BaseUsecase<String, String> {
  WalletTransferCompleteUsecase(this.repository);

  final TransfersRepository repository;

  @override
  Future<Either<Failure, String>> call(String transactionId) async {
    final result = await repository.walletTransferComplete(transactionId);
    return result;
  }
}
