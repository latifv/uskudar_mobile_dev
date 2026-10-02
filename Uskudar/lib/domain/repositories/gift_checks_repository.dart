import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/customer_coupon.dart';
import 'package:payinall/domain/entities/gift_check_brand.dart';
import 'package:payinall/domain/entities/gift_check_brand_detail.dart';
import 'package:payinall/domain/entities/gift_check_category.dart';
import 'package:payinall/domain/entities/gift_check_coupon.dart';
import 'package:payinall/domain/params/coupon_take_params.dart';

abstract interface class GiftChecksRepository {
  Future<Either<Failure, List<GiftCheckCategory>>> getCategories();
  Future<Either<Failure, List<GiftCheckBrand>>> getBrands(String categoryId);
  Future<Either<Failure, GiftCheckBrandDetail>> getBrandDetail(String brandId);
  Future<Either<Failure, List<GiftCheckCoupon>>> getCoupons(String brandId);
  Future<Either<Failure, String>> couponsTake(CouponTakeParams params);
  Future<Either<Failure, List<CustomerCoupon>>> getCustomerCoupons();
}
