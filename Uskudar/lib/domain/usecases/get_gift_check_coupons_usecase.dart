import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_coupon.dart';
import 'package:uskudar_mobile/domain/repositories/gift_checks_repository.dart';

final class GetGiftCheckCouponsUsecase
    implements BaseUsecase<List<GiftCheckCoupon>, String> {
  GetGiftCheckCouponsUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, List<GiftCheckCoupon>>> call(String brandId) async {
    return repository.getCoupons(brandId);
  }
}
