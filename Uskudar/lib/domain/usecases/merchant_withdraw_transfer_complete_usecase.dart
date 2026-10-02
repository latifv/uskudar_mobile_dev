import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/repositories/transfers_repository.dart';

final class MerchantWithdrawTransferCompleteUsecase
    implements BaseUsecase<String, String> {
  MerchantWithdrawTransferCompleteUsecase(this.repository);

  final TransfersRepository repository;

  @override
  Future<Either<Failure, String>> call(String transactionId) async {
    final result = await repository.merchantWithdrawTransferComplete(
      transactionId,
    );
    return result;
  }
}
