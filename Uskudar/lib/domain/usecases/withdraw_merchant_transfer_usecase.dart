import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/withdraw_transfer.dart';
import 'package:payinall/domain/params/merchant_withdraw_transfer_params.dart';
import 'package:payinall/domain/repositories/transfers_repository.dart';

final class WithdrawMerchantTransferUsecase
    implements BaseUsecase<WithdrawTransfer, MerchantWithdrawTransferParams> {
  WithdrawMerchantTransferUsecase(this.repository);

  final TransfersRepository repository;

  @override
  Future<Either<Failure, WithdrawTransfer>> call(
    MerchantWithdrawTransferParams params,
  ) async {
    final result = await repository.withdrawMerchantTransfer(params);
    return result;
  }
}
