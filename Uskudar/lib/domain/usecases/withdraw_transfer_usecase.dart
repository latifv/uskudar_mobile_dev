import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/withdraw_transfer.dart';
import 'package:payinall/domain/params/withdraw_transfer_params.dart';
import 'package:payinall/domain/repositories/transfers_repository.dart';

final class WithdrawTransferUsecase
    implements BaseUsecase<WithdrawTransfer, WithdrawTransferParams> {
  WithdrawTransferUsecase(this.repository);

  final TransfersRepository repository;

  @override
  Future<Either<Failure, WithdrawTransfer>> call(
    WithdrawTransferParams params,
  ) async {
    final result = await repository.withdrawTransfer(params);
    return result;
  }
}
