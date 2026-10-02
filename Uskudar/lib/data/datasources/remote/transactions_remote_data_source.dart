import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/transactions_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/customer_process_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/transaction_receipt_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/transaction_response.dart';
import 'package:uskudar_mobile/data/models/customer_process_model.dart';
import 'package:uskudar_mobile/data/models/transaction_model.dart';
import 'package:uskudar_mobile/data/models/transaction_receipt_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class TransactionsRemoteDataSource {
  Future<NetworkResponse<List<TransactionModel>>> getLastTransactions(
    int dataSize,
  );
  Future<NetworkResponse<List<TransactionModel>>> getMerchantLastTransactions(
    int dataSize,
  );
  Future<NetworkResponse<List<TransactionModel>>> getTransactions(
    TransactionsRequest request,
  );
  Future<NetworkResponse<List<TransactionModel>>> getMerchantUserTransactions(
    TransactionsRequest request,
  );
  Future<NetworkResponse<TransactionReceiptModel>> getTransactionReceipt(
    String id,
  );
  Future<NetworkResponse<List<CustomerProcessModel>>> getCustomerProcessList();
  Future<NetworkResponse<List<CustomerProcessModel>>> getMerchantProcessList();
}

final class TransactionsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements TransactionsRemoteDataSource {
  TransactionsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<TransactionModel>>> getLastTransactions(
    int dataSize,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getLastTransactions(dataSize),
    );
    final response = NetworkResponse.fromJson<List<TransactionResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    TransactionResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(TransactionModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<TransactionModel>>> getMerchantLastTransactions(
    int dataSize,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getMerchantLastTransactions(dataSize),
    );
    final response = NetworkResponse.fromJson<List<TransactionResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    TransactionResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(TransactionModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<TransactionModel>>> getTransactions(
    TransactionsRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getTransactions,
      data: request.toJson(),
    );
    final response = NetworkResponse.fromJson<List<TransactionResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .where((item) => item != null)
              .map(
                (item) =>
                    TransactionResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(TransactionModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<TransactionModel>>> getMerchantUserTransactions(
    TransactionsRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getMerchantUserTransactions,
      data: request.toJson(),
    );
    final response = NetworkResponse.fromJson<List<TransactionResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    TransactionResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(TransactionModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<TransactionReceiptModel>> getTransactionReceipt(
    String id,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getTransactionReceipt(id),
    );

    final response = NetworkResponse.fromJson<TransactionReceiptResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return TransactionReceiptResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(TransactionReceiptModel.fromResponse);
  }

  @override
  Future<NetworkResponse<List<CustomerProcessModel>>>
  getCustomerProcessList() async {
    final responseJson = await get(endpoint: Endpoints.customerProcessList);
    final response = NetworkResponse.fromJson<List<CustomerProcessResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => CustomerProcessResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(CustomerProcessModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<CustomerProcessModel>>>
  getMerchantProcessList() async {
    final responseJson = await get(endpoint: Endpoints.getMerchantProcessList);
    final response = NetworkResponse.fromJson<List<CustomerProcessResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => CustomerProcessResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(CustomerProcessModel.fromResponse).toList(),
    );
  }
}
