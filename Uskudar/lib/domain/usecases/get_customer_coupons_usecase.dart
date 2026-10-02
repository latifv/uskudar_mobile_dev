import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/customer_coupon.dart';
import 'package:uskudar_mobile/domain/repositories/gift_checks_repository.dart';

final class GetCustomerCouponsUsecase
    implements BaseUsecaseWithoutParams<List<CustomerCoupon>> {
  GetCustomerCouponsUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, List<CustomerCoupon>>> call() async {
    return repository.getCustomerCoupons();
  }
}
