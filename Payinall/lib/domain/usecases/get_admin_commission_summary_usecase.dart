import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/admin_commission_summary.dart';
import 'package:payinall/domain/params/admin_commission_summary_params.dart';
import 'package:payinall/domain/repositories/admin_repository.dart';

final class GetAdminCommissionSummaryUsecase
    implements
        BaseUsecase<AdminCommissionSummary, AdminCommissionSummaryParams> {
  GetAdminCommissionSummaryUsecase(this.repository);

  final AdminRepository repository;

  @override
  Future<Either<Failure, AdminCommissionSummary>> call(
    AdminCommissionSummaryParams params,
  ) async {
    final result = await repository.getCommissionSummary(params);
    return result;
  }
}
