import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/admin_merchant_count_summary.dart';
import 'package:payinall/domain/params/admin_merchant_count_params.dart';
import 'package:payinall/domain/repositories/admin_repository.dart';

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
