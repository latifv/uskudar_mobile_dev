import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/international_money_transfer_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/cash_payout_send_transfer_request.dart';
import 'package:payinall/data/dtos/requests/get_bic_bank_list_request.dart';
import 'package:payinall/data/dtos/requests/get_offices_request.dart';
import 'package:payinall/data/dtos/requests/get_required_attributes_request.dart';
import 'package:payinall/data/models/bic_bank_model.dart';
import 'package:payinall/data/models/card_bin_model.dart';
import 'package:payinall/data/models/corporation_attribute_model.dart';
import 'package:payinall/data/models/country_model.dart';
import 'package:payinall/data/models/country_transaction_type_model.dart';
import 'package:payinall/data/models/international_transfer_result_model.dart';
import 'package:payinall/data/models/office_model.dart';
import 'package:payinall/data/models/wallet_operator_model.dart';
import 'package:payinall/domain/entities/bic_bank.dart';
import 'package:payinall/domain/entities/card_bin.dart';
import 'package:payinall/domain/entities/corporation_attribute.dart';
import 'package:payinall/domain/entities/country.dart';
import 'package:payinall/domain/entities/country_transaction_type.dart';
import 'package:payinall/domain/entities/international_transfer_result.dart';
import 'package:payinall/domain/entities/office.dart';
import 'package:payinall/domain/entities/wallet_operator.dart';
import 'package:payinall/domain/params/cash_payout_send_transfer_params.dart';
import 'package:payinall/domain/params/get_bic_bank_list_params.dart';
import 'package:payinall/domain/params/get_offices_params.dart';
import 'package:payinall/domain/params/get_required_attributes_params.dart';
import 'package:payinall/domain/repositories/international_money_transfer_repository.dart';

final class InternationalMoneyTransferRepositoryImpl
    implements InternationalMoneyTransferRepository {
  InternationalMoneyTransferRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final InternationalMoneyTransferRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<Country>>> getCountryList() async {
    return _dataSourceHandler.handle<List<Country>, List<CountryModel>>(
      remoteFunction: () async {
        return remoteDataSource.getCountryList();
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, CountryTransactionType>> getCountryTransactionType(
    String countryCode,
  ) async {
    return _dataSourceHandler
        .handle<CountryTransactionType, CountryTransactionTypeModel>(
          remoteFunction: () async {
            return remoteDataSource.getCountryTransactionType(countryCode);
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, List<CorporationAttribute>>> getRequiredAttributes(
    GetRequiredAttributesParams params,
  ) async {
    return _dataSourceHandler
        .handle<List<CorporationAttribute>, List<CorporationAttributeModel>>(
          remoteFunction: () async {
            final request = GetRequiredAttributesRequest.fromParams(params);
            final result = await remoteDataSource.getRequiredAttributes(
              request,
            );
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, InternationalTransferResult>> cashPayoutSendTransfer(
    CashPayoutSendTransferParams params,
  ) async {
    return _dataSourceHandler
        .handle<InternationalTransferResult, InternationalTransferResultModel>(
          remoteFunction: () async {
            final request = CashPayoutSendTransferRequest.fromParams(params);
            final result = await remoteDataSource.cashPayoutSendTransfer(
              request,
            );
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, String>> confirmTransfer(String transactionId) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.confirmTransfer(transactionId);
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, List<BicBank>>> getBicBankList(
    GetBicBankListParams params,
  ) async {
    return _dataSourceHandler.handle<List<BicBank>, List<BicBankModel>>(
      remoteFunction: () async {
        final request = GetBicBankListRequest.fromParams(params);
        return remoteDataSource.getBicBankList(request);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<Office>>> getOffices(
    GetOfficesParams params,
  ) async {
    return _dataSourceHandler.handle<List<Office>, List<OfficeModel>>(
      remoteFunction: () async {
        final request = GetOfficesRequest.fromParams(params);
        return remoteDataSource.getOffices(request);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<CardBin>>> getCardBinCode(
    String countryCode,
  ) async {
    return _dataSourceHandler.handle<List<CardBin>, List<CardBinModel>>(
      remoteFunction: () async {
        return remoteDataSource.getCardBinCode(countryCode);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<WalletOperator>>> getWalletOperator(
    String countryCode,
  ) async {
    return _dataSourceHandler
        .handle<List<WalletOperator>, List<WalletOperatorModel>>(
          remoteFunction: () async {
            return remoteDataSource.getWalletOperator(countryCode);
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, String>> getTransferInfo(
    String referenceNumber,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.getTransferInfo(referenceNumber);
        return result;
      },
      onlyMessage: true,
    );
  }
}
