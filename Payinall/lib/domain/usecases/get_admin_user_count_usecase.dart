import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/admin_user_count_summary.dart';
import 'package:payinall/domain/params/admin_user_count_params.dart';
import 'package:payinall/domain/repositories/admin_repository.dart';

final class GetAdminUserCountUsecase
    implements BaseUsecase<AdminUserCountSummary, AdminUserCountParams> {
  GetAdminUserCountUsecase(this.repository);

  final AdminRepository repository;

  @override
  Future<Either<Failure, AdminUserCountSummary>> call(
    AdminUserCountParams params,
  ) async {
    final result = await repository.getUserCount(params);
    return result;
  }
}
