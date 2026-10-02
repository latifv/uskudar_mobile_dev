class TransactionType {
  const TransactionType({
    required this.transactionTypeCode,
    required this.transactionTypeName,
    required this.corporationTransactionTypes,
  });

  final String transactionTypeCode;
  final String transactionTypeName;
  final List<CorporationTransactionType> corporationTransactionTypes;
}

class CorporationTransactionType {
  const CorporationTransactionType({
    required this.corporation,
    required this.isRegional,
    required this.currencies,
  });

  final Corporation corporation;
  final bool isRegional;
  final List<CurrencyLimit> currencies;
}

class Corporation {
  const Corporation({
    required this.corporationCode,
    required this.corporationName,
    required this.b2B,
    required this.b2C,
    required this.c2B,
    this.phoneNumber,
  });

  final String corporationCode;
  final String corporationName;
  final String? phoneNumber;
  final bool b2B;
  final bool b2C;
  final bool c2B;
}

class CurrencyLimit {
  const CurrencyLimit({
    required this.useIntegrationChannel,
    required this.limit,
    required this.currencyCode,
  });

  final bool useIntegrationChannel;
  final double limit;
  final String currencyCode;
}
