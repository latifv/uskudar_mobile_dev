import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/admin_user_count_summary.dart';
import 'package:uskudar_mobile/domain/params/admin_user_count_params.dart';
import 'package:uskudar_mobile/domain/repositories/admin_repository.dart';

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
