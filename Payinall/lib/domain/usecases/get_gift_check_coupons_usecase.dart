import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/gift_check_coupon.dart';
import 'package:payinall/domain/repositories/gift_checks_repository.dart';

final class GetGiftCheckCouponsUsecase
    implements BaseUsecase<List<GiftCheckCoupon>, String> {
  GetGiftCheckCouponsUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, List<GiftCheckCoupon>>> call(String brandId) async {
    return repository.getCoupons(brandId);
  }
}
