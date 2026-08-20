enum PaycoreCardCreationProfile {
  troyVirtual,
  troyPhysical,
  masterVirtual,
  masterPhysical,
}

enum PaycoreCardBrand { visa, troy, mastercard, unknown }

extension PaycoreCardCreationProfileX on PaycoreCardCreationProfile {
  String get apiValue => switch (this) {
    PaycoreCardCreationProfile.troyVirtual => 'troy_virtual',
    PaycoreCardCreationProfile.troyPhysical => 'troy_physical',
    PaycoreCardCreationProfile.masterVirtual => 'master_virtual',
    PaycoreCardCreationProfile.masterPhysical => 'master_physical',
  };

  String get title => switch (this) {
    PaycoreCardCreationProfile.troyVirtual => 'Troy Sanal',
    PaycoreCardCreationProfile.troyPhysical => 'Troy Fiziki',
    PaycoreCardCreationProfile.masterVirtual => 'Master Sanal',
    PaycoreCardCreationProfile.masterPhysical => 'Master Fiziki',
  };

  String get description => switch (this) {
    PaycoreCardCreationProfile.troyVirtual =>
      'Dijital Troy kart datası oluşturur.',
    PaycoreCardCreationProfile.troyPhysical =>
      'Fiziksel Troy kart datası oluşturur.',
    PaycoreCardCreationProfile.masterVirtual =>
      'Dijital Master kart datası oluşturur.',
    PaycoreCardCreationProfile.masterPhysical =>
      'Fiziksel Master kart datası oluşturur.',
  };

  bool get isDigital => switch (this) {
    PaycoreCardCreationProfile.troyVirtual => true,
    PaycoreCardCreationProfile.troyPhysical => false,
    PaycoreCardCreationProfile.masterVirtual => true,
    PaycoreCardCreationProfile.masterPhysical => false,
  };
}

extension PaycoreCardBrandX on PaycoreCardBrand {
  String get label => switch (this) {
    PaycoreCardBrand.visa => 'Visa',
    PaycoreCardBrand.troy => 'Troy',
    PaycoreCardBrand.mastercard => 'Mastercard',
    PaycoreCardBrand.unknown => 'Bilinmeyen',
  };
}

final class PaycoreCardSummary {
  const PaycoreCardSummary({
    required this.id,
    required this.cardReference,
    required this.maskedCardNo,
    required this.productCode,
    required this.embossName,
    required this.expiryDate,
    required this.isDigitalCard,
    required this.isActive,
    required this.statusCode,
    required this.statusName,
    required this.cardTypeName,
    required this.isPrimary,
    required this.brand,
    this.brandHint,
    this.cvv,
    this.pin,
    this.fullCardNo,
  });

  factory PaycoreCardSummary.fromJson(Map<String, dynamic> json) {
    final brand = _resolvePaycoreCardBrand(json);
    return PaycoreCardSummary(
      id: _readInt(json, const ['id', 'Id']) ?? 0,
      cardReference:
          _readString(json, const ['cardReference', 'CardReference']) ?? '',
      maskedCardNo:
          _readString(json, const ['maskedCardNo', 'MaskedCardNo']) ?? '-',
      fullCardNo: _resolvePaycoreFullCardNo(json),
      cvv: _resolvePaycoreCvv(json),
      productCode: _readString(json, const ['productCode', 'ProductCode']),
      embossName: _readString(json, const ['embossName', 'EmbossName']),
      expiryDate: _readString(json, const ['expiryDate', 'ExpiryDate']),
      isDigitalCard:
          _readBool(json, const ['isDigitalCard', 'IsDigitalCard']) ?? false,
      isActive: _readBool(json, const ['isActive', 'IsActive']) ?? false,
      statusCode: _readString(json, const ['statusCode', 'StatusCode']) ?? '',
      statusName: _readString(json, const ['statusName', 'StatusName']) ?? '-',
      cardTypeName:
          _readString(json, const ['cardTypeName', 'CardTypeName']) ?? '-',
      isPrimary: _readBool(json, const ['isPrimary', 'IsPrimary']) ?? false,
      brand: brand,
      brandHint: _resolvePaycoreCardBrandHint(json),
      pin: _resolvePaycorePin(json),
    );
  }

  final int id;
  final String cardReference;
  final String maskedCardNo;
  final String? fullCardNo;
  final String? cvv;
  final String? pin;
  final String? productCode;
  final String? embossName;
  final String? expiryDate;
  final bool isDigitalCard;
  final bool isActive;
  final String statusCode;
  final String statusName;
  final String cardTypeName;
  final bool isPrimary;
  final PaycoreCardBrand brand;
  final String? brandHint;

  bool get isVirtualProduct {
    final normalizedProductCode = productCode?.trim().toUpperCase();
    return normalizedProductCode == 'TRYSNL' ||
        normalizedProductCode == 'MCSNL';
  }

  bool get isPhysicalProduct {
    final normalizedProductCode = productCode?.trim().toUpperCase();
    return normalizedProductCode == 'TRYFZKSL' ||
        normalizedProductCode == 'MCFZKSL' ||
        normalizedProductCode == 'MCPSB';
  }

  bool get resolvedIsDigitalCard {
    if (isVirtualProduct) {
      return true;
    }
    if (isPhysicalProduct) {
      return false;
    }
    return isDigitalCard;
  }

  String get cardModeLabel =>
      resolvedIsDigitalCard ? 'Sanal Kart' : 'Fiziki Kart';

  String get profileLabel {
    final normalizedProductCode = productCode?.trim().toUpperCase();

    if (normalizedProductCode == 'TRYSNL') {
      return 'Troy Sanal';
    }
    if (normalizedProductCode == 'TRYFZKSL') {
      return 'Troy Fiziki';
    }
    if (normalizedProductCode == 'MCSNL') {
      return 'Master Sanal';
    }
    if (normalizedProductCode == 'MCPSB' ||
        normalizedProductCode == 'MCFZKSL') {
      return 'Master Fiziki';
    }
    if (normalizedProductCode?.startsWith('MC') ?? false) {
      return resolvedIsDigitalCard ? 'Master Sanal' : 'Master Fiziki';
    }
    if (normalizedProductCode?.startsWith('TRY') ?? false) {
      return resolvedIsDigitalCard ? 'Troy Sanal' : 'Troy Fiziki';
    }

    return '${normalizedProductCode ?? '-'} • ${resolvedIsDigitalCard ? 'Sanal' : 'Fiziki'}';
  }
}

final class PaycoreVirtualCardSecurity {
  const PaycoreVirtualCardSecurity({this.cardNo, this.cvv});

  factory PaycoreVirtualCardSecurity.fromJson(Map<String, dynamic> json) {
    return PaycoreVirtualCardSecurity(
      cardNo: _resolvePaycoreFullCardNo(json),
      cvv: _resolvePaycoreCvv(json),
    );
  }

  final String? cardNo;
  final String? cvv;
}

String? _resolvePaycorePin(Map<String, dynamic> json) {
  const keys = <String>[
    'pin',
    'Pin',
    'cardPin',
    'CardPin',
    'pinCode',
    'PinCode',
    'virtualCardPin',
    'VirtualCardPin',
    'generatedPin',
    'GeneratedPin',
  ];

  for (final key in keys) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
  }

  return null;
}

final class PaycoreCreatePrepaidCardResult {
  const PaycoreCreatePrepaidCardResult({
    required this.maskedCardNo,
    required this.cardProfile,
    required this.productCode,
    required this.isDigitalCard,
    required this.expiryDate,
    required this.isNewCardCreated,
  });

  factory PaycoreCreatePrepaidCardResult.fromJson(Map<String, dynamic> json) {
    return PaycoreCreatePrepaidCardResult(
      maskedCardNo: json['maskedCardNo'] as String? ?? '-',
      cardProfile: json['cardProfile'] as String? ?? '',
      productCode: json['productCode'] as String? ?? '',
      isDigitalCard: json['isDigitalCard'] as bool? ?? false,
      expiryDate: json['expiryDate'] as String?,
      isNewCardCreated: json['isNewCardCreated'] as bool?,
    );
  }

  final String maskedCardNo;
  final String cardProfile;
  final String productCode;
  final bool isDigitalCard;
  final String? expiryDate;
  final bool? isNewCardCreated;
}

final class PaycoreCardAuthorizationStatus {
  const PaycoreCardAuthorizationStatus({
    required this.cardId,
    required this.maskedCardNo,
    required this.statusCode,
    required this.statusName,
    required this.isDomesticEcommerceEnabled,
    required this.isInternationalEcommerceEnabled,
  });

  factory PaycoreCardAuthorizationStatus.fromJson(Map<String, dynamic> json) {
    return PaycoreCardAuthorizationStatus(
      cardId: _readInt(json, const ['cardId', 'CardId']) ?? 0,
      maskedCardNo:
          _readString(json, const ['maskedCardNo', 'MaskedCardNo']) ?? '-',
      statusCode: _readString(json, const ['statusCode', 'StatusCode']) ?? '',
      statusName: _readString(json, const ['statusName', 'StatusName']) ?? '-',
      isDomesticEcommerceEnabled:
          _readBool(json, const [
            'isDomesticEcommerceEnabled',
            'IsDomesticEcommerceEnabled',
          ]) ??
          false,
      isInternationalEcommerceEnabled:
          _readBool(json, const [
            'isInternationalEcommerceEnabled',
            'IsInternationalEcommerceEnabled',
          ]) ??
          false,
    );
  }

  final int cardId;
  final String maskedCardNo;
  final String statusCode;
  final String statusName;
  final bool isDomesticEcommerceEnabled;
  final bool isInternationalEcommerceEnabled;
}

final class PaycoreCardTransactionsResponse {
  const PaycoreCardTransactionsResponse({
    required this.cardId,
    required this.totalDebit,
    required this.totalCredit,
    required this.transactions,
    required this.pageNumber,
    required this.pageSize,
    required this.hasMore,
  });

  factory PaycoreCardTransactionsResponse.fromJson(Map<String, dynamic> json) {
    final rawTransactions = _resolvePaycoreTransactionList(json);
    return PaycoreCardTransactionsResponse(
      cardId: _readInt(json, const ['cardId', 'CardId']) ?? 0,
      totalDebit: _readDecimal(json, const ['totalDebit', 'TotalDebit']) ?? 0,
      totalCredit:
          _readDecimal(json, const ['totalCredit', 'TotalCredit']) ?? 0,
      transactions: rawTransactions is List
          ? rawTransactions
                .whereType<Map<dynamic, dynamic>>()
                .map(Map<String, dynamic>.from)
                .map(PaycoreCardTransactionItem.fromJson)
                .toList()
          : const <PaycoreCardTransactionItem>[],
      pageNumber: _readInt(json, const ['pageNumber', 'PageNumber']) ?? 1,
      pageSize: _readInt(json, const ['pageSize', 'PageSize']) ?? 20,
      hasMore:
          _readBool(json, const ['hasMore', 'HasMore']) ??
          (rawTransactions is List && rawTransactions.length >= 20),
    );
  }

  final int cardId;
  final double totalDebit;
  final double totalCredit;
  final List<PaycoreCardTransactionItem> transactions;
  final int pageNumber;
  final int pageSize;
  final bool hasMore;
}

final class PaycoreCardTransactionItem {
  const PaycoreCardTransactionItem({
    required this.transactionId,
    required this.title,
    required this.amount,
    this.description,
    this.merchantName,
    this.merchantCity,
    this.merchantCountry,
    this.effect,
    this.date,
    this.processingCode,
    this.transactionType,
    this.terminalType,
    this.entryType,
    this.status,
    this.responseDescription,
  });

  factory PaycoreCardTransactionItem.fromJson(Map<String, dynamic> json) {
    final title =
        _readString(json, const [
          'title',
          'Title',
          'transactionTitle',
          'TransactionTitle',
          'txnName',
          'TxnName',
          'transactionName',
          'TransactionName',
          'operationName',
          'OperationName',
          'merchantName',
          'MerchantName',
        ]) ??
        'Kart işlemi';
    final description = _readString(json, const [
      'description',
      'Description',
      'transactionDescription',
      'TransactionDescription',
      'explanation',
      'Explanation',
      'transactionCode',
      'TransactionCode',
      'txnCode',
      'TxnCode',
    ]);
    final amount =
        _readDecimal(json, const [
          'amount',
          'Amount',
          'billingAmount',
          'BillingAmount',
          'originalAmount',
          'OriginalAmount',
          'settlementAmount',
          'SettlementAmount',
          'transactionAmount',
          'TransactionAmount',
          'txnAmount',
          'TxnAmount',
        ]) ??
        0;
    final effect =
        _readString(json, const [
          'effect',
          'Effect',
          'direction',
          'Direction',
          'debitCredit',
          'DebitCredit',
          'financialType',
          'FinancialType',
        ]) ??
        (amount < 0 ? 'D' : null);

    return PaycoreCardTransactionItem(
      transactionId:
          _readInt(json, const [
            'transactionId',
            'TransactionId',
            'txnId',
            'TxnId',
            'id',
            'Id',
          ]) ??
          0,
      title: title,
      description: description,
      merchantName: _readString(json, const ['merchantName', 'MerchantName']),
      merchantCity: _readString(json, const ['merchantCity', 'MerchantCity']),
      merchantCountry: _readString(json, const [
        'merchantCountry',
        'MerchantCountry',
      ]),
      amount: amount.abs(),
      effect: effect,
      date: _readString(json, const [
        'date',
        'Date',
        'transactionDate',
        'TransactionDate',
        'insertDate',
        'InsertDate',
        'txnDate',
        'TxnDate',
        'localDate',
        'LocalDate',
      ]),
      processingCode: _readString(json, const [
        'processingCode',
        'ProcessingCode',
        'procCode',
        'ProcCode',
      ]),
      transactionType: _readString(json, const [
        'transactionType',
        'TransactionType',
        'transactionCode',
        'TransactionCode',
        'mti',
        'Mti',
      ]),
      terminalType: _readString(json, const ['terminalType', 'TerminalType']),
      entryType: _readString(json, const ['entryType', 'EntryType']),
      status: _readString(json, const ['status', 'Status']),
      responseDescription: _readString(json, const [
        'responseDescription',
        'ResponseDescription',
      ]),
    );
  }

  final int transactionId;
  final String title;
  final String? description;
  final String? merchantName;
  final String? merchantCity;
  final String? merchantCountry;
  final double amount;
  final String? effect;
  final String? date;
  final String? processingCode;
  final String? transactionType;
  final String? terminalType;
  final String? entryType;
  final String? status;
  final String? responseDescription;
}

PaycoreCardBrand _resolvePaycoreCardBrand(Map<String, dynamic> json) {
  for (final hint in _brandHints(json)) {
    final normalized = _normalizeBrandHint(hint);
    if (normalized.contains('mastercard') ||
        normalized == 'master' ||
        normalized == 'mc' ||
        normalized.startsWith('mc')) {
      return PaycoreCardBrand.mastercard;
    }
    if (normalized.contains('troy') || normalized.startsWith('try')) {
      return PaycoreCardBrand.troy;
    }
    if (normalized.contains('visa') || normalized.startsWith('vis')) {
      return PaycoreCardBrand.visa;
    }
  }

  return PaycoreCardBrand.unknown;
}

String? _resolvePaycoreCardBrandHint(Map<String, dynamic> json) {
  for (final hint in _brandHints(json)) {
    if (hint.trim().isNotEmpty) {
      return hint.trim();
    }
  }
  return null;
}

String? _resolvePaycoreFullCardNo(Map<String, dynamic> json) {
  const keys = <String>[
    'cardNo',
    'CardNo',
    'fullCardNo',
    'FullCardNo',
    'fullPan',
    'FullPan',
    'clearCardNo',
    'ClearCardNo',
    'clearCardNumber',
    'ClearCardNumber',
    'unmaskedCardNo',
    'UnmaskedCardNo',
    'unmaskedCardNumber',
    'UnmaskedCardNumber',
    'openCardNo',
    'OpenCardNo',
    'plainCardNo',
    'PlainCardNo',
    'cardReference',
    'CardReference',
    'pan',
    'Pan',
    'cardNumber',
    'CardNumber',
    'realCardNo',
    'RealCardNo',
    'actualCardNo',
    'ActualCardNo',
  ];

  return _resolvePaycoreSecurityValue(
    json,
    keys,
    validator: _isPaycoreFullCardNo,
    normalizer: (value) => value.replaceAll(RegExp('[^0-9]'), '').trim(),
  );
}

String? _resolvePaycoreCvv(Map<String, dynamic> json) {
  const keys = <String>[
    'cvv',
    'Cvv',
    'CVV',
    'cvv2',
    'Cvv2',
    'CVV2',
    'cvc',
    'Cvc',
    'CVC',
    'securityCode',
    'SecurityCode',
    'cardSecurityCode',
    'CardSecurityCode',
  ];

  return _resolvePaycoreSecurityValue(
    json,
    keys,
    validator: _isPaycoreCvv,
    normalizer: (value) => value.replaceAll(RegExp('[^0-9]'), '').trim(),
  );
}

String? _resolvePaycoreSecurityValue(
  Map<String, dynamic> json,
  List<String> keys, {
  required bool Function(String value) validator,
  required String Function(String value) normalizer,
  Set<int>? visited,
}) {
  final seen = visited ?? <int>{};
  final identity = identityHashCode(json);
  if (!seen.add(identity)) {
    return null;
  }

  for (final key in keys) {
    final value = _readPaycoreSecurityValue(_readCaseInsensitive(json, key));
    if (value == null) {
      continue;
    }

    if (validator(value)) {
      final normalized = normalizer(value);
      return normalized;
    }
  }

  for (final value in json.values) {
    if (value is Map) {
      final nested = _resolvePaycoreSecurityValue(
        Map<String, dynamic>.from(value),
        keys,
        validator: validator,
        normalizer: normalizer,
        visited: seen,
      );
      if (nested != null) {
        return nested;
      }
    }
    if (value is List) {
      for (final item in value) {
        if (item is! Map) {
          continue;
        }
        final nested = _resolvePaycoreSecurityValue(
          Map<String, dynamic>.from(item),
          keys,
          validator: validator,
          normalizer: normalizer,
          visited: seen,
        );
        if (nested != null) {
          return nested;
        }
      }
    }
  }

  return null;
}

String? _readPaycoreSecurityValue(dynamic value) {
  if (value is String) {
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
  if (value is int) {
    return value.toString();
  }
  if (value is num) {
    return value.toInt().toString();
  }

  return null;
}

bool _isPaycoreFullCardNo(String value) {
  if (value.contains('*')) {
    return false;
  }

  final normalized = value.replaceAll(RegExp('[^0-9]'), '').trim();
  return normalized.length >= 12;
}

bool _isPaycoreCvv(String value) {
  if (value.contains('*')) {
    return false;
  }

  final normalized = value.replaceAll(RegExp('[^0-9]'), '').trim();
  return normalized.length >= 3 && normalized.length <= 4;
}

dynamic _readCaseInsensitive(Map<String, dynamic> json, String key) {
  if (json.containsKey(key)) {
    return json[key];
  }

  final normalizedKey = key.toLowerCase();
  for (final entry in json.entries) {
    if (entry.key.toLowerCase() == normalizedKey) {
      return entry.value;
    }
  }

  return null;
}

List<dynamic>? _resolvePaycoreTransactionList(dynamic payload) {
  if (payload is List) {
    return payload;
  }

  if (payload is! Map) {
    return null;
  }

  final json = Map<String, dynamic>.from(payload);
  const keys = <String>[
    'transactions',
    'Transactions',
    'transactionList',
    'TransactionList',
    'cardTransactions',
    'CardTransactions',
    'items',
    'Items',
    'list',
    'List',
    'rows',
    'Rows',
    'records',
    'Records',
    'movements',
    'Movements',
  ];

  for (final key in keys) {
    final value = _readCaseInsensitive(json, key);
    if (value is List) {
      return value;
    }
  }

  for (final key in const ['data', 'Data', 'result', 'Result']) {
    final nested = _readCaseInsensitive(json, key);
    final transactions = _resolvePaycoreTransactionList(nested);
    if (transactions != null) {
      return transactions;
    }
  }

  return null;
}

Iterable<String> _brandHints(Map<String, dynamic> json) sync* {
  const keys = <String>[
    'cardBrand',
    'CardBrand',
    'cardType',
    'CardType',
    'scheme',
    'Scheme',
    'brand',
    'Brand',
    'paymentSystem',
    'PaymentSystem',
    'cardScheme',
    'CardScheme',
    'cardNetwork',
    'CardNetwork',
    'network',
    'Network',
    'cardTypeName',
    'CardTypeName',
    'productCode',
    'ProductCode',
  ];

  for (final key in keys) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      yield value;
    }
  }
}

String _normalizeBrandHint(String value) {
  return value.trim().toLowerCase().replaceAll(RegExp('[^a-z0-9]+'), '');
}

String? _readString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = _readCaseInsensitive(json, key);
    if (value is String) {
      final normalized = value.trim();
      if (normalized.isNotEmpty) {
        return normalized;
      }
    } else if (value is num || value is bool) {
      return value.toString();
    }
  }

  return null;
}

int? _readInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = _readCaseInsensitive(json, key);
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      final parsed = int.tryParse(value.trim());
      if (parsed != null) {
        return parsed;
      }
    }
  }

  return null;
}

bool? _readBool(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = _readCaseInsensitive(json, key);
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }
  }

  return null;
}

double? _readDecimal(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = _readCaseInsensitive(json, key);
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      final normalized = value.trim().replaceAll(',', '.');
      final parsed = double.tryParse(normalized);
      if (parsed != null) {
        return parsed;
      }
    }
  }

  return null;
}

final class PaycorePinStatus {
  const PaycorePinStatus({
    required this.pinSetFlag,
    required this.lastPinSetDate,
    this.pinValue,
  });

  factory PaycorePinStatus.fromJson(Map<String, dynamic> json) {
    final rawDate =
        json['lastPinSetDate'] ??
        json['LastPinSetDate'] ??
        json['pinSetDate'] ??
        json['PinSetDate'] ??
        json['lastPinDate'] ??
        json['LastPinDate'];
    return PaycorePinStatus(
      pinSetFlag:
          _parsePaycorePinFlag(
            json['pinSetFlag'] ??
                json['PinSetFlag'] ??
                json['isPinSet'] ??
                json['IsPinSet'] ??
                json['pinDefined'] ??
                json['PinDefined'],
          ) ||
          (_resolvePaycorePin(json)?.trim().isNotEmpty ?? false),
      lastPinSetDate: _parsePaycorePinDate(rawDate),
      pinValue: _resolvePaycorePin(json),
    );
  }

  final bool pinSetFlag;
  final DateTime? lastPinSetDate;
  final String? pinValue;
}

bool _parsePaycorePinFlag(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'evet';
  }

  return false;
}

DateTime? _parsePaycorePinDate(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  if (value is String) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }

    return DateTime.tryParse(normalized);
  }

  return null;
}

final class PaycoreAtmQrInfo {
  const PaycoreAtmQrInfo({
    required this.messageReferenceNumber,
    required this.date,
    required this.countryCode,
    required this.amountAvailable,
    required this.transactionType,
    required this.terminalType,
    required this.amount,
    required this.currencyCode,
    required this.merchantName,
    required this.merchantCity,
    required this.merchantId,
    required this.terminalId,
    required this.merchantIban,
    required this.latitude,
    required this.longitude,
    required this.resultCode,
    required this.resultDescription,
  });

  factory PaycoreAtmQrInfo.fromJson(Map<String, dynamic> json) {
    return PaycoreAtmQrInfo(
      messageReferenceNumber: json['messageReferenceNumber'] as String?,
      date: DateTime.tryParse(json['date'] as String? ?? ''),
      countryCode: json['countryCode'] as String?,
      amountAvailable: json['amountAvailable'] as int?,
      transactionType: (json['transactionType'] as num?)?.toInt(),
      terminalType: (json['terminalType'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      currencyCode: (json['currencyCode'] as num?)?.toInt(),
      merchantName: json['merchantName'] as String?,
      merchantCity: json['merchantCity'] as String?,
      merchantId: json['merchantId'] as String?,
      terminalId: json['terminalId'] as String?,
      merchantIban: json['merchantIban'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      resultCode: json['resultCode'] as String?,
      resultDescription: json['resultDescription'] as String?,
    );
  }

  final String? messageReferenceNumber;
  final DateTime? date;
  final String? countryCode;
  final int? amountAvailable;
  final int? transactionType;
  final int? terminalType;
  final double? amount;
  final int? currencyCode;
  final String? merchantName;
  final String? merchantCity;
  final String? merchantId;
  final String? terminalId;
  final String? merchantIban;
  final double? latitude;
  final double? longitude;
  final String? resultCode;
  final String? resultDescription;

  String? get resolvedTrxType => transactionType?.toString();

  String? get suggestedProcessingCode => switch (transactionType) {
    1 => '010000',
    _ => null,
  };

  String get terminalTypeLabel => switch (terminalType) {
    9 => 'POS / ATM',
    1 => 'ATM',
    _ => terminalType?.toString() ?? '-',
  };
}

final class PaycoreAtmQrStartResult {
  const PaycoreAtmQrStartResult({
    required this.resultCode,
    required this.resultDescription,
  });

  factory PaycoreAtmQrStartResult.fromJson(Map<String, dynamic> json) {
    return PaycoreAtmQrStartResult(
      resultCode: json['resultCode'] as String?,
      resultDescription: json['resultDescription'] as String?,
    );
  }

  final String? resultCode;
  final String? resultDescription;
}

final class PaycoreCustomerInfo {
  const PaycoreCustomerInfo({
    required this.bankingCustomerNo,
    required this.customerNo,
    required this.name,
    required this.midname,
    required this.surname,
    required this.primaryCardNo,
    required this.statCode,
    required this.commLanguage,
    required this.riskCode,
    required this.customerGroupCode,
    required this.profession,
    required this.customerEmbossNameExt,
    required this.companyName,
    required this.companyNo,
    required this.title,
    required this.workPlace,
    required this.graduation,
    required this.disabledType,
    required this.guarantor,
    required this.guarantorProfession,
    required this.branchCode,
    required this.digitalSlipType,
    required this.lastCardIssuingDate,
    required this.firstCreditCardDate,
    required this.statChangeDate,
    required this.isGuaranteed,
    required this.isBusiness,
    required this.isIdentityPresented,
    required this.hasCar,
    required this.hasRealEstate,
    required this.isAllowedShareCstInfo,
    required this.shareCstInfoChgDate,
    required this.gender,
    required this.nationality,
    required this.nationalIdentityNo,
    required this.birthDate,
    required this.birthPlace,
    required this.identityType,
    required this.taxNo,
    required this.taxDepartmentName,
    required this.fatherName,
    required this.motherName,
    required this.maidenName,
    required this.partnerName,
    required this.identitySerialNo,
    required this.identityIssuedBy,
    required this.identityIssueDate,
    required this.identityValidUntil,
    required this.identityCityCode,
    required this.identityTownCode,
    required this.followUpStat,
    required this.stmtStatCode,
    required this.stmtDelinqPeriod,
    required this.nplCount,
    required this.minPayCount,
    required this.prevMinPayCount,
    required this.minPayChangeDate,
    required this.minPayDelinq,
    required this.firstDelayDate,
    required this.lastTxnDate,
    required this.activityStat,
    required this.activityStatCount,
    required this.addresses,
    required this.communications,
    required this.limits,
    required this.raw,
  });

  factory PaycoreCustomerInfo.fromJson(Map<String, dynamic> json) {
    final payload =
        (json['result'] as Map<String, dynamic>?) ?? <String, dynamic>{...json};
    final identity =
        (payload['cstCustomerIdentity'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};

    final addresses =
        (payload['cstCustomerAddresses'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(PaycoreCustomerAddress.fromJson)
            .toList();

    final communications =
        (payload['cstCustomerCommunications'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(PaycoreCustomerCommunication.fromJson)
            .toList();

    final limits = (payload['customerLimits'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(PaycoreCustomerLimit.fromJson)
        .toList();

    final rawBirthDate = identity['birthDate'];
    final stmtAccountStat =
        (payload['stmtAccountStat'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};
    final lastActivity =
        (payload['crdAccountLastActivity'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};
    return PaycoreCustomerInfo(
      bankingCustomerNo: payload['bankingCustomerNo'] as String? ?? '',
      customerNo: payload['customerNo'] as String? ?? '',
      name: payload['name'] as String? ?? '',
      midname: payload['midname'] as String?,
      surname: payload['surname'] as String? ?? '',
      primaryCardNo: payload['primaryCardNo'] as String?,
      statCode: payload['statCode'] as String?,
      commLanguage: payload['commLanguage'] as String?,
      riskCode: payload['riskCode'] as String?,
      customerGroupCode: payload['customerGroupCode'] as String?,
      profession: payload['profession'] as String?,
      customerEmbossNameExt: payload['customerEmbossNameExt'] as String?,
      companyName: payload['companyName'] as String?,
      companyNo: payload['companyNo'] as String?,
      title: payload['title'] as String?,
      workPlace: payload['workPlace'] as String?,
      graduation: payload['graduation'] as String?,
      disabledType: payload['disabledType'] as String?,
      guarantor: payload['guarantor'] as String?,
      guarantorProfession: payload['guarantorProfession'] as String?,
      branchCode: (payload['branchCode'] as num?)?.toInt(),
      digitalSlipType: (payload['digitalSlipType'] as num?)?.toInt(),
      lastCardIssuingDate: _tryParseDateTime(payload['lastCardIssuingDate']),
      firstCreditCardDate: _tryParseDateTime(payload['firstCreditCardDate']),
      statChangeDate: _tryParseDateTime(payload['statChangeDate']),
      isGuaranteed: payload['isGuaranteed'] as bool?,
      isBusiness: payload['isBusiness'] as bool?,
      isIdentityPresented: payload['isIdentityPresented'] as bool?,
      hasCar: payload['hasCar'] as bool?,
      hasRealEstate: payload['hasRealEstate'] as bool?,
      isAllowedShareCstInfo: payload['isAllowedShareCstInfo'] as bool?,
      shareCstInfoChgDate: _tryParseDateTime(payload['shareCstInfoChgDate']),
      gender: identity['gender'] as String?,
      nationality: identity['nationality'] as String?,
      nationalIdentityNo: identity['nationalIdentityNo'] as String?,
      birthDate: rawBirthDate is String && rawBirthDate.isNotEmpty
          ? DateTime.tryParse(rawBirthDate)
          : null,
      birthPlace: identity['birthPlace'] as String?,
      identityType: identity['identityType'] as String?,
      taxNo: identity['taxNo'] as String?,
      taxDepartmentName: identity['taxDepartmentName'] as String?,
      fatherName: identity['fatherName'] as String?,
      motherName: identity['motherName'] as String?,
      maidenName: identity['maidenName'] as String?,
      partnerName: identity['partnerName'] as String?,
      identitySerialNo: identity['identitySerialNo'] as String?,
      identityIssuedBy: identity['identityIssuedBy'] as String?,
      identityIssueDate: _tryParseDateTime(identity['identityIssueDate']),
      identityValidUntil: _tryParseDateTime(identity['identityValidUntil']),
      identityCityCode: identity['identityCityCode'] as String?,
      identityTownCode: identity['identityTownCode'] as String?,
      followUpStat: stmtAccountStat['followUpStat'] as String?,
      stmtStatCode: stmtAccountStat['stmtStatCode'] as String?,
      stmtDelinqPeriod: (stmtAccountStat['stmtDelinqPeriod'] as num?)?.toInt(),
      nplCount: (stmtAccountStat['nplCount'] as num?)?.toInt(),
      minPayCount: (stmtAccountStat['minPayCount'] as num?)?.toInt(),
      prevMinPayCount: (stmtAccountStat['prevMinPayCount'] as num?)?.toInt(),
      minPayChangeDate: _tryParseDateTime(stmtAccountStat['minPayChangeDate']),
      minPayDelinq: (stmtAccountStat['minPayDelinq'] as num?)?.toInt(),
      firstDelayDate: _tryParseDateTime(stmtAccountStat['firstDelayDate']),
      lastTxnDate: _tryParseDateTime(lastActivity['lastTxnDate']),
      activityStat: lastActivity['activityStat'] as String?,
      activityStatCount: (lastActivity['activityStatCount'] as num?)?.toInt(),
      addresses: addresses,
      communications: communications,
      limits: limits,
      raw: payload,
    );
  }

  String get fullName => [name, midname, surname]
      .where((value) => value?.trim().isNotEmpty ?? false)
      .map((value) => value!.trim())
      .join(' ');

  final String bankingCustomerNo;
  final String customerNo;
  final String name;
  final String? midname;
  final String surname;
  final String? primaryCardNo;
  final String? statCode;
  final String? commLanguage;
  final String? riskCode;
  final String? customerGroupCode;
  final String? profession;
  final String? customerEmbossNameExt;
  final String? companyName;
  final String? companyNo;
  final String? title;
  final String? workPlace;
  final String? graduation;
  final String? disabledType;
  final String? guarantor;
  final String? guarantorProfession;
  final int? branchCode;
  final int? digitalSlipType;
  final DateTime? lastCardIssuingDate;
  final DateTime? firstCreditCardDate;
  final DateTime? statChangeDate;
  final bool? isGuaranteed;
  final bool? isBusiness;
  final bool? isIdentityPresented;
  final bool? hasCar;
  final bool? hasRealEstate;
  final bool? isAllowedShareCstInfo;
  final DateTime? shareCstInfoChgDate;
  final String? gender;
  final String? nationality;
  final String? nationalIdentityNo;
  final DateTime? birthDate;
  final String? birthPlace;
  final String? identityType;
  final String? taxNo;
  final String? taxDepartmentName;
  final String? fatherName;
  final String? motherName;
  final String? maidenName;
  final String? partnerName;
  final String? identitySerialNo;
  final String? identityIssuedBy;
  final DateTime? identityIssueDate;
  final DateTime? identityValidUntil;
  final String? identityCityCode;
  final String? identityTownCode;
  final String? followUpStat;
  final String? stmtStatCode;
  final int? stmtDelinqPeriod;
  final int? nplCount;
  final int? minPayCount;
  final int? prevMinPayCount;
  final DateTime? minPayChangeDate;
  final int? minPayDelinq;
  final DateTime? firstDelayDate;
  final DateTime? lastTxnDate;
  final String? activityStat;
  final int? activityStatCount;
  final List<PaycoreCustomerAddress> addresses;
  final List<PaycoreCustomerCommunication> communications;
  final List<PaycoreCustomerLimit> limits;
  final Map<String, dynamic> raw;
}

DateTime? _tryParseDateTime(Object? value) {
  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

final class PaycoreCustomerAddress {
  const PaycoreCustomerAddress({
    required this.idx,
    required this.addressType,
    required this.address1,
    required this.address2,
    required this.city,
    required this.town,
    required this.cityCode,
    required this.townCode,
    required this.district,
    required this.zipCode,
    required this.countryCode,
    required this.isDefault,
  });

  factory PaycoreCustomerAddress.fromJson(Map<String, dynamic> json) {
    return PaycoreCustomerAddress(
      idx: (json['idx'] as num?)?.toInt() ?? 0,
      addressType: json['addressType'] as String? ?? '',
      address1: json['address1'] as String? ?? '',
      address2: json['address2'] as String?,
      city: json['city'] as String?,
      town: json['town'] as String?,
      cityCode: _normalizePaycoreCityCode(json['cityCode']),
      townCode: _normalizePaycoreTownCode(json['townCode']),
      district: json['district'] as String?,
      zipCode: json['zipCode'] as String?,
      countryCode: json['countryCode'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  final int idx;
  final String addressType;
  final String address1;
  final String? address2;
  final String? city;
  final String? town;
  final String? cityCode;
  final String? townCode;
  final String? district;
  final String? zipCode;
  final String? countryCode;
  final bool isDefault;
}

String? _normalizePaycoreCityCode(Object? value) {
  final digits = value is String
      ? value.trim().replaceAll(RegExp(r'\D+'), '')
      : '';

  if (digits.isEmpty) {
    return null;
  }

  return digits.padLeft(3, '0');
}

String? _normalizePaycoreTownCode(Object? value) {
  final digits = value is String
      ? value.trim().replaceAll(RegExp(r'\D+'), '')
      : '';

  if (digits.isEmpty) {
    return null;
  }

  return digits;
}

final class PaycoreCustomerCommunication {
  const PaycoreCustomerCommunication({
    required this.communicationType,
    required this.info,
    required this.isDefault,
  });

  factory PaycoreCustomerCommunication.fromJson(Map<String, dynamic> json) {
    return PaycoreCustomerCommunication(
      communicationType: json['communicationType'] as String? ?? '',
      info: json['info'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  final String communicationType;
  final String info;
  final bool isDefault;
}

final class PaycoreCustomerLimit {
  const PaycoreCustomerLimit({
    required this.currentLimit,
    required this.isLimitBlocked,
    required this.currencyCode,
  });

  factory PaycoreCustomerLimit.fromJson(Map<String, dynamic> json) {
    return PaycoreCustomerLimit(
      currentLimit: (json['currentLimit'] as num?)?.toDouble() ?? 0,
      isLimitBlocked: json['isLimitBlocked'] as bool? ?? false,
      currencyCode: (json['currencyCode'] as num?)?.toInt(),
    );
  }

  final double currentLimit;
  final bool isLimitBlocked;
  final int? currencyCode;
}
