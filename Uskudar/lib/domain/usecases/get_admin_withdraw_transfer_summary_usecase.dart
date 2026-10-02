import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/admin_withdraw_transfer_summary.dart';
import 'package:uskudar_mobile/domain/params/admin_withdraw_transfer_summary_params.dart';
import 'package:uskudar_mobile/domain/repositories/admin_repository.dart';

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
