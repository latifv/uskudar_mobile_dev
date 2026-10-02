import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/admin_merchant_count_summary.dart';
import 'package:uskudar_mobile/domain/params/admin_merchant_count_params.dart';
import 'package:uskudar_mobile/domain/repositories/admin_repository.dart';

final class GetAdminMerchantCountUsecase
    implements
        BaseUsecase<AdminMerchantCountSummary, AdminMerchantCountParams> {
  GetAdminMerchantCountUsecase(this.repository);

  final AdminRepository repository;

  @override
  Future<Either<Failure, AdminMerchantCountSummary>> call(
    AdminMerchantCountParams params,
  ) async {
    final result = await repository.getMerchantCount(params);
    return result;
  }
}
