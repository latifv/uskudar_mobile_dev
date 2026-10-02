import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/admin_wallet_transfer_summary.dart';
import 'package:uskudar_mobile/domain/params/admin_wallet_transfer_summary_params.dart';
import 'package:uskudar_mobile/domain/repositories/admin_repository.dart';

final class GetAdminWalletTransferSummaryUsecase
    implements
        BaseUsecase<
          AdminWalletTransferSummary,
          AdminWalletTransferSummaryParams
        > {
  GetAdminWalletTransferSummaryUsecase(this.repository);

  final AdminRepository repository;

  @override
  Future<Either<Failure, AdminWalletTransferSummary>> call(
    AdminWalletTransferSummaryParams params,
  ) async {
    final result = await repository.getWalletTransferSummary(params);
    return result;
  }
}
