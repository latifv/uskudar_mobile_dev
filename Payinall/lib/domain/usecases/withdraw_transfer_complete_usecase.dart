import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/repositories/transfers_repository.dart';

final class WithdrawTransferCompleteUsecase
    implements BaseUsecase<String, String> {
  WithdrawTransferCompleteUsecase(this.repository);

  final TransfersRepository repository;

  @override
  Future<Either<Failure, String>> call(String transactionId) async {
    final result = await repository.withdrawTransferComplete(transactionId);
    return result;
  }
}
