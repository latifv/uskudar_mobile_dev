import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/admin_withdraw_transfer_summary.dart';
import 'package:payinall/domain/params/admin_withdraw_transfer_summary_params.dart';
import 'package:payinall/domain/repositories/admin_repository.dart';

final class GetAdminWithdrawTransferSummaryUsecase
    implements
        BaseUsecase<
          AdminWithdrawTransferSummary,
          AdminWithdrawTransferSummaryParams
        > {
  GetAdminWithdrawTransferSummaryUsecase(this.repository);

  final AdminRepository repository;

  @override
  Future<Either<Failure, AdminWithdrawTransferSummary>> call(
    AdminWithdrawTransferSummaryParams params,
  ) async {
    final result = await repository.getWithdrawTransferSummary(params);
    return result;
  }
}
