import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/customer_coupon.dart';
import 'package:payinall/domain/repositories/gift_checks_repository.dart';

final class GetCustomerCouponsUsecase
    implements BaseUsecaseWithoutParams<List<CustomerCoupon>> {
  GetCustomerCouponsUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, List<CustomerCoupon>>> call() async {
    return repository.getCustomerCoupons();
  }
}
