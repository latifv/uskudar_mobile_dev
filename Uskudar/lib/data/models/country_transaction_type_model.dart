import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/country_transaction_type_response.dart';
import 'package:payinall/domain/entities/country_transaction_type.dart';
import 'package:payinall/domain/entities/transaction_type.dart';

final class CountryTransactionTypeModel extends CountryTransactionType {
  const CountryTransactionTypeModel({
    required super.countryCode,
    required super.countryName,
    required super.marketingExpense,
    required super.reporterExpense,
    required super.mandatoryBICCode,
    required super.requestedAccountMatrix,
    required super.transactionTypes,
  });

  factory CountryTransactionTypeModel.fromResponse(
    CountryTransactionTypeResponse response,
  ) {
    if (response.countryCode == null ||
        response.countryName == null ||
        response.transactionTypes == null) {
      throw const MappingException();
    }

    return CountryTransactionTypeModel(
      countryCode: response.countryCode!,
      countryName: response.countryName!,
      marketingExpense: response.marketingExpense ?? 0,
      reporterExpense: response.reporterExpense ?? 0,
      mandatoryBICCode: response.mandBICCode?.mandatoryBICCode ?? false,
      requestedAccountMatrix:
          response.requestedAccountMatrix
              ?.map(AccountMatrixModel.fromResponse)
              .toList() ??
          [],
      transactionTypes: response.transactionTypes!
          .map(TransactionTypeModel.fromResponse)
          .toList(),
    );
  }
}

final class AccountMatrixModel extends AccountMatrix {
  const AccountMatrixModel({
    required super.accountMatrixCode,
    required super.accountMatrix,
  });

  factory AccountMatrixModel.fromResponse(AccountMatrixResponse response) {
    return AccountMatrixModel(
      accountMatrixCode: response.accountMatrixCode ?? '',
      accountMatrix: response.accountMatrix ?? '',
    );
  }
}

final class TransactionTypeModel extends TransactionType {
  const TransactionTypeModel({
    required super.transactionTypeCode,
    required super.transactionTypeName,
    required super.corporationTransactionTypes,
  });

  factory TransactionTypeModel.fromResponse(TransactionTypeResponse response) {
    if (response.transactionTypeCode == null ||
        response.transactionTypeName == null) {
      throw const MappingException();
    }

    return TransactionTypeModel(
      transactionTypeCode: response.transactionTypeCode!,
      transactionTypeName: response.transactionTypeName!,
      corporationTransactionTypes:
          response.corporationTransactionTypes
              ?.map(CorporationTransactionTypeModel.fromResponse)
              .toList() ??
          [],
    );
  }
}

final class CorporationTransactionTypeModel extends CorporationTransactionType {
  const CorporationTransactionTypeModel({
    required super.corporation,
    required super.isRegional,
    required super.currencies,
  });

  factory CorporationTransactionTypeModel.fromResponse(
    CorporationTransactionTypeResponse response,
  ) {
    if (response.corporation == null) {
      throw const MappingException();
    }

    return CorporationTransactionTypeModel(
      corporation: CorporationModel.fromResponse(response.corporation!),
      isRegional: response.isRegional ?? false,
      currencies:
          response.currencies?.map(CurrencyLimitModel.fromResponse).toList() ??
          [],
    );
  }
}

final class CorporationModel extends Corporation {
  const CorporationModel({
    required super.corporationCode,
    required super.corporationName,
    required super.b2B,
    required super.b2C,
    required super.c2B,
    super.phoneNumber,
  });

  factory CorporationModel.fromResponse(CorporationResponse response) {
    if (response.corporationCode == null || response.corporationName == null) {
      throw const MappingException();
    }

    return CorporationModel(
      corporationCode: response.corporationCode!,
      corporationName: response.corporationName!,
      phoneNumber: response.phoneNumber,
      b2B: response.b2B ?? false,
      b2C: response.b2C ?? false,
      c2B: response.c2B ?? false,
    );
  }
}

final class CurrencyLimitModel extends CurrencyLimit {
  const CurrencyLimitModel({
    required super.useIntegrationChannel,
    required super.limit,
    required super.currencyCode,
  });

  factory CurrencyLimitModel.fromResponse(CurrencyLimitResponse response) {
    return CurrencyLimitModel(
      useIntegrationChannel: response.useIntegrationChannel ?? false,
      limit: response.limit ?? 0,
      currencyCode: response.currency?.currencyCode ?? '',
    );
  }
}
