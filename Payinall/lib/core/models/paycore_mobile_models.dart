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
    required this.statusName,
    required this.cardTypeName,
    required this.isPrimary,
    required this.brand,
    this.brandHint,
    this.fullCardNo,
  });

  factory PaycoreCardSummary.fromJson(Map<String, dynamic> json) {
    final brand = _resolvePaycoreCardBrand(json);
    return PaycoreCardSummary(
      id: (json['id'] as num?)?.toInt() ?? 0,
      cardReference: json['cardReference'] as String? ?? '',
      maskedCardNo: json['maskedCardNo'] as String? ?? '-',
      fullCardNo: _resolvePaycoreFullCardNo(json),
      productCode: json['productCode'] as String?,
      embossName: json['embossName'] as String?,
      expiryDate: json['expiryDate'] as String?,
      isDigitalCard: json['isDigitalCard'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? false,
      statusName: json['statusName'] as String? ?? '-',
      cardTypeName: json['cardTypeName'] as String? ?? '-',
      isPrimary: json['isPrimary'] as bool? ?? false,
      brand: brand,
      brandHint: _resolvePaycoreCardBrandHint(json),
    );
  }

  final int id;
  final String cardReference;
  final String maskedCardNo;
  final String? fullCardNo;
  final String? productCode;
  final String? embossName;
  final String? expiryDate;
  final bool isDigitalCard;
  final bool isActive;
  final String statusName;
  final String cardTypeName;
  final bool isPrimary;
  final PaycoreCardBrand brand;
  final String? brandHint;

  String get profileLabel {
    final normalizedProductCode = productCode?.trim().toUpperCase();

    if (normalizedProductCode == 'TRYSNL' && isDigitalCard) {
      return 'Troy Sanal';
    }
    if (normalizedProductCode == 'TRYSNL' ||
        normalizedProductCode == 'TRYFZKSL') {
      return 'Troy Fiziki';
    }
    if (normalizedProductCode == 'MCPVB') {
      return 'Master Sanal';
    }
    if (normalizedProductCode == 'MCPSB' ||
        normalizedProductCode == 'MCFZKSL') {
      return 'Master Fiziki';
    }
    if (normalizedProductCode?.startsWith('MC') ?? false) {
      return isDigitalCard ? 'Master Sanal' : 'Master Fiziki';
    }
    if (normalizedProductCode?.startsWith('TRY') ?? false) {
      return isDigitalCard ? 'Troy Sanal' : 'Troy Fiziki';
    }

    return '${normalizedProductCode ?? '-'} • ${isDigitalCard ? 'Sanal' : 'Fiziki'}';
  }
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
    'fullCardNo',
    'pan',
    'cardNumber',
    'realCardNo',
  ];

  for (final key in keys) {
    final value = json[key];
    if (value is! String) {
      continue;
    }

    final normalized = value.replaceAll(RegExp('[^0-9]'), '').trim();
    if (normalized.length >= 12) {
      return normalized;
    }
  }

  return null;
}

Iterable<String> _brandHints(Map<String, dynamic> json) sync* {
  const keys = <String>[
    'cardBrand',
    'cardType',
    'scheme',
    'brand',
    'paymentSystem',
    'cardScheme',
    'cardNetwork',
    'network',
    'cardTypeName',
    'productCode',
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

final class PaycorePinStatus {
  const PaycorePinStatus({
    required this.pinSetFlag,
    required this.lastPinSetDate,
  });

  factory PaycorePinStatus.fromJson(Map<String, dynamic> json) {
    final rawDate = json['lastPinSetDate'];
    return PaycorePinStatus(
      pinSetFlag: json['pinSetFlag'] as bool? ?? false,
      lastPinSetDate: rawDate is String && rawDate.isNotEmpty
          ? DateTime.tryParse(rawDate)
          : null,
    );
  }

  final bool pinSetFlag;
  final DateTime? lastPinSetDate;
}

final class PaycoreCustomerInfo {
  const PaycoreCustomerInfo({
    required this.bankingCustomerNo,
    required this.customerNo,
    required this.name,
    required this.surname,
    required this.primaryCardNo,
    required this.customerGroupCode,
    required this.gender,
    required this.nationalIdentityNo,
    required this.birthDate,
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
    return PaycoreCustomerInfo(
      bankingCustomerNo: payload['bankingCustomerNo'] as String? ?? '',
      customerNo: payload['customerNo'] as String? ?? '',
      name: payload['name'] as String? ?? '',
      surname: payload['surname'] as String? ?? '',
      primaryCardNo: payload['primaryCardNo'] as String?,
      customerGroupCode: payload['customerGroupCode'] as String?,
      gender: identity['gender'] as String?,
      nationalIdentityNo: identity['nationalIdentityNo'] as String?,
      birthDate: rawBirthDate is String && rawBirthDate.isNotEmpty
          ? DateTime.tryParse(rawBirthDate)
          : null,
      addresses: addresses,
      communications: communications,
      limits: limits,
      raw: payload,
    );
  }

  String get fullName => '$name $surname'.trim();

  final String bankingCustomerNo;
  final String customerNo;
  final String name;
  final String surname;
  final String? primaryCardNo;
  final String? customerGroupCode;
  final String? gender;
  final String? nationalIdentityNo;
  final DateTime? birthDate;
  final List<PaycoreCustomerAddress> addresses;
  final List<PaycoreCustomerCommunication> communications;
  final List<PaycoreCustomerLimit> limits;
  final Map<String, dynamic> raw;
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
      cityCode: json['cityCode'] as String?,
      townCode: json['townCode'] as String?,
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
