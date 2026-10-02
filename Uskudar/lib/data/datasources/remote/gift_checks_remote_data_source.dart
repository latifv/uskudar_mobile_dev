import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/coupon_take_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/customer_coupon_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/gift_check_brand_detail_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/gift_check_brand_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/gift_check_category_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/gift_check_coupon_response.dart';
import 'package:uskudar_mobile/data/models/customer_coupon_model.dart';
import 'package:uskudar_mobile/data/models/gift_check_brand_detail_model.dart';
import 'package:uskudar_mobile/data/models/gift_check_brand_model.dart';
import 'package:uskudar_mobile/data/models/gift_check_category_model.dart';
import 'package:uskudar_mobile/data/models/gift_check_coupon_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class GiftChecksRemoteDataSource {
  Future<NetworkResponse<List<GiftCheckCategoryModel>>> getCategories();
  Future<NetworkResponse<List<GiftCheckBrandModel>>> getBrands(
    String categoryId,
  );
  Future<NetworkResponse<GiftCheckBrandDetailModel>> getBrandDetail(
    String brandId,
  );
  Future<NetworkResponse<List<GiftCheckCouponModel>>> getCoupons(
    String brandId,
  );
  Future<NetworkResponse<bool>> couponsTake(CouponTakeRequest request);
  Future<NetworkResponse<List<CustomerCouponModel>>> getCustomerCoupons();
}

final class GiftChecksRemoteDataSourceImpl extends BaseRemoteDataSource
    implements GiftChecksRemoteDataSource {
  GiftChecksRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<GiftCheckCategoryModel>>> getCategories() async {
    final responseJson = await get(
      endpoint: Endpoints.getGiftCheckCategories,
    );
    final response = NetworkResponse.fromJson<List<GiftCheckCategoryResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => GiftCheckCategoryResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        if (json is Map<String, dynamic>) {
          return [GiftCheckCategoryResponse.fromJson(json)];
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(GiftCheckCategoryModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<GiftCheckBrandModel>>> getBrands(
    String categoryId,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getGiftCheckBrands(categoryId),
    );
    final response = NetworkResponse.fromJson<List<GiftCheckBrandResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => GiftCheckBrandResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        if (json is Map<String, dynamic>) {
          return [GiftCheckBrandResponse.fromJson(json)];
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(GiftCheckBrandModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<GiftCheckBrandDetailModel>> getBrandDetail(
    String brandId,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getGiftCheckBrandDetail(brandId),
    );
    final response =
        NetworkResponse.fromJson<GiftCheckBrandDetailResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return GiftCheckBrandDetailResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );
    return response.map(GiftCheckBrandDetailModel.fromResponse);
  }

  @override
  Future<NetworkResponse<List<GiftCheckCouponModel>>> getCoupons(
    String brandId,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getGiftCheckCoupons(brandId),
    );
    final response = NetworkResponse.fromJson<List<GiftCheckCouponResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => GiftCheckCouponResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        if (json is Map<String, dynamic>) {
          return [GiftCheckCouponResponse.fromJson(json)];
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(GiftCheckCouponModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<bool>> couponsTake(CouponTakeRequest request) async {
    final responseJson = await post(
      endpoint: Endpoints.couponsTake,
      data: request.toJson(),
    );
    return NetworkResponse.fromJson<bool>(
      responseJson as Map<String, dynamic>,
    );
  }

  @override
  Future<NetworkResponse<List<CustomerCouponModel>>>
      getCustomerCoupons() async {
    final responseJson = await get(
      endpoint: Endpoints.getCustomerCoupons,
    );
    final response = NetworkResponse.fromJson<List<CustomerCouponResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => CustomerCouponResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        if (json is Map<String, dynamic>) {
          return [CustomerCouponResponse.fromJson(json)];
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(CustomerCouponModel.fromResponse).toList(),
    );
  }
}
