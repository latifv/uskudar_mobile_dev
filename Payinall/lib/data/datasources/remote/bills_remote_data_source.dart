import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/bill_inquiry_request.dart';
import 'package:payinall/data/dtos/requests/bill_payment_request.dart';
import 'package:payinall/data/dtos/requests/bill_product_query_definition_request.dart';
import 'package:payinall/data/dtos/responses/bill_inquiry_response.dart';
import 'package:payinall/data/dtos/responses/bill_product_query_definition_response.dart';
import 'package:payinall/data/dtos/responses/bill_product_response.dart';
import 'package:payinall/data/dtos/responses/bill_product_type_response.dart';
import 'package:payinall/data/models/bill_inquiry_model.dart';
import 'package:payinall/data/models/bill_product_model.dart';
import 'package:payinall/data/models/bill_product_query_definition_model.dart';
import 'package:payinall/data/models/bill_product_type_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class BillsRemoteDataSource {
  Future<NetworkResponse<List<BillProductTypeModel>>> getProductTypes();
  Future<NetworkResponse<List<BillProductModel>>> getProducts(
    String productTypeId,
  );
  Future<NetworkResponse<List<BillProductModel>>> getCacheProductList();
  Future<NetworkResponse<List<BillProductQueryDefinitionModel>>>
  productQueryDefinition(String productId);
  Future<NetworkResponse<List<BillInquiryModel>>> getBillInquiry(
    BillInquiryRequest request,
  );
  Future<NetworkResponse<void>> billPayment(BillPaymentRequest request);
}

final class BillsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements BillsRemoteDataSource {
  BillsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<BillProductTypeModel>>> getProductTypes() async {
    final responseJson = await get(endpoint: Endpoints.getProductTypes);

    final response = NetworkResponse.fromJson<List<BillProductTypeResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => BillProductTypeResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    final result = response.map(
      (responseList) =>
          responseList.map(BillProductTypeModel.fromResponse).toList(),
    );

    return result;
  }

  @override
  Future<NetworkResponse<List<BillProductModel>>> getProducts(
    String productTypeId,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getProduct(productTypeId),
    );

    final response = NetworkResponse.fromJson<List<BillProductResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    BillProductResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    final result = response.map(
      (responseList) =>
          responseList.map(BillProductModel.fromResponse).toList(),
    );

    return result;
  }

  @override
  Future<NetworkResponse<List<BillProductModel>>> getCacheProductList() async {
    final responseJson = await get(endpoint: Endpoints.getCacheProductList);

    final response = NetworkResponse.fromJson<List<BillProductResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    BillProductResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    final result = response.map(
      (responseList) =>
          responseList.map(BillProductModel.fromResponse).toList(),
    );

    return result;
  }

  @override
  Future<NetworkResponse<List<BillProductQueryDefinitionModel>>>
  productQueryDefinition(String productId) async {
    final request = BillProductQueryDefinitionRequest(productId: productId);
    final responseJson = await post(
      endpoint: Endpoints.productQueryDefinition(productId),
      data: request.toJson(),
    );

    final response =
        NetworkResponse.fromJson<List<BillProductQueryDefinitionResponse>>(
          responseJson as Map<String, dynamic>,
          fromJsonT: (json) {
            if (json is List) {
              return json
                  .map(
                    (item) => BillProductQueryDefinitionResponse.fromJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList();
            }
            throw const MappingException();
          },
        );

    final result = response.map(
      (responseList) => responseList
          .map(BillProductQueryDefinitionModel.fromResponse)
          .toList(),
    );

    return result;
  }

  @override
  Future<NetworkResponse<List<BillInquiryModel>>> getBillInquiry(
    BillInquiryRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getBillInquiry,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<List<BillInquiryResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    BillInquiryResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    final result = response.map(
      (responseList) =>
          responseList.map(BillInquiryModel.fromResponse).toList(),
    );

    return result;
  }

  @override
  Future<NetworkResponse<void>> billPayment(BillPaymentRequest request) async {
    final responseJson = await post(
      endpoint: Endpoints.billPayment,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
