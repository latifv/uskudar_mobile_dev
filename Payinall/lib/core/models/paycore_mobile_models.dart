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
    this.cvv,
    this.fullCardNo,
  });

  factory PaycoreCardSummary.fromJson(Map<String, dynamic> json) {
    final brand = _resolvePaycoreCardBrand(json);
    return PaycoreCardSummary(
      id: (json['id'] as num?)?.toInt() ?? 0,
      cardReference: json['cardReference'] as String? ?? '',
      maskedCardNo: json['maskedCardNo'] as String? ?? '-',
      fullCardNo: _resolvePaycoreFullCardNo(json),
      cvv: _resolvePaycoreCvv(json),
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
  final String? cvv;
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

  bool get isVirtualProduct {
    final normalizedProductCode = productCode?.trim().toUpperCase();
    return normalizedProductCode == 'TRYSNL' ||
        normalizedProductCode == 'MCPVB';
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
    if (normalizedProductCode == 'MCPVB') {
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

String? _resolvePaycoreCvv(Map<String, dynamic> json) {
  const keys = <String>['cvv', 'cvv2'];

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
    'cardReference',
    'pan',
    'cardNumber',
    'realCardNo',
    'actualCardNo',
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
