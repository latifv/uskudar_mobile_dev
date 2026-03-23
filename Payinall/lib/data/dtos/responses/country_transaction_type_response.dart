import 'package:json_annotation/json_annotation.dart';

part 'country_transaction_type_response.g.dart';

@JsonSerializable(createToJson: false)
final class CountryTransactionTypeResponse {
  const CountryTransactionTypeResponse({
    this.countryCode,
    this.countryName,
    this.marketingExpense,
    this.reporterExpense,
    this.mandBICCode,
    this.requestedAccountMatrix,
    this.transactionTypes,
  });

  factory CountryTransactionTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$CountryTransactionTypeResponseFromJson(json);

  final String? countryCode;
  final String? countryName;
  final double? marketingExpense;
  final double? reporterExpense;
  final MandBICCodeResponse? mandBICCode;
  final List<AccountMatrixResponse>? requestedAccountMatrix;
  final List<TransactionTypeResponse>? transactionTypes;
}

@JsonSerializable(createToJson: false)
final class MandBICCodeResponse {
  const MandBICCodeResponse({this.mandatoryBICCode});

  factory MandBICCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$MandBICCodeResponseFromJson(json);

  final bool? mandatoryBICCode;
}

@JsonSerializable(createToJson: false)
final class AccountMatrixResponse {
  const AccountMatrixResponse({
    this.accountMatrixCode,
    this.accountMatrix,
  });

  factory AccountMatrixResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountMatrixResponseFromJson(json);

  final String? accountMatrixCode;
  final String? accountMatrix;
}

@JsonSerializable(createToJson: false)
final class TransactionTypeResponse {
  const TransactionTypeResponse({
    this.transactionTypeCode,
    this.transactionTypeName,
    this.corporationTransactionTypes,
  });

  factory TransactionTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionTypeResponseFromJson(json);

  final String? transactionTypeCode;
  final String? transactionTypeName;
  final List<CorporationTransactionTypeResponse>? corporationTransactionTypes;
}

@JsonSerializable(createToJson: false)
final class CorporationTransactionTypeResponse {
  const CorporationTransactionTypeResponse({
    this.corporation,
    this.isRegional,
    this.currencies,
  });

  factory CorporationTransactionTypeResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CorporationTransactionTypeResponseFromJson(json);

  final CorporationResponse? corporation;
  final bool? isRegional;
  final List<CurrencyLimitResponse>? currencies;
}

@JsonSerializable(createToJson: false)
final class CorporationResponse {
  const CorporationResponse({
    this.corporationCode,
    this.corporationName,
    this.phoneNumber,
    this.b2B,
    this.b2C,
    this.c2B,
  });

  factory CorporationResponse.fromJson(Map<String, dynamic> json) =>
      _$CorporationResponseFromJson(json);

  final String? corporationCode;
  final String? corporationName;
  final String? phoneNumber;
  final bool? b2B;
  final bool? b2C;
  final bool? c2B;
}

@JsonSerializable(createToJson: false)
final class CurrencyLimitResponse {
  const CurrencyLimitResponse({
    this.useIntegrationChannel,
    this.limit,
    this.currency,
  });

  factory CurrencyLimitResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrencyLimitResponseFromJson(json);

  final bool? useIntegrationChannel;
  final double? limit;
  final CurrencyResponse? currency;
}

@JsonSerializable(createToJson: false)
final class CurrencyResponse {
  const CurrencyResponse({this.currencyCode});

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrencyResponseFromJson(json);

  final String? currencyCode;
}
