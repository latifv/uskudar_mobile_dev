import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/cash_payout_send_transfer_request.dart';
import 'package:payinall/data/dtos/requests/get_bic_bank_list_request.dart';
import 'package:payinall/data/dtos/requests/get_offices_request.dart';
import 'package:payinall/data/dtos/requests/get_required_attributes_request.dart';
import 'package:payinall/data/dtos/responses/bic_bank_response.dart';
import 'package:payinall/data/dtos/responses/card_bin_response.dart';
import 'package:payinall/data/dtos/responses/corporation_attribute_response.dart';
import 'package:payinall/data/dtos/responses/country_response.dart';
import 'package:payinall/data/dtos/responses/country_transaction_type_response.dart';
import 'package:payinall/data/dtos/responses/international_transfer_result_response.dart';
import 'package:payinall/data/dtos/responses/office_response.dart';
import 'package:payinall/data/dtos/responses/wallet_operator_response.dart';
import 'package:payinall/data/models/bic_bank_model.dart';
import 'package:payinall/data/models/card_bin_model.dart';
import 'package:payinall/data/models/corporation_attribute_model.dart';
import 'package:payinall/data/models/country_model.dart';
import 'package:payinall/data/models/country_transaction_type_model.dart';
import 'package:payinall/data/models/international_transfer_result_model.dart';
import 'package:payinall/data/models/office_model.dart';
import 'package:payinall/data/models/wallet_operator_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class InternationalMoneyTransferRemoteDataSource {
  Future<NetworkResponse<List<CountryModel>>> getCountryList();

  Future<NetworkResponse<CountryTransactionTypeModel>>
  getCountryTransactionType(String countryCode);

  Future<NetworkResponse<List<CorporationAttributeModel>>>
  getRequiredAttributes(
    GetRequiredAttributesRequest request,
  );

  Future<NetworkResponse<InternationalTransferResultModel>>
  cashPayoutSendTransfer(
    CashPayoutSendTransferRequest request,
  );

  Future<NetworkResponse<void>> confirmTransfer(String transactionId);

  Future<NetworkResponse<List<BicBankModel>>> getBicBankList(
    GetBicBankListRequest request,
  );

  Future<NetworkResponse<List<OfficeModel>>> getOffices(
    GetOfficesRequest request,
  );

  Future<NetworkResponse<List<CardBinModel>>> getCardBinCode(
    String countryCode,
  );

  Future<NetworkResponse<List<WalletOperatorModel>>> getWalletOperator(
    String countryCode,
  );

  Future<NetworkResponse<void>> getTransferInfo(String referenceNumber);
}

final class InternationalMoneyTransferRemoteDataSourceImpl
    extends BaseRemoteDataSource
    implements InternationalMoneyTransferRemoteDataSource {
  InternationalMoneyTransferRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<CountryModel>>> getCountryList() async {
    final responseJson = await get(endpoint: Endpoints.getCountryList);

    final response = NetworkResponse.fromJson<List<CountryResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (e) => CountryResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    return response.map(
      (list) => list.map(CountryModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<CountryTransactionTypeModel>>
  getCountryTransactionType(String countryCode) async {
    final responseJson = await post(
      endpoint: Endpoints.getCountryTransactionType(countryCode),
    );

    final response = NetworkResponse.fromJson<CountryTransactionTypeResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return CountryTransactionTypeResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(CountryTransactionTypeModel.fromResponse);
  }

  @override
  Future<NetworkResponse<List<CorporationAttributeModel>>>
  getRequiredAttributes(
    GetRequiredAttributesRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getRequiredAttributes,
      data: request.toJson(),
    );

    final response =
        NetworkResponse.fromJson<List<CorporationAttributeResponse>>(
          responseJson as Map<String, dynamic>,
          fromJsonT: (json) {
            if (json is List) {
              return json
                  .map(
                    (e) => CorporationAttributeResponse.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
                  .toList();
            }
            throw const MappingException();
          },
        );

    return response.map(
      (list) => list.map(CorporationAttributeModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<InternationalTransferResultModel>>
  cashPayoutSendTransfer(
    CashPayoutSendTransferRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.cashPayoutSendTransfer,
      data: request.toJson(),
    );

    final response =
        NetworkResponse.fromJson<InternationalTransferResultResponse>(
          responseJson as Map<String, dynamic>,
          fromJsonT: (json) {
            if (json is Map<String, dynamic>) {
              return InternationalTransferResultResponse.fromJson(json);
            }
            throw const MappingException();
          },
        );

    return response.map(InternationalTransferResultModel.fromResponse);
  }

  @override
  Future<NetworkResponse<void>> confirmTransfer(String transactionId) async {
    final responseJson = await post(
      endpoint: Endpoints.confirmInternationalTransfer(transactionId),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<List<BicBankModel>>> getBicBankList(
    GetBicBankListRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getBicBankList,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<List<BicBankResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (e) => BicBankResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    return response.map(
      (list) => list.map(BicBankModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<OfficeModel>>> getOffices(
    GetOfficesRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getOffices,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<List<OfficeResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (e) => OfficeResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    return response.map(
      (list) => list.map(OfficeModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<CardBinModel>>> getCardBinCode(
    String countryCode,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getCardBinCode(countryCode),
    );

    final response = NetworkResponse.fromJson<List<CardBinResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (e) => CardBinResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    return response.map(
      (list) => list.map(CardBinModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<WalletOperatorModel>>> getWalletOperator(
    String countryCode,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getWalletOperator(countryCode),
    );

    final response = NetworkResponse.fromJson<List<WalletOperatorResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (e) =>
                    WalletOperatorResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    return response.map(
      (list) => list.map(WalletOperatorModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<void>> getTransferInfo(
    String referenceNumber,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getTransferInfo(referenceNumber),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
