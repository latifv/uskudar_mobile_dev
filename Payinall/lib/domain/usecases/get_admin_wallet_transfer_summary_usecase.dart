import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/admin_wallet_transfer_summary.dart';
import 'package:payinall/domain/params/admin_wallet_transfer_summary_params.dart';
import 'package:payinall/domain/repositories/admin_repository.dart';

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
