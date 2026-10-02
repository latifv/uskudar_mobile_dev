import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/admin_deposit_transfer_summary.dart';
import 'package:payinall/domain/params/admin_deposit_transfer_summary_params.dart';
import 'package:payinall/domain/repositories/admin_repository.dart';

final class GetAdminDepositTransferSummaryUsecase
    implements
        BaseUsecase<
          AdminDepositTransferSummary,
          AdminDepositTransferSummaryParams
        > {
  GetAdminDepositTransferSummaryUsecase(this.repository);

  final AdminRepository repository;

  @override
  Future<Either<Failure, AdminDepositTransferSummary>> call(
    AdminDepositTransferSummaryParams params,
  ) async {
    final result = await repository.getDepositTransferSummary(params);
    return result;
  }
}
