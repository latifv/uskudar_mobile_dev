import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/admin_deposit_transfer_summary.dart';
import 'package:uskudar_mobile/domain/params/admin_deposit_transfer_summary_params.dart';
import 'package:uskudar_mobile/domain/repositories/admin_repository.dart';

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
