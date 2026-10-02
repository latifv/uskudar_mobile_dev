import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/coupon_take_params.dart';
import 'package:uskudar_mobile/domain/repositories/gift_checks_repository.dart';

final class CouponTakeUsecase implements BaseUsecase<String, CouponTakeParams> {
  CouponTakeUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, String>> call(CouponTakeParams params) async {
    return repository.couponsTake(params);
  }
}
