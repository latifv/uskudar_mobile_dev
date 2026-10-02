import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/gift_checks_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/coupon_take_request.dart';
import 'package:uskudar_mobile/data/models/customer_coupon_model.dart';
import 'package:uskudar_mobile/data/models/gift_check_brand_detail_model.dart';
import 'package:uskudar_mobile/data/models/gift_check_brand_model.dart';
import 'package:uskudar_mobile/data/models/gift_check_category_model.dart';
import 'package:uskudar_mobile/data/models/gift_check_coupon_model.dart';
import 'package:uskudar_mobile/domain/entities/customer_coupon.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_brand.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_brand_detail.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_category.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_coupon.dart';
import 'package:uskudar_mobile/domain/params/coupon_take_params.dart';
import 'package:uskudar_mobile/domain/repositories/gift_checks_repository.dart';

final class GiftChecksRepositoryImpl implements GiftChecksRepository {
  GiftChecksRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final GiftChecksRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<GiftCheckCategory>>> getCategories() async {
    return _dataSourceHandler
        .handle<List<GiftCheckCategory>, List<GiftCheckCategoryModel>>(
      remoteFunction: () async {
        return remoteDataSource.getCategories();
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<GiftCheckBrand>>> getBrands(
    String categoryId,
  ) async {
    return _dataSourceHandler
        .handle<List<GiftCheckBrand>, List<GiftCheckBrandModel>>(
      remoteFunction: () async {
        return remoteDataSource.getBrands(categoryId);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, GiftCheckBrandDetail>> getBrandDetail(
    String brandId,
  ) async {
    return _dataSourceHandler
        .handle<GiftCheckBrandDetail, GiftCheckBrandDetailModel>(
      remoteFunction: () async {
        return remoteDataSource.getBrandDetail(brandId);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<GiftCheckCoupon>>> getCoupons(
    String brandId,
  ) async {
    return _dataSourceHandler
        .handle<List<GiftCheckCoupon>, List<GiftCheckCouponModel>>(
      remoteFunction: () async {
        return remoteDataSource.getCoupons(brandId);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, String>> couponsTake(CouponTakeParams params) async {
    return _dataSourceHandler.handle<String, bool>(
      remoteFunction: () async {
        final request = CouponTakeRequest.fromParams(params);
        return remoteDataSource.couponsTake(request);
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, List<CustomerCoupon>>> getCustomerCoupons() async {
    return _dataSourceHandler
        .handle<List<CustomerCoupon>, List<CustomerCouponModel>>(
      remoteFunction: () async {
        return remoteDataSource.getCustomerCoupons();
      },
      onlyData: true,
    );
  }
}
