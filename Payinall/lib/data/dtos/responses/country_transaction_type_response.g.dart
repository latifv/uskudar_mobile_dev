// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_transaction_type_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryTransactionTypeResponse _$CountryTransactionTypeResponseFromJson(
  Map<String, dynamic> json,
) => CountryTransactionTypeResponse(
  countryCode: json['countryCode'] as String?,
  countryName: json['countryName'] as String?,
  marketingExpense: (json['marketingExpense'] as num?)?.toDouble(),
  reporterExpense: (json['reporterExpense'] as num?)?.toDouble(),
  mandBICCode: json['mandBICCode'] == null
      ? null
      : MandBICCodeResponse.fromJson(
          json['mandBICCode'] as Map<String, dynamic>,
        ),
  requestedAccountMatrix: (json['requestedAccountMatrix'] as List<dynamic>?)
      ?.map((e) => AccountMatrixResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  transactionTypes: (json['transactionTypes'] as List<dynamic>?)
      ?.map((e) => TransactionTypeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

MandBICCodeResponse _$MandBICCodeResponseFromJson(Map<String, dynamic> json) =>
    MandBICCodeResponse(mandatoryBICCode: json['mandatoryBICCode'] as bool?);

AccountMatrixResponse _$AccountMatrixResponseFromJson(
  Map<String, dynamic> json,
) => AccountMatrixResponse(
  accountMatrixCode: json['accountMatrixCode'] as String?,
  accountMatrix: json['accountMatrix'] as String?,
);

TransactionTypeResponse _$TransactionTypeResponseFromJson(
  Map<String, dynamic> json,
) => TransactionTypeResponse(
  transactionTypeCode: json['transactionTypeCode'] as String?,
  transactionTypeName: json['transactionTypeName'] as String?,
  corporationTransactionTypes:
      (json['corporationTransactionTypes'] as List<dynamic>?)
          ?.map(
            (e) => CorporationTransactionTypeResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
);

CorporationTransactionTypeResponse _$CorporationTransactionTypeResponseFromJson(
  Map<String, dynamic> json,
) => CorporationTransactionTypeResponse(
  corporation: json['corporation'] == null
      ? null
      : CorporationResponse.fromJson(
          json['corporation'] as Map<String, dynamic>,
        ),
  isRegional: json['isRegional'] as bool?,
  currencies: (json['currencies'] as List<dynamic>?)
      ?.map((e) => CurrencyLimitResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

CorporationResponse _$CorporationResponseFromJson(Map<String, dynamic> json) =>
    CorporationResponse(
      corporationCode: json['corporationCode'] as String?,
      corporationName: json['corporationName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      b2B: json['b2B'] as bool?,
      b2C: json['b2C'] as bool?,
      c2B: json['c2B'] as bool?,
    );

CurrencyLimitResponse _$CurrencyLimitResponseFromJson(
  Map<String, dynamic> json,
) => CurrencyLimitResponse(
  useIntegrationChannel: json['useIntegrationChannel'] as bool?,
  limit: (json['limit'] as num?)?.toDouble(),
  currency: json['currency'] == null
      ? null
      : CurrencyResponse.fromJson(json['currency'] as Map<String, dynamic>),
);

CurrencyResponse _$CurrencyResponseFromJson(Map<String, dynamic> json) =>
    CurrencyResponse(currencyCode: json['currencyCode'] as String?);
