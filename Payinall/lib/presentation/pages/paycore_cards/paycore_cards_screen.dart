import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, rootBundle;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:payinall/core/managers/token_manager.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/core/models/paycore_mobile_models.dart';
import 'package:payinall/core/services/paycore_mobile_service.dart';
import 'package:payinall/data/network/models/network_response.dart';
import 'package:payinall/data/network/network_client.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/metropol_city.dart';
import 'package:payinall/domain/usecases/get_metropol_cities_usecase.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/constants/icon_asset_constants.dart';
import 'package:payinall/presentation/shared/constants/paycore_card_asset_constants.dart';
import 'package:payinall/presentation/pages/qr_operation/scan/qr_scan_screen.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/shared/widgets/paycore_card_visual.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

enum _PaycoreModule { customer, cards, security }

final class _PaycoreTownCodeDefinition {
  const _PaycoreTownCodeDefinition({required this.name, required this.code});

  factory _PaycoreTownCodeDefinition.fromJson(Map<String, dynamic> json) {
    return _PaycoreTownCodeDefinition(
      name: json['name'] as String? ?? '',
      code: _normalizePaycoreTownCodeValue(json['code'] as String? ?? ''),
    );
  }

  final String name;
  final String code;
}

final class _PaycoreCityCodeDefinition {
  const _PaycoreCityCodeDefinition({
    required this.city,
    required this.cityCode,
    required this.towns,
  });

  factory _PaycoreCityCodeDefinition.fromJson(Map<String, dynamic> json) {
    final rawTowns = json['towns'];
    return _PaycoreCityCodeDefinition(
      city: json['city'] as String? ?? '',
      cityCode: _normalizePaycoreCityCodeValue(
        json['cityCode'] as String? ?? '',
      ),
      towns: rawTowns is List
          ? rawTowns
                .whereType<Map<String, dynamic>>()
                .map(_PaycoreTownCodeDefinition.fromJson)
                .toList()
          : const <_PaycoreTownCodeDefinition>[],
    );
  }

  final String city;
  final String cityCode;
  final List<_PaycoreTownCodeDefinition> towns;
}

final class _PhysicalCardInput {
  const _PhysicalCardInput({
    required this.cardNo,
    required this.barcodeNo,
  });

  final String? cardNo;
  final String? barcodeNo;
}

final class _PhysicalCardCustomerPayload {
  const _PhysicalCardCustomerPayload({
    required this.gender,
    required this.cityName,
    required this.townName,
    required this.district,
    required this.townCode,
    required this.cityCode,
    required this.postalCode,
    required this.address,
  });

  final String gender;
  final String cityName;
  final String townName;
  final String district;
  final String townCode;
  final String cityCode;
  final String postalCode;
  final String address;
}

String _normalizePaycoreCityCodeValue(String value) {
  final digits = value.trim().replaceAll(RegExp(r'\D+'), '');
  if (digits.isEmpty) {
    return '';
  }

  return digits.padLeft(3, '0');
}

String _normalizePaycoreTownCodeValue(String value) {
  return value.trim().replaceAll(RegExp(r'\D+'), '');
}

final class PaycoreCardsScreen extends StatefulWidget {
  const PaycoreCardsScreen({
    this.openActivateTab = false,
    super.key,
  });

  final bool openActivateTab;

  @override
  State<PaycoreCardsScreen> createState() => _PaycoreCardsScreenState();
}

final class _PaycoreCardsScreenState extends State<PaycoreCardsScreen> {
  static const Duration _loadTimeout = Duration(seconds: 15);
  static const List<PaycoreCardCreationProfile> _availableCardProfiles =
      <PaycoreCardCreationProfile>[
        PaycoreCardCreationProfile.troyPhysical,
        PaycoreCardCreationProfile.troyVirtual,
        PaycoreCardCreationProfile.masterPhysical,
      ];
  late final PaycoreMobileService _paycoreService;
  late final UserInfoManager _userInfoManager;
  late final TokenManager _tokenManager;
  late final GetMetropolCitiesUsecase _getMetropolCitiesUsecase;

  bool _isLoading = true;
  String? _loadError;
  final Set<int> _busyCards = <int>{};
  final Set<int> _loadingPinCards = <int>{};
  final Set<int> _cvvPeekCards = <int>{};
  final Set<int> _expandedCardMenus = <int>{};
  final Set<int> _revealedVirtualCardNumbers = <int>{};

  PaycoreCustomerInfo? _customerInfo;
  bool _hasPaycoreCustomerRecord = false;
  PaycoreCustomerAddress? _localCustomerAddressOverride;
  List<PaycoreCardSummary> _cards = const [];
  Map<int, PaycorePinStatus> _pinStatuses = const <int, PaycorePinStatus>{};
  List<MetropolCity> _metropolCities = const [];
  List<_PaycoreCityCodeDefinition> _paycoreCityCodes =
      const <_PaycoreCityCodeDefinition>[];
  _PaycoreModule _selectedModule = _PaycoreModule.cards;

  @override
  void initState() {
    super.initState();
    _paycoreService = PaycoreMobileService(getIt<NetworkClient>());
    _userInfoManager = getIt<UserInfoManager>();
    _tokenManager = getIt<TokenManager>();
    _getMetropolCitiesUsecase = getIt<GetMetropolCitiesUsecase>();
    unawaited(_loadData());
    unawaited(_loadMetropolCities());
    unawaited(_loadPaycoreLocationCodes());
  }

  Future<NetworkResponse<PaycoreCustomerInfo>> _fetchCustomerInfo() async {
    final customerNumber = _resolveCurrentCustomerNumber();
    if (customerNumber.isEmpty) {
      return NetworkResponse.fromJson<PaycoreCustomerInfo>(
        <String, dynamic>{
          'isSuccess': false,
          'message': 'Müşteri numarası bulunamadı.',
          'data': null,
        },
      );
    }

    final currentCustomerResponse = await _paycoreService.getCustomerInfo();
    if (currentCustomerResponse.isSuccess &&
        currentCustomerResponse.data != null) {
      return currentCustomerResponse;
    }

    final customerNumberResponse = await _paycoreService
        .getCustomerInfoByCustomerNumber(customerNumber);
    if (customerNumberResponse.isSuccess &&
        customerNumberResponse.data != null) {
      return customerNumberResponse;
    }

    final managementResponse = await _paycoreService
        .getCustomerInfoFromManagement(customerNumber);
    if (managementResponse.isSuccess && managementResponse.data != null) {
      return managementResponse;
    }

    return managementResponse.message?.trim().isNotEmpty ?? false
        ? managementResponse
        : (customerNumberResponse.message?.trim().isNotEmpty ?? false)
        ? customerNumberResponse
        : currentCustomerResponse;
  }

  String _resolveCurrentCustomerNumber() {
    final walletAddress = _userInfoManager.walletAddress?.trim() ?? '';
    if (walletAddress.isNotEmpty) {
      return walletAddress;
    }

    final token = _tokenManager.token;
    if (token == null || token.trim().isEmpty) {
      return '';
    }

    final claims = _decodeJwtClaims(token);
    final candidates = <Object?>[
      claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'],
      claims['customerNumber'],
      claims['customerNo'],
      claims['walletAddress'],
      claims['alg'],
    ];

    for (final candidate in candidates) {
      final normalized = candidate?.toString().trim() ?? '';
      if (RegExp(r'^\d{6,}$').hasMatch(normalized)) {
        return normalized;
      }
    }

    return '';
  }

  Map<String, dynamic> _decodeJwtClaims(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) {
        return const <String, dynamic>{};
      }

      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final parsed = jsonDecode(decoded);
      if (parsed is Map<String, dynamic>) {
        return parsed;
      }
    } on FormatException {
      return const <String, dynamic>{};
    } on Object {
      return const <String, dynamic>{};
    }

    return const <String, dynamic>{};
  }

  PaycoreCustomerInfo? _buildLocalCustomerInfoFallback() {
    final customerNumber = _resolveCurrentCustomerNumber();
    final firstName = _userInfoManager.firstName?.trim() ?? '';
    final lastName = _userInfoManager.lastName?.trim() ?? '';
    final gsmNumber = _userInfoManager.gsmNumber?.trim() ?? '';
    final email = _userInfoManager.email?.trim() ?? '';

    if (customerNumber.isEmpty &&
        firstName.isEmpty &&
        lastName.isEmpty &&
        gsmNumber.isEmpty &&
        email.isEmpty) {
      return null;
    }

    final communications = <PaycoreCustomerCommunication>[
      if (gsmNumber.isNotEmpty)
        PaycoreCustomerCommunication(
          communicationType: 'GSM',
          info: gsmNumber,
          isDefault: true,
        ),
      if (email.isNotEmpty)
        PaycoreCustomerCommunication(
          communicationType: 'EM',
          info: email,
          isDefault: gsmNumber.isEmpty,
        ),
    ];

    final primaryCardNo = _cards
        .where((card) => card.isPrimary)
        .map((card) => card.maskedCardNo)
        .firstWhere(
          (value) => value.trim().isNotEmpty,
          orElse: () => _cards.isNotEmpty ? _cards.first.maskedCardNo : '',
        );

    final fallbackAddresses = _localCustomerAddressOverride == null
        ? const <PaycoreCustomerAddress>[]
        : <PaycoreCustomerAddress>[_localCustomerAddressOverride!];

    return PaycoreCustomerInfo(
      bankingCustomerNo: customerNumber,
      customerNo: customerNumber,
      name: firstName,
      midname: null,
      surname: lastName,
      primaryCardNo: primaryCardNo.isNotEmpty ? primaryCardNo : null,
      statCode: null,
      commLanguage: null,
      riskCode: null,
      customerGroupCode: null,
      profession: null,
      customerEmbossNameExt: null,
      companyName: null,
      companyNo: null,
      title: null,
      workPlace: null,
      graduation: null,
      disabledType: null,
      guarantor: null,
      guarantorProfession: null,
      branchCode: null,
      digitalSlipType: null,
      lastCardIssuingDate: null,
      firstCreditCardDate: null,
      statChangeDate: null,
      isGuaranteed: null,
      isBusiness: null,
      isIdentityPresented: null,
      hasCar: null,
      hasRealEstate: null,
      isAllowedShareCstInfo: null,
      shareCstInfoChgDate: null,
      gender: null,
      nationality: null,
      nationalIdentityNo: null,
      birthDate: null,
      birthPlace: null,
      identityType: null,
      taxNo: null,
      taxDepartmentName: null,
      fatherName: null,
      motherName: null,
      maidenName: null,
      partnerName: null,
      identitySerialNo: null,
      identityIssuedBy: null,
      identityIssueDate: null,
      identityValidUntil: null,
      identityCityCode: null,
      identityTownCode: null,
      followUpStat: null,
      stmtStatCode: null,
      stmtDelinqPeriod: null,
      nplCount: null,
      minPayCount: null,
      prevMinPayCount: null,
      minPayChangeDate: null,
      minPayDelinq: null,
      firstDelayDate: null,
      lastTxnDate: null,
      activityStat: null,
      activityStatCount: null,
      addresses: fallbackAddresses,
      communications: communications,
      limits: const <PaycoreCustomerLimit>[],
      raw: const <String, dynamic>{},
    );
  }

  void _cacheLocalCustomerAddress({
    required String addressType,
    required String cityName,
    required String townName,
    required String district,
    required String townCode,
    required String cityCode,
    required String postalCode,
    required String address,
  }) {
    _localCustomerAddressOverride = PaycoreCustomerAddress(
      idx: 1,
      addressType: addressType,
      address1: address,
      address2: null,
      city: cityName,
      town: townName,
      cityCode: cityCode,
      townCode: townCode,
      district: district,
      zipCode: postalCode,
      countryCode: 'TR',
      isDefault: true,
    );
  }

  void _mergeLocalAddressIntoCustomerInfo() {
    final localAddress = _localCustomerAddressOverride;
    final customer = _customerInfo;
    if (localAddress == null || customer == null) {
      return;
    }

    final nextAddresses = <PaycoreCustomerAddress>[
      localAddress,
      ...customer.addresses.where(
        (item) => item.addressType != localAddress.addressType,
      ),
    ];

    _customerInfo = PaycoreCustomerInfo(
      bankingCustomerNo: customer.bankingCustomerNo,
      customerNo: customer.customerNo,
      name: customer.name,
      midname: customer.midname,
      surname: customer.surname,
      primaryCardNo: customer.primaryCardNo,
      statCode: customer.statCode,
      commLanguage: customer.commLanguage,
      riskCode: customer.riskCode,
      customerGroupCode: customer.customerGroupCode,
      profession: customer.profession,
      customerEmbossNameExt: customer.customerEmbossNameExt,
      companyName: customer.companyName,
      companyNo: customer.companyNo,
      title: customer.title,
      workPlace: customer.workPlace,
      graduation: customer.graduation,
      disabledType: customer.disabledType,
      guarantor: customer.guarantor,
      guarantorProfession: customer.guarantorProfession,
      branchCode: customer.branchCode,
      digitalSlipType: customer.digitalSlipType,
      lastCardIssuingDate: customer.lastCardIssuingDate,
      firstCreditCardDate: customer.firstCreditCardDate,
      statChangeDate: customer.statChangeDate,
      isGuaranteed: customer.isGuaranteed,
      isBusiness: customer.isBusiness,
      isIdentityPresented: customer.isIdentityPresented,
      hasCar: customer.hasCar,
      hasRealEstate: customer.hasRealEstate,
      isAllowedShareCstInfo: customer.isAllowedShareCstInfo,
      shareCstInfoChgDate: customer.shareCstInfoChgDate,
      gender: customer.gender,
      nationality: customer.nationality,
      nationalIdentityNo: customer.nationalIdentityNo,
      birthDate: customer.birthDate,
      birthPlace: customer.birthPlace,
      identityType: customer.identityType,
      taxNo: customer.taxNo,
      taxDepartmentName: customer.taxDepartmentName,
      fatherName: customer.fatherName,
      motherName: customer.motherName,
      maidenName: customer.maidenName,
      partnerName: customer.partnerName,
      identitySerialNo: customer.identitySerialNo,
      identityIssuedBy: customer.identityIssuedBy,
      identityIssueDate: customer.identityIssueDate,
      identityValidUntil: customer.identityValidUntil,
      identityCityCode: customer.identityCityCode,
      identityTownCode: customer.identityTownCode,
      followUpStat: customer.followUpStat,
      stmtStatCode: customer.stmtStatCode,
      stmtDelinqPeriod: customer.stmtDelinqPeriod,
      nplCount: customer.nplCount,
      minPayCount: customer.minPayCount,
      prevMinPayCount: customer.prevMinPayCount,
      minPayChangeDate: customer.minPayChangeDate,
      minPayDelinq: customer.minPayDelinq,
      firstDelayDate: customer.firstDelayDate,
      lastTxnDate: customer.lastTxnDate,
      activityStat: customer.activityStat,
      activityStatCount: customer.activityStatCount,
      addresses: nextAddresses,
      communications: customer.communications,
      limits: customer.limits,
      raw: customer.raw,
    );
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    NetworkResponse<List<PaycoreCardSummary>>? cardsResponse;
    NetworkResponse<PaycoreCustomerInfo>? customerResponse;
    String? loadError;

    try {
      cardsResponse = await _paycoreService.getMyCards().timeout(_loadTimeout);
    } on TimeoutException {
      loadError = 'Kart listesi zamanında alınamadı.';
    } on Object {
      loadError = 'Kart listesi alınırken beklenmeyen bir hata oluştu.';
    }

    try {
      customerResponse = await _fetchCustomerInfo().timeout(_loadTimeout);
    } on TimeoutException {
      customerResponse = NetworkResponse.fromJson<PaycoreCustomerInfo>(
        <String, dynamic>{
          'isSuccess': false,
          'message': 'Müşteri bilgisi zamanında alınamadı.',
          'data': null,
        },
      );
    } on Object {
      customerResponse = NetworkResponse.fromJson<PaycoreCustomerInfo>(
        <String, dynamic>{
          'isSuccess': false,
          'message': 'Müşteri bilgisi alınırken beklenmeyen bir hata oluştu.',
          'data': null,
        },
      );
    }

    if (!mounted) {
      return;
    }

    if (cardsResponse == null) {
      setState(() {
        _cards = const <PaycoreCardSummary>[];
        _customerInfo = null;
        _hasPaycoreCustomerRecord = false;
        _isLoading = false;
        _loadError = loadError;
      });
      return;
    }

    final cards = cardsResponse.data ?? const <PaycoreCardSummary>[];
    final fallbackCustomerInfo = _buildLocalCustomerInfoFallback();
    final customerInfo = customerResponse.data ?? fallbackCustomerInfo;
    final hasPaycoreCustomerRecord =
        customerResponse.isSuccess && customerResponse.data != null;
    final hasAnyData = cards.isNotEmpty || customerInfo != null;
    final message = cardsResponse.message ?? customerResponse.message;

    if (!hasAnyData &&
        !cardsResponse.isSuccess &&
        !customerResponse.isSuccess) {
      setState(() {
        _isLoading = false;
        _loadError = message ?? 'Kart verisi alınamadı.';
      });
      return;
    }

    setState(() {
      _cards = cards;
      _customerInfo = customerInfo;
      _hasPaycoreCustomerRecord = hasPaycoreCustomerRecord;
      _loadError = null;
      _isLoading = false;
    });

    if (_selectedModule == _PaycoreModule.security && cards.isNotEmpty) {
      unawaited(_preloadPinStatuses());
    }
  }

  Future<void> _preloadPinStatuses() async {
    for (final card in _cards) {
      if (_pinStatuses.containsKey(card.id) ||
          _loadingPinCards.contains(card.id)) {
        continue;
      }
      await _loadPinStatus(card, silent: true);
    }
  }

  Future<void> _loadMetropolCities() async {
    if (_metropolCities.isNotEmpty) {
      return;
    }

    final result = await _getMetropolCitiesUsecase();
    if (!mounted) {
      return;
    }

    result.fold(
      (_) {},
      (cities) {
        setState(() {
          _metropolCities = cities;
        });
      },
    );
  }

  Future<void> _loadPaycoreLocationCodes() async {
    if (_paycoreCityCodes.isNotEmpty) {
      return;
    }

    try {
      final rawJson = await rootBundle.loadString(
        'assets/paycore/paycore-location-codes.json',
      );
      final decoded = jsonDecode(rawJson);
      if (decoded is! List) {
        return;
      }

      final definitions = decoded
          .whereType<Map<String, dynamic>>()
          .map(_PaycoreCityCodeDefinition.fromJson)
          .where((item) => item.city.isNotEmpty && item.cityCode.isNotEmpty)
          .toList();

      if (!mounted || definitions.isEmpty) {
        return;
      }

      setState(() {
        _paycoreCityCodes = definitions;
      });
    } catch (_) {}
  }

  MetropolCity? _findMetropolCity(String? cityName) {
    if (cityName == null || cityName.trim().isEmpty) {
      return null;
    }

    final normalized = cityName.trim().toLowerCase();
    for (final city in _metropolCities) {
      if (city.city.trim().toLowerCase() == normalized) {
        return city;
      }
    }
    return null;
  }

  List<String> _getCountiesForCity(String? cityName) {
    final counties = _findMetropolCity(cityName)?.county ?? const <String>[];
    return _sortLocationLabels(counties);
  }

  String _normalizeLocationKey(String? value) {
    final source = (value ?? '').trim().toLowerCase();
    if (source.isEmpty) {
      return '';
    }

    const replacements = <String, String>{
      'ç': 'c',
      'ğ': 'g',
      'ı': 'i',
      'i̇': 'i',
      'ö': 'o',
      'ş': 's',
      'ü': 'u',
      'â': 'a',
      'î': 'i',
      'û': 'u',
    };

    var normalized = source;
    replacements.forEach((key, replacement) {
      normalized = normalized.replaceAll(key, replacement);
    });

    return normalized.replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
  }

  List<String> _sortLocationLabels(Iterable<String> values) {
    final items = values
        .where((value) => value.trim().isNotEmpty)
        .map((value) => value.trim())
        .toList();

    items.sort((left, right) {
      final normalizedLeft = _normalizeLocationKey(left);
      final normalizedRight = _normalizeLocationKey(right);
      final normalizedCompare = normalizedLeft.compareTo(normalizedRight);
      if (normalizedCompare != 0) {
        return normalizedCompare;
      }

      return left.toLowerCase().compareTo(right.toLowerCase());
    });

    return items;
  }

  _PaycoreCityCodeDefinition? _findPaycoreCity({
    String? cityName,
    String? cityCode,
  }) {
    final normalizedName = _normalizeLocationKey(cityName);
    final normalizedCode = _normalizeLocationKey(cityCode);

    for (final city in _paycoreCityCodes) {
      if (normalizedName.isNotEmpty &&
          _normalizeLocationKey(city.city) == normalizedName) {
        return city;
      }
      if (normalizedCode.isNotEmpty &&
          _normalizeLocationKey(city.cityCode) == normalizedCode) {
        return city;
      }
    }
    return null;
  }

  _PaycoreTownCodeDefinition? _findPaycoreTown(
    _PaycoreCityCodeDefinition? city, {
    String? townName,
    String? townCode,
  }) {
    if (city == null) {
      return null;
    }

    final normalizedName = _normalizeLocationKey(townName);
    final normalizedCode = _normalizeLocationKey(townCode);

    for (final town in city.towns) {
      if (normalizedName.isNotEmpty &&
          _normalizeLocationKey(town.name) == normalizedName) {
        return town;
      }
      if (normalizedCode.isNotEmpty &&
          _normalizeLocationKey(town.code) == normalizedCode) {
        return town;
      }
    }

    return null;
  }

  void _syncPaycoreLocationControllers({
    required TextEditingController cityNameController,
    required TextEditingController townNameController,
    required TextEditingController cityCodeController,
    required TextEditingController townCodeController,
  }) {
    final city = _findPaycoreCity(
      cityName: cityNameController.text,
      cityCode: cityCodeController.text,
    );
    if (city == null) {
      return;
    }

    cityNameController.text = city.city;
    cityCodeController.text = city.cityCode;

    final town = _findPaycoreTown(
      city,
      townName: townNameController.text,
      townCode: townCodeController.text,
    );
    if (town == null) {
      return;
    }

    townNameController.text = town.name;
    townCodeController.text = town.code;
  }

  Widget _buildPaycoreLocationSelectors({
    required StateSetter setSheetState,
    required TextEditingController cityNameController,
    required TextEditingController townNameController,
    required TextEditingController cityCodeController,
    required TextEditingController townCodeController,
  }) {
    if (_paycoreCityCodes.isEmpty) {
      return Column(
        children: [
          _buildCityCountySelectors(
            setSheetState: setSheetState,
            cityNameController: cityNameController,
            townNameController: townNameController,
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: townCodeController,
                  label: 'İlçe kodu',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: cityCodeController,
                  label: 'Şehir kodu',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      );
    }

    final selectedCity = _findPaycoreCity(
      cityName: cityNameController.text,
      cityCode: cityCodeController.text,
    );
    final selectedTown = _findPaycoreTown(
      selectedCity,
      townName: townNameController.text,
      townCode: townCodeController.text,
    );

    return Column(
      children: [
        _buildDropdownField(
          label: 'Şehir adı',
          value: selectedCity?.city,
          items: _sortLocationLabels(
            _paycoreCityCodes.map((city) => city.city),
          ),
          onChanged: (value) {
            setSheetState(() {
              final city = _findPaycoreCity(cityName: value);
              cityNameController.text = city?.city ?? '';
              cityCodeController.text = city?.cityCode ?? '';
              townNameController.clear();
              townCodeController.clear();
            });
          },
        ),
        _buildDropdownField(
          label: 'İlçe adı',
          value: selectedTown?.name,
          items: _sortLocationLabels(
            selectedCity?.towns.map((town) => town.name) ?? const <String>[],
          ),
          enabled: selectedCity != null,
          onChanged: (value) {
            setSheetState(() {
              final town = _findPaycoreTown(selectedCity, townName: value);
              townNameController.text = town?.name ?? '';
              townCodeController.text = town?.code ?? '';
            });
          },
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: townCodeController,
                label: 'İlçe kodu',
                readOnly: true,
                hint: 'İlçe seçince otomatik dolar',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: cityCodeController,
                label: 'Şehir kodu',
                readOnly: true,
                hint: 'Şehir seçince otomatik dolar',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCityCountySelectors({
    required StateSetter setSheetState,
    required TextEditingController cityNameController,
    required TextEditingController townNameController,
  }) {
    final selectedCity = _findMetropolCity(cityNameController.text)?.city;
    final counties = _getCountiesForCity(selectedCity);
    final selectedCounty =
        counties.any(
          (county) =>
              county.trim().toLowerCase() ==
              townNameController.text.trim().toLowerCase(),
        )
        ? townNameController.text
        : null;

    if (_metropolCities.isEmpty) {
      return Column(
        children: [
          _buildTextField(controller: cityNameController, label: 'Şehir adı'),
          _buildTextField(controller: townNameController, label: 'İlçe adı'),
        ],
      );
    }

    return Column(
      children: [
        _buildDropdownField(
          label: 'Şehir adı',
          value: selectedCity,
          items: _sortLocationLabels(
            _metropolCities.map((city) => city.city),
          ),
          onChanged: (value) {
            setSheetState(() {
              cityNameController.text = value ?? '';
              townNameController.clear();
            });
          },
        ),
        _buildDropdownField(
          label: 'İlçe adı',
          value: selectedCounty,
          items: counties,
          onChanged: (value) {
            setSheetState(() {
              townNameController.text = value ?? '';
            });
          },
          enabled: counties.isNotEmpty,
        ),
      ],
    );
  }

  Future<PaycorePinStatus?> _loadPinStatus(
    PaycoreCardSummary card, {
    bool silent = false,
  }) async {
    if (_loadingPinCards.contains(card.id)) {
      return _pinStatuses[card.id];
    }

    if (!silent) {
      setState(() {
        _loadingPinCards.add(card.id);
      });
    } else {
      _loadingPinCards.add(card.id);
    }

    final response = await _paycoreService.getPinStatus(card.id);
    if (!mounted) {
      return null;
    }

    final nextStatuses = Map<int, PaycorePinStatus>.from(_pinStatuses);
    final fallbackPinStatus = card.pin?.trim().isNotEmpty ?? false
        ? PaycorePinStatus(
            pinSetFlag: true,
            lastPinSetDate: null,
            pinValue: card.pin?.trim(),
          )
        : null;

    if (response.isSuccess && response.data != null) {
      nextStatuses[card.id] = response.data!;
    } else if (fallbackPinStatus != null) {
      nextStatuses[card.id] = fallbackPinStatus;
    }

    setState(() {
      _loadingPinCards.remove(card.id);
      _pinStatuses = nextStatuses;
    });

    if (!response.isSuccess || response.data == null) {
      if (fallbackPinStatus != null) {
        return fallbackPinStatus;
      }
      if (!silent) {
        _showError(response.message ?? 'PIN durumu alınamadı.');
      }
      return null;
    }

    return response.data;
  }

  Future<void> _showCustomerInfoSheet() async {
    if (_customerInfo == null) {
      final response = await _fetchCustomerInfo();
      if (!mounted) {
        return;
      }

      final fallbackCustomerInfo = _buildLocalCustomerInfoFallback();
      final nextCustomerInfo = response.data ?? fallbackCustomerInfo;
      if (!response.isSuccess && nextCustomerInfo == null) {
        _showError(response.message ?? 'Müşteri bilgisi alınamadı.');
        return;
      }

      setState(() {
        _customerInfo = nextCustomerInfo;
        _hasPaycoreCustomerRecord = response.isSuccess && response.data != null;
      });
    }

    final customer = _customerInfo ?? _buildLocalCustomerInfoFallback();
    if (customer == null) {
      _showError('Müşteri bilgisi şu anda görüntülenemiyor.');
      return;
    }

    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (pageContext) => Scaffold(
          appBar: AppBar(
            title: const Text('Müşteri Bilgisi'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(pageContext).maybePop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: context.colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                customer.fullName,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  height: 1.15,
                                ),
                              ),
                            ),
                            _buildPrimaryPill(
                              _hasPaycoreCustomerRecord
                                  ? 'Kart Sistemi Aktif'
                                  : 'Yerel Bilgi',
                            ),
                          ],
                        ),
                        if (!_hasPaycoreCustomerRecord) ...[
                          const SizedBox(height: 12),
                          Text(
                            'PayCore servisine anlık erişilemediği için kayıtlı cüzdan bilgileri gösteriliyor.',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.outline,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        _buildInfoGroup('Özet', [
                          ..._buildCustomerInfoRows([
                            ('Ad Soyad', customer.fullName),
                            ('Banking Customer No', customer.bankingCustomerNo),
                            ('Customer No', customer.customerNo),
                            ('Ana Kart', customer.primaryCardNo),
                            ('TC Kimlik No', customer.nationalIdentityNo),
                            ('Cinsiyet', customer.gender),
                            (
                              'Doğum Tarihi',
                              _formatDateValue(customer.birthDate),
                            ),
                            ('Statü', customer.statCode),
                            ('Risk Kodu', customer.riskCode),
                            ('Müşteri Grubu', customer.customerGroupCode),
                            ('İletişim Dili', customer.commLanguage),
                          ]),
                        ]),
                        if (_hasCustomerIdentityInfo(customer)) ...[
                          const SizedBox(height: 12),
                          _buildInfoGroup('Kimlik', [
                            ..._buildCustomerInfoRows([
                              ('Doğum Yeri', customer.birthPlace),
                              ('Uyruk', customer.nationality),
                              ('Kimlik Tipi', customer.identityType),
                              ('Vergi No', customer.taxNo),
                              ('Vergi Dairesi', customer.taxDepartmentName),
                              ('Baba Adı', customer.fatherName),
                              ('Anne Adı', customer.motherName),
                              ('Kızlık Soyadı', customer.maidenName),
                              ('Eş / Partner', customer.partnerName),
                              ('Kimlik Seri No', customer.identitySerialNo),
                              ('Kimlik Veren', customer.identityIssuedBy),
                              (
                                'Kimlik Veriliş',
                                _formatDateValue(customer.identityIssueDate),
                              ),
                              (
                                'Kimlik Geçerlilik',
                                _formatDateValue(customer.identityValidUntil),
                              ),
                              ('Kimlik İl Kodu', customer.identityCityCode),
                              ('Kimlik İlçe Kodu', customer.identityTownCode),
                            ]),
                          ]),
                        ],
                      ],
                    ),
                  ),
                  if (customer.communications.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionTitle('İletişim Bilgileri'),
                    const SizedBox(height: 10),
                    ...customer.communications.map(
                      (item) => _buildSurfaceCard(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              item.communicationType == 'EM'
                                  ? Icons.alternate_email_rounded
                                  : Icons.phone_iphone_rounded,
                              color: context.colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getCommunicationTypeLabel(
                                      item.communicationType,
                                    ),
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                          color: context
                                              .colorScheme
                                              .onSurfaceVariant,
                                          fontSize: 11.5,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.info,
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.isDefault) _buildPrimaryPill('Varsayılan'),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (customer.addresses.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionTitle('Adresler'),
                    const SizedBox(height: 10),
                    ...customer.addresses.map(
                      (address) => _buildSurfaceCard(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _getAddressTypeLabel(address.addressType),
                                    style: context.textTheme.titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                  ),
                                ),
                                if (address.isDefault)
                                  _buildPrimaryPill('Varsayılan'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _buildAddressSummary(address),
                              style: context.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (customer.limits.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionTitle('Limitler'),
                    const SizedBox(height: 10),
                    ...customer.limits.map(
                      (limit) => _buildSurfaceCard(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: _buildTwoColumnInfo(
                          leftLabel: 'Limit',
                          leftValue:
                              '${limit.currentLimit.toStringAsFixed(2)} ₺',
                          rightLabel: 'Durum',
                          rightValue: limit.isLimitBlocked ? 'Blokeli' : 'Açık',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateCustomerSheet() async {
    final customer = _customerInfo;
    final address = customer?.addresses.isNotEmpty ?? false
        ? customer!.addresses.first
        : null;
    const fallbackGender = 'M';
    const fallbackCityName = 'Ankara';
    const fallbackTownName = 'Ankara';
    const fallbackDistrict = 'Çankaya';
    const fallbackTownCode = '06';
    const fallbackCityCode = '06';
    const fallbackPostalCode = '06';
    const fallbackAddress = 'Erpa Plaza, Mustafa Kemal, 2125. Sk. No: 5, 06510';

    final genderController = TextEditingController(
      text: customer?.gender?.trim().isNotEmpty ?? false
          ? customer!.gender!
          : fallbackGender,
    );
    final cityNameController = TextEditingController(
      text: address?.city?.trim().isNotEmpty ?? false
          ? address!.city!
          : fallbackCityName,
    );
    final townNameController = TextEditingController(
      text: address?.town?.trim().isNotEmpty ?? false
          ? address!.town!
          : fallbackTownName,
    );
    final districtController = TextEditingController(
      text: address?.district?.trim().isNotEmpty ?? false
          ? address!.district!
          : fallbackDistrict,
    );
    final townCodeController = TextEditingController(
      text: address?.townCode?.trim().isNotEmpty ?? false
          ? address!.townCode!
          : fallbackTownCode,
    );
    final cityCodeController = TextEditingController(
      text: address?.cityCode?.trim().isNotEmpty ?? false
          ? address!.cityCode!
          : fallbackCityCode,
    );
    final postalCodeController = TextEditingController(
      text: address?.zipCode?.trim().isNotEmpty ?? false
          ? address!.zipCode!
          : fallbackPostalCode,
    );
    final addressController = TextEditingController(
      text: address?.address1.trim().isNotEmpty ?? false
          ? address!.address1
          : fallbackAddress,
    );
    _syncPaycoreLocationControllers(
      cityNameController: cityNameController,
      townNameController: townNameController,
      cityCodeController: cityCodeController,
      townCodeController: townCodeController,
    );
    var isSubmitting = false;
    String? submitError;
    var isCreated = false;
    String? successMessage;

    try {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (pageContext) => StatefulBuilder(
            builder: (modalContext, setSheetState) {
              Future<void> submit() async {
                final gender = genderController.text.trim();
                final cityName = cityNameController.text.trim();
                final townName = townNameController.text.trim();
                final district = districtController.text.trim();
                final townCode = townCodeController.text.trim();
                final cityCode = cityCodeController.text.trim();
                final postalCode = postalCodeController.text.trim();
                final address = addressController.text.trim();

                if ([
                  gender,
                  cityName,
                  townName,
                  district,
                  townCode,
                  cityCode,
                  postalCode,
                  address,
                ].any((value) => value.isEmpty)) {
                  setSheetState(() {
                    submitError = 'Zorunlu alanları doldur.';
                  });
                  return;
                }

                setSheetState(() {
                  isSubmitting = true;
                  submitError = null;
                });

                final response = await _paycoreService.createCustomer(
                  gender: gender,
                  cityName: cityName,
                  townName: townName,
                  district: district,
                  townCode: townCode,
                  cityCode: cityCode,
                  postalCode: postalCode,
                  address: address,
                );

                if (!mounted || !pageContext.mounted) {
                  return;
                }

                setSheetState(() {
                  isSubmitting = false;
                });

                if (!response.isSuccess) {
                  setSheetState(() {
                    submitError = response.message ?? 'Müşteri oluşturulamadı.';
                  });
                  return;
                }

                _cacheLocalCustomerAddress(
                  addressType: 'P',
                  cityName: cityName,
                  townName: townName,
                  district: district,
                  townCode: townCode,
                  cityCode: cityCode,
                  postalCode: postalCode,
                  address: address,
                );
                isCreated = true;
                successMessage =
                    response.message ?? 'Müşteri kaydı oluşturuldu.';
                Navigator.of(pageContext).pop();
              }

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Müşteri Oluştur'),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(pageContext).maybePop(),
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      MediaQuery.of(pageContext).viewInsets.bottom + 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSheetHeader(
                          icon: Icons.person_add_alt_1_rounded,
                          title: 'Müşteri Oluştur',
                          description: '',
                        ),
                        const SizedBox(height: 18),
                        _buildSheetSection(
                          title: 'Temel Bilgiler',
                          child: Column(
                            children: [
                              _buildDropdownField(
                                label: 'Cinsiyet Kodu',
                                items: const ['M', 'F'],
                                value: genderController.text.trim().isEmpty
                                    ? null
                                    : genderController.text.trim(),
                                onChanged: (value) {
                                  setSheetState(() {
                                    genderController.text = value ?? '';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildSheetSection(
                          title: 'Adres Bilgileri',
                          child: Column(
                            children: [
                              _buildPaycoreLocationSelectors(
                                setSheetState: setSheetState,
                                cityNameController: cityNameController,
                                townNameController: townNameController,
                                cityCodeController: cityCodeController,
                                townCodeController: townCodeController,
                              ),
                              _buildTextField(
                                controller: districtController,
                                label: 'Semt / Mahalle',
                              ),
                              _buildTextField(
                                controller: postalCodeController,
                                label: 'Posta Kodu',
                              ),
                              _buildTextField(
                                controller: addressController,
                                label: 'Adres',
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                        if (submitError != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: modalContext.colorScheme.error.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: modalContext.colorScheme.error
                                    .withValues(
                                      alpha: 0.20,
                                    ),
                              ),
                            ),
                            child: Text(
                              submitError!,
                              style: modalContext.textTheme.bodySmall?.copyWith(
                                color: modalContext.colorScheme.error,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: isSubmitting ? null : submit,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                            ),
                            icon: isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.person_add_alt_1_rounded),
                            label: Text(
                              isSubmitting
                                  ? 'Gönderiliyor...'
                                  : 'Müşteri Oluştur',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } finally {
      genderController.dispose();
      cityNameController.dispose();
      townNameController.dispose();
      districtController.dispose();
      townCodeController.dispose();
      cityCodeController.dispose();
      postalCodeController.dispose();
      addressController.dispose();
    }

    if (!mounted || !isCreated) {
      return;
    }

    _showSuccess(successMessage ?? 'Müşteri kaydı oluşturuldu.');
    setState(() {
      _hasPaycoreCustomerRecord = true;
    });
    await _loadData(silent: true);
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedModule = _PaycoreModule.customer;
    });
  }

  Future<void> _showAddressEditSheet(PaycoreCustomerAddress? address) async {
    const fallbackCityName = 'ANKARA';
    const fallbackTownName = 'Ankara';
    const fallbackDistrict = 'Çankaya';
    const fallbackPostalCode = '06';
    const fallbackAddress = 'Erpa Plaza, Mustafa Kemal, 2125. Sk. No: 5, 06510';

    final cityNameController = TextEditingController(
      text: address?.city ?? fallbackCityName,
    );
    final townNameController = TextEditingController(
      text: address?.town ?? fallbackTownName,
    );
    final townCodeController = TextEditingController(
      text: address?.townCode ?? '',
    );
    final cityCodeController = TextEditingController(
      text: address?.cityCode ?? '',
    );
    final districtController = TextEditingController(
      text: address?.district ?? fallbackDistrict,
    );
    final postalCodeController = TextEditingController(
      text: address?.zipCode ?? fallbackPostalCode,
    );
    final addressController = TextEditingController(
      text: [
        address?.address1 ?? fallbackAddress,
        address?.address2,
      ].whereType<String>().where((value) => value.isNotEmpty).join(' '),
    );
    _syncPaycoreLocationControllers(
      cityNameController: cityNameController,
      townNameController: townNameController,
      cityCodeController: cityCodeController,
      townCodeController: townCodeController,
    );
    var isSubmitting = false;
    var isUpdated = false;
    String? successMessage;

    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (modalContext, setSheetState) {
              Future<void> submit() async {
                final cityName = cityNameController.text.trim();
                final townName = townNameController.text.trim();
                final district = districtController.text.trim();
                final townCode = townCodeController.text.trim();
                final cityCode = cityCodeController.text.trim();
                final postalCode = postalCodeController.text.trim();
                final addressValue = addressController.text.trim();

                if ([
                  cityName,
                  townName,
                  district,
                  townCode,
                  cityCode,
                  postalCode,
                  addressValue,
                ].any((value) => value.isEmpty)) {
                  _showError('Zorunlu alanları doldur.');
                  return;
                }

                setSheetState(() {
                  isSubmitting = true;
                });

                final response = await _paycoreService.updateCustomerAddress(
                  cityName: cityName,
                  townName: townName,
                  district: district,
                  townCode: townCode,
                  cityCode: cityCode,
                  postalCode: postalCode,
                  address: addressValue,
                );

                if (!mounted || !sheetContext.mounted) {
                  return;
                }

                setSheetState(() {
                  isSubmitting = false;
                });

                if (!response.isSuccess) {
                  _showError(response.message ?? 'Adres güncellenemedi.');
                  return;
                }

                _cacheLocalCustomerAddress(
                  addressType: address?.addressType ?? 'D',
                  cityName: cityName,
                  townName: townName,
                  district: district,
                  townCode: townCode,
                  cityCode: cityCode,
                  postalCode: postalCode,
                  address: addressValue,
                );
                setState(() {
                  _mergeLocalAddressIntoCustomerInfo();
                });
                isUpdated = true;
                successMessage = response.message ?? 'Adres güncellendi.';
                Navigator.of(sheetContext).pop();
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSheetHeader(
                      icon: Icons.edit_location_alt_rounded,
                      title: address == null
                          ? 'Teslimat Adresi'
                          : 'Adres Güncelle',
                      description: address == null
                          ? 'Müşteri kaydı bulundu. Kart üretimi için teslimat adresini tamamla ve PayCore ile senkronize et.'
                          : 'Kart üretimi için kullanılan adres bilgilerini güncelle ve PayCore ile senkronize et.',
                    ),
                    const SizedBox(height: 18),
                    _buildSheetSection(
                      title: 'Adres Bilgileri',
                      description:
                          'İl ve ilçe PayCore listesinden seçilir. Kod alanları otomatik eşleşir; elle il kodu girilmez.',
                      child: Column(
                        children: [
                          _buildPaycoreLocationSelectors(
                            setSheetState: setSheetState,
                            cityNameController: cityNameController,
                            townNameController: townNameController,
                            cityCodeController: cityCodeController,
                            townCodeController: townCodeController,
                          ),
                          _buildTextField(
                            controller: districtController,
                            label: 'Semt / Mahalle',
                          ),
                          _buildTextField(
                            controller: postalCodeController,
                            label: 'Posta Kodu',
                          ),
                          _buildTextField(
                            controller: addressController,
                            label: 'Adres',
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isSubmitting ? null : submit,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        icon: isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.edit_location_alt_rounded),
                        label: Text(
                          isSubmitting ? 'Kaydediliyor...' : 'Adresi Güncelle',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } finally {
      cityNameController.dispose();
      townNameController.dispose();
      townCodeController.dispose();
      cityCodeController.dispose();
      districtController.dispose();
      postalCodeController.dispose();
      addressController.dispose();
    }

    if (!mounted || !isUpdated) {
      return;
    }

    _showSuccess(successMessage ?? 'Adres güncellendi.');
    await _loadData(silent: true);
    if (!mounted) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
    if (!mounted) {
      return;
    }
    await _showCustomerInfoSheet();
  }

  Future<void> _showCreateCardSheet() async {
    final effectiveCustomerInfo =
        _customerInfo ?? _buildLocalCustomerInfoFallback();
    if (effectiveCustomerInfo == null) {
      _showError('Önce müşteri kaydını oluştur ya da bilgileri yenile.');
      return;
    }

    if (!identical(effectiveCustomerInfo, _customerInfo)) {
      _customerInfo = effectiveCustomerInfo;
    }

    final address = _resolvedCreateCardAddress;
    if (address == null) {
      _showError(
        'Kart oluşturmak için kayıtlı müşteri adresi gerekli. Önce adresi güncelle.',
      );
      return;
    }

    final cityNameController = TextEditingController(text: address.cityName);
    final townNameController = TextEditingController(text: address.townName);
    final cityCodeController = TextEditingController(text: address.cityCode);
    final townCodeController = TextEditingController(text: address.townCode);
    final districtController = TextEditingController(text: address.district);
    final zipCodeController = TextEditingController(
      text: address.zipCode ?? '',
    );
    final address1Controller = TextEditingController(text: address.address1);
    final address2Controller = TextEditingController(
      text: _normalizeSecondaryAddressLine(address.address2) ?? '',
    );
    _syncPaycoreLocationControllers(
      cityNameController: cityNameController,
      townNameController: townNameController,
      cityCodeController: cityCodeController,
      townCodeController: townCodeController,
    );

    var isSubmitting = false;
    var selectedProfile = PaycoreCardCreationProfile.troyPhysical;

    try {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (pageContext) => StatefulBuilder(
            builder: (modalContext, setSheetState) {
              Future<void> submit() async {
                final cityName = cityNameController.text.trim();
                final townName = townNameController.text.trim();
                final cityCode = cityCodeController.text.trim();
                final townCode = townCodeController.text.trim();
                final district = districtController.text.trim();
                final zipCode = zipCodeController.text.trim();
                final address1 = address1Controller.text.trim();
                final address2 = _normalizeSecondaryAddressLine(
                  address2Controller.text,
                );

                if (selectedProfile ==
                    PaycoreCardCreationProfile.masterVirtual) {
                  _showError(
                    'Master sanal kart ürünü bu ortamda tanımlı değil. Şimdilik Troy sanal veya Master fiziki kullanın.',
                  );
                  return;
                }

                if ([
                  cityName,
                  townName,
                  cityCode,
                  townCode,
                  district,
                  address1,
                ].any((value) => value.isEmpty)) {
                  _showError(
                    'Kart oluşturmak için zorunlu PayCore alanlarını tamamlayın.',
                  );
                  return;
                }

                setSheetState(() {
                  isSubmitting = true;
                });

                final response = await _paycoreService.createPrepaidCard(
                  cardProfile: selectedProfile,
                  cityCode: cityCode,
                  cityName: cityName,
                  townCode: townCode,
                  townName: townName,
                  district: district,
                  address1: address1,
                  address2: address2,
                  zipCode: zipCode.isEmpty ? null : zipCode,
                );

                if (!mounted || !pageContext.mounted) {
                  return;
                }

                setSheetState(() {
                  isSubmitting = false;
                });

                if (!response.isSuccess) {
                  _showError(_buildCreateCardErrorMessage(response.message));
                  return;
                }

                Navigator.of(pageContext).pop();
                _showSuccess(_buildCreateCardSuccessMessage(response));
                await _loadData(silent: true);
                setState(() {
                  _selectedModule = _PaycoreModule.cards;
                });
              }

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Yeni Kart Açılışı'),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(pageContext).maybePop(),
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      MediaQuery.of(pageContext).viewInsets.bottom + 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSheetHeader(
                          icon: Icons.add_card_rounded,
                          title: 'Yeni Kart Açılışı',
                          description:
                              'Kart tipini seç, teslimat bilgilerini kontrol et ve fiziksel ya da sanal kart üretimini başlat.',
                        ),
                        const SizedBox(height: 18),
                        _buildSheetSection(
                          title: 'Kart Bilgileri',
                          description:
                              'Kart profili seçin ve teslimat adresini eksiksiz girin.',
                          child: Column(
                            children: [
                              _buildDropdownField(
                                label: 'Kart profili',
                                value: selectedProfile.title,
                                items: _availableCardProfiles
                                    .map((profile) => profile.title)
                                    .toList(),
                                onChanged: (value) {
                                  final nextProfile = _availableCardProfiles
                                      .firstWhere(
                                        (profile) => profile.title == value,
                                        orElse: () => PaycoreCardCreationProfile
                                            .troyPhysical,
                                      );
                                  setSheetState(() {
                                    selectedProfile = nextProfile;
                                  });
                                },
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    selectedProfile.description,
                                    style: modalContext.textTheme.bodySmall
                                        ?.copyWith(
                                          color: modalContext
                                              .colorScheme
                                              .onSurfaceVariant,
                                          height: 1.4,
                                        ),
                                  ),
                                ),
                              ),
                              _buildPaycoreLocationSelectors(
                                setSheetState: setSheetState,
                                cityNameController: cityNameController,
                                townNameController: townNameController,
                                cityCodeController: cityCodeController,
                                townCodeController: townCodeController,
                              ),
                              _buildTextField(
                                controller: districtController,
                                label: 'Semt / Mahalle',
                              ),
                              _buildTextField(
                                controller: zipCodeController,
                                label: 'Posta Kodu',
                              ),
                              _buildTextField(
                                controller: address1Controller,
                                label: 'Teslimat adresi',
                              ),
                              _buildTextField(
                                controller: address2Controller,
                                label: 'Adres satırı 2',
                                hint: 'Apartman, blok, kat vb. (opsiyonel)',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: isSubmitting ? null : submit,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                            ),
                            icon: isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.add_card_rounded),
                            label: Text(
                              isSubmitting ? 'Gönderiliyor...' : 'Kart Oluştur',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } finally {
      cityNameController.dispose();
      townNameController.dispose();
      cityCodeController.dispose();
      townCodeController.dispose();
      districtController.dispose();
      zipCodeController.dispose();
      address1Controller.dispose();
      address2Controller.dispose();
    }
  }

  Future<void> _handleCreateCardPressed() async {
    var customer = _customerInfo;
    var hasPaycoreCustomerRecord = _hasPaycoreCustomerRecord;

    if (customer == null) {
      final response = await _fetchCustomerInfo();
      if (!mounted) {
        return;
      }

      final fallbackCustomerInfo = _buildLocalCustomerInfoFallback();
      final resolvedCustomer = response.data ?? fallbackCustomerInfo;

      if (resolvedCustomer != null) {
        setState(() {
          _customerInfo = resolvedCustomer;
          _hasPaycoreCustomerRecord =
              response.isSuccess && response.data != null;
        });
        customer = resolvedCustomer;
        hasPaycoreCustomerRecord = response.isSuccess && response.data != null;
      }
    }

    if (!hasPaycoreCustomerRecord) {
      _showError('Önce müşteri kaydını oluşturman gerekiyor.');
      await _showCreateCustomerSheet();
      return;
    }

    if (_resolvedCreateCardAddress != null) {
      await _showCreateCardSheet();
      return;
    }

    final customerAddresses =
        customer?.addresses ?? const <PaycoreCustomerAddress>[];
    final editableAddress = customerAddresses.isNotEmpty
        ? customerAddresses.first
        : null;

    if (editableAddress != null) {
      _showError(
        'Kart oluşturmak için adres bilgisini tamamlaman gerekiyor.',
      );
      await _showAddressEditSheet(editableAddress);
      return;
    }

    _showError('Kart oluşturmak için teslimat adresini tamamla.');
    await _showAddressEditSheet(null);
  }

  Future<void> _handleAddPhysicalCardPressed() async {
    if (_customerInfo == null || !_hasPaycoreCustomerRecord) {
      final response = await _fetchCustomerInfo();
      if (!mounted) {
        return;
      }

      final fallbackCustomerInfo = _buildLocalCustomerInfoFallback();
      final resolvedCustomer = response.data ?? fallbackCustomerInfo;

      if (resolvedCustomer != null) {
        setState(() {
          _customerInfo = resolvedCustomer;
          _hasPaycoreCustomerRecord =
              response.isSuccess && response.data != null;
        });
      }
    }

    final cardInput = await _showPhysicalCardInfoSheet();
    if (!mounted || cardInput == null) {
      return;
    }

    _PhysicalCardCustomerPayload? customerPayload;
    if (!_hasPaycoreCustomerRecord) {
      customerPayload = await _showPhysicalCardCustomerSetupSheet();
      if (!mounted || customerPayload == null) {
        return;
      }
    }

    var otpProcessCode = await _sendPhysicalCardOtp(
      cardInput: cardInput,
      customerPayload: customerPayload,
    );
    if (!mounted || otpProcessCode == null) {
      return;
    }

    final isVerified = await _showPhysicalCardOtpSheet(
      cardInput: cardInput,
      customerPayload: customerPayload,
      initialProcessCode: otpProcessCode,
      onResend: () async {
        final nextProcessCode = await _sendPhysicalCardOtp(
          cardInput: cardInput,
          customerPayload: customerPayload,
          successMessage: 'Yeni doğrulama kodu gönderildi.',
          errorMessage: 'Doğrulama kodu tekrar gönderilemedi.',
        );
        if (nextProcessCode != null) {
          otpProcessCode = nextProcessCode;
        }
        return nextProcessCode;
      },
    );

    if (!mounted || !isVerified) {
      return;
    }

    if (customerPayload != null) {
      _cacheLocalCustomerAddress(
        addressType: 'P',
        cityName: customerPayload.cityName,
        townName: customerPayload.townName,
        district: customerPayload.district,
        townCode: customerPayload.townCode,
        cityCode: customerPayload.cityCode,
        postalCode: customerPayload.postalCode,
        address: customerPayload.address,
      );
      setState(() {
        _hasPaycoreCustomerRecord = true;
        _mergeLocalAddressIntoCustomerInfo();
      });
    }

    await _loadData();
    if (!mounted) {
      return;
    }

    if (widget.openActivateTab) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const PaycoreCardsScreen(),
        ),
      );
      return;
    }

    setState(() {
      _selectedModule = _PaycoreModule.cards;
    });
  }

  Future<_PhysicalCardInput?> _showPhysicalCardInfoSheet() async {
    final cardNoController = TextEditingController();
    final barcodeNoController = TextEditingController();
    _PhysicalCardInput? result;

    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (modalContext, setSheetState) {
              Future<void> submit() async {
                final cardNo = _normalizeCardDigits(cardNoController.text);
                final barcodeNo = barcodeNoController.text.trim();

                if (cardNo == null && barcodeNo.isEmpty) {
                  _showError('Kart numarası veya barkod numarası girin.');
                  return;
                }

                if (cardNo != null &&
                    (cardNo.length < 12 || cardNo.length > 19)) {
                  _showError('Kart numarası 12-19 haneli olmalıdır.');
                  return;
                }

                result = _PhysicalCardInput(
                  cardNo: cardNo,
                  barcodeNo: barcodeNo.isEmpty ? null : barcodeNo,
                );
                Navigator.of(sheetContext).pop();
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSheetHeader(
                      icon: Icons.add_card_rounded,
                      title: 'Kart Bilgileri',
                      description:
                          'Önce fiziksel kart numarasını veya barkod numarasını gir. Devamında gerekirse müşteri kaydı ve SMS doğrulama adımı açılacak.',
                    ),
                    const SizedBox(height: 18),
                    _buildSheetSection(
                      title: 'Kart Bilgileri',
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: cardNoController,
                            label: 'Kart Numarası',
                            hint: '12-19 haneli maskesiz kart numarası',
                            required: false,
                            keyboardType: TextInputType.number,
                          ),
                          _buildTextField(
                            controller: barcodeNoController,
                            label: 'Barkod Numarası',
                            hint: 'Kart üzerindeki barkod numarası',
                            required: false,
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: submit,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Devam Et'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } finally {
      cardNoController.dispose();
      barcodeNoController.dispose();
    }

    return result;
  }

  Future<_PhysicalCardCustomerPayload?>
  _showPhysicalCardCustomerSetupSheet() async {
    final effectiveCustomerInfo =
        _customerInfo ?? _buildLocalCustomerInfoFallback();
    final customerAddress = effectiveCustomerInfo?.addresses.isNotEmpty ?? false
        ? effectiveCustomerInfo!.addresses.first
        : null;
    const fallbackGender = 'M';
    const fallbackCityName = 'Ankara';
    const fallbackTownName = 'Ankara';
    const fallbackDistrict = 'Çankaya';
    const fallbackTownCode = '06';
    const fallbackCityCode = '06';
    const fallbackPostalCode = '06';
    const fallbackAddress = 'Erpa Plaza, Mustafa Kemal, 2125. Sk. No: 5, 06510';

    final genderController = TextEditingController(
      text: effectiveCustomerInfo?.gender?.trim().isNotEmpty ?? false
          ? effectiveCustomerInfo!.gender!
          : fallbackGender,
    );
    final cityNameController = TextEditingController(
      text: customerAddress?.city?.trim().isNotEmpty ?? false
          ? customerAddress!.city!
          : fallbackCityName,
    );
    final townNameController = TextEditingController(
      text: customerAddress?.town?.trim().isNotEmpty ?? false
          ? customerAddress!.town!
          : fallbackTownName,
    );
    final districtController = TextEditingController(
      text: customerAddress?.district?.trim().isNotEmpty ?? false
          ? customerAddress!.district!
          : fallbackDistrict,
    );
    final townCodeController = TextEditingController(
      text: customerAddress?.townCode?.trim().isNotEmpty ?? false
          ? customerAddress!.townCode!
          : fallbackTownCode,
    );
    final cityCodeController = TextEditingController(
      text: customerAddress?.cityCode?.trim().isNotEmpty ?? false
          ? customerAddress!.cityCode!
          : fallbackCityCode,
    );
    final postalCodeController = TextEditingController(
      text: customerAddress?.zipCode?.trim().isNotEmpty ?? false
          ? customerAddress!.zipCode!
          : fallbackPostalCode,
    );
    final addressController = TextEditingController(
      text:
          [
                customerAddress?.address1,
                _normalizeSecondaryAddressLine(customerAddress?.address2),
              ]
              .whereType<String>()
              .where((value) => value.isNotEmpty)
              .join(' ')
              .isNotEmpty
          ? [
              customerAddress?.address1,
              _normalizeSecondaryAddressLine(customerAddress?.address2),
            ].whereType<String>().where((value) => value.isNotEmpty).join(' ')
          : fallbackAddress,
    );
    _syncPaycoreLocationControllers(
      cityNameController: cityNameController,
      townNameController: townNameController,
      cityCodeController: cityCodeController,
      townCodeController: townCodeController,
    );
    _PhysicalCardCustomerPayload? result;

    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (modalContext, setSheetState) {
              Future<void> submit() async {
                final gender = genderController.text.trim();
                final cityName = cityNameController.text.trim();
                final townName = townNameController.text.trim();
                final district = districtController.text.trim();
                final townCode = townCodeController.text.trim();
                final cityCode = cityCodeController.text.trim();
                final postalCode = postalCodeController.text.trim();
                final address = addressController.text.trim();

                if ([
                  gender,
                  cityName,
                  townName,
                  district,
                  townCode,
                  cityCode,
                  postalCode,
                  address,
                ].any((value) => value.isEmpty)) {
                  _showError(
                    'PayCore müşteri kaydı için zorunlu alanları tamamlayın.',
                  );
                  return;
                }

                result = _PhysicalCardCustomerPayload(
                  gender: gender,
                  cityName: cityName,
                  townName: townName,
                  district: district,
                  townCode: townCode,
                  cityCode: cityCode,
                  postalCode: postalCode,
                  address: address,
                );
                Navigator.of(sheetContext).pop();
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSheetHeader(
                      icon: Icons.add_card_rounded,
                      title: 'Müşteri Kaydı',
                      description:
                          'Bu kullanıcı için PayCore müşteri kaydı bulunamadı. Devam edebilmek için müşteri bilgilerini bir kez onayla.',
                    ),
                    const SizedBox(height: 18),
                    _buildSheetSection(
                      title: 'Müşteri Bilgileri',
                      description:
                          'Kart aktivasyonundan önce müşteri kaydı oluşturulacak.',
                      child: Column(
                        children: [
                          _buildDropdownField(
                            label: 'Cinsiyet Kodu',
                            items: const ['M', 'F'],
                            value: genderController.text.trim().isEmpty
                                ? null
                                : genderController.text.trim(),
                            onChanged: (value) {
                              setSheetState(() {
                                genderController.text = value ?? '';
                              });
                            },
                          ),
                          _buildPaycoreLocationSelectors(
                            setSheetState: setSheetState,
                            cityNameController: cityNameController,
                            townNameController: townNameController,
                            cityCodeController: cityCodeController,
                            townCodeController: townCodeController,
                          ),
                          _buildTextField(
                            controller: districtController,
                            label: 'Semt / Mahalle',
                          ),
                          _buildTextField(
                            controller: postalCodeController,
                            label: 'Posta Kodu',
                          ),
                          _buildTextField(
                            controller: addressController,
                            label: 'Adres',
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: submit,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Devam Et'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } finally {
      genderController.dispose();
      cityNameController.dispose();
      townNameController.dispose();
      districtController.dispose();
      townCodeController.dispose();
      cityCodeController.dispose();
      postalCodeController.dispose();
      addressController.dispose();
    }

    return result;
  }

  Future<String?> _sendPhysicalCardOtp({
    required _PhysicalCardInput cardInput,
    _PhysicalCardCustomerPayload? customerPayload,
    String? successMessage,
    String? errorMessage,
  }) async {
    final otpResponse = await _paycoreService.sendAddPhysicalCardOtp(
      cardNo: cardInput.cardNo,
      barcodeNo: cardInput.barcodeNo,
      gender: customerPayload?.gender,
      cityName: customerPayload?.cityName,
      townName: customerPayload?.townName,
      district: customerPayload?.district,
      townCode: customerPayload?.townCode,
      cityCode: customerPayload?.cityCode,
      postalCode: customerPayload?.postalCode,
      address: customerPayload?.address,
    );

    if (!mounted) {
      return null;
    }

    if (!otpResponse.isSuccess || otpResponse.data == null) {
      _showError(
        errorMessage ?? otpResponse.message ?? 'Doğrulama kodu gönderilemedi.',
      );
      return null;
    }

    _showSuccess(
      successMessage ??
          otpResponse.message ??
          'Doğrulama kodu SMS olarak gönderildi.',
    );
    return otpResponse.data;
  }

  Future<bool> _showPhysicalCardOtpSheet({
    required _PhysicalCardInput cardInput,
    required String initialProcessCode,
    required Future<String?> Function() onResend,
    _PhysicalCardCustomerPayload? customerPayload,
  }) async {
    final verificationCodeController = TextEditingController();
    var isSubmitting = false;
    var processCode = initialProcessCode;
    var isVerified = false;

    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (modalContext, setSheetState) {
              Future<void> submit() async {
                final verificationCode = verificationCodeController.text.trim();
                if (verificationCode.isEmpty) {
                  _showError('SMS ile gelen doğrulama kodunu girin.');
                  return;
                }

                setSheetState(() {
                  isSubmitting = true;
                });

                final response = await _paycoreService
                    .confirmAddPhysicalCardOtp(
                      processCode: processCode,
                      code: verificationCode,
                    );

                if (!mounted || !sheetContext.mounted) {
                  return;
                }

                setSheetState(() {
                  isSubmitting = false;
                });

                if (!response.isSuccess) {
                  _showError(response.message ?? 'Fiziksel kart eklenemedi.');
                  return;
                }

                isVerified = true;
                Navigator.of(sheetContext).pop();
                _showSuccess(
                  response.message ?? 'Fiziksel kart hesabına eklendi.',
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSheetHeader(
                      icon: Icons.sms_outlined,
                      title: 'SMS Doğrulama',
                      description:
                          'Kart eşleştirmeyi tamamlamak için telefonuna gelen tek kullanımlık kodu gir.',
                    ),
                    const SizedBox(height: 18),
                    _buildSheetSection(
                      title: 'Kart Özeti',
                      description: customerPayload == null
                          ? 'Müşteri kaydı mevcut. Kod doğrulandıktan sonra kart hesabına eklenecek.'
                          : 'Kod doğrulandıktan sonra önce müşteri kaydı, ardından kart eşleştirme tamamlanacak.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            'Kart Numarası',
                            cardInput.cardNo ?? '-',
                          ),
                          if (cardInput.barcodeNo != null)
                            _buildInfoRow(
                              'Barkod Numarası',
                              cardInput.barcodeNo ?? '-',
                            ),
                          _buildTextField(
                            controller: verificationCodeController,
                            label: 'Doğrulama Kodu',
                            hint: 'SMS ile gelen kod',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                final nextProcessCode = await onResend();
                                if (nextProcessCode != null && mounted) {
                                  setSheetState(() {
                                    processCode = nextProcessCode;
                                  });
                                }
                              },
                        child: const Text('Kodu Tekrar Gönder'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isSubmitting ? null : submit,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        icon: isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.verified_user_outlined),
                        label: Text(
                          isSubmitting
                              ? 'Doğrulanıyor...'
                              : 'Kodu Doğrula ve Kartı Ekle',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } finally {
      verificationCodeController.dispose();
    }

    return isVerified;
  }

  Future<void> _showCardDetailSheet(PaycoreCardSummary card) async {
    final pinStatus =
        _pinStatuses[card.id] ?? await _loadPinStatus(card, silent: true);
    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: FractionallySizedBox(
          heightFactor: 0.82,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Kart Detayı',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Kapat',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardProductPreview(card),
                        const SizedBox(height: 20),
                        _buildInfoGroup(
                          'Kart',
                          [
                            _buildInfoRow('Maskeli Kart', card.maskedCardNo),
                            _buildInfoRow('Profil', card.profileLabel),
                            _buildInfoRow('Kart Modu', card.cardModeLabel),
                            _buildInfoRow('Ürün Kodu', card.productCode ?? '-'),
                            _buildInfoRow('Kart Tipi', card.cardTypeName),
                            _buildInfoRow('Durum', card.statusName),
                            _buildInfoRow(
                              'Son Kullanma',
                              _cardExpiryLabel(card.expiryDate),
                            ),
                            _buildInfoRow(
                              'CVV',
                              _displayCardCvv(
                                card,
                                reveal: _cvvPeekCards.contains(card.id),
                              ),
                            ),
                            _buildInfoRow(
                              'Ana Kart',
                              card.isPrimary ? 'Evet' : 'Hayır',
                            ),
                            _buildInfoRow(
                              'Aktiflik',
                              card.isActive ? 'Aktif' : 'Pasif',
                            ),
                            _buildInfoRow(
                              'Kart Sahibi',
                              _displayCardHolder(card),
                            ),
                            _buildInfoRow(
                              'PIN Durumu',
                              pinStatus == null
                                  ? 'Henüz sorgulanmadı'
                                  : (pinStatus.pinSetFlag
                                        ? 'PIN Tanımlı'
                                        : 'PIN Tanımsız'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: card.isPrimary
                            ? null
                            : () => unawaited(
                                _runCardAction(
                                  card,
                                  () => _setPrimaryCard(card),
                                ),
                              ),
                        icon: const Icon(Icons.workspace_premium_outlined),
                        label: Text(
                          card.isPrimary ? 'Ana Kart' : 'Ana Kart Ata',
                        ),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => unawaited(_showSetPinSheet(card)),
                        icon: const Icon(Icons.pin_outlined),
                        label: Text(
                          (pinStatus?.pinSetFlag ?? false)
                              ? 'PIN Güncelle'
                              : 'PIN Oluştur',
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => unawaited(_showQrPaymentOptions(card)),
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    label: const Text('QR ile Öde / Para Çek'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                    ),
                  ),
                ),
                if (card.isActive && card.statusCode != 'I') ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => unawaited(
                        _runCardAction(card, () => _cancelCard(card)),
                      ),
                      icon: const Icon(Icons.block_outlined),
                      label: const Text('Kartı İptal Et'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFB3261E),
                        side: const BorderSide(color: Color(0xFFB3261E)),
                        minimumSize: const Size.fromHeight(54),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPinStatusSheet(PaycoreCardSummary card) async {
    final cachedPinStatus = _pinStatuses[card.id];
    final pinStatus = await _loadPinStatus(
      card,
      silent: cachedPinStatus != null,
    );
    if (!mounted) {
      return;
    }

    final effectivePinStatus = pinStatus ?? cachedPinStatus;
    if (effectivePinStatus == null) {
      _showError('PIN durumu şu anda alınamadı. Lütfen tekrar deneyin.');
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PIN Durumu',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Kart', card.maskedCardNo),
              _buildInfoRow(
                'Durum',
                effectivePinStatus.pinSetFlag ? 'PIN Tanımlı' : 'PIN Tanımsız',
              ),
              if (effectivePinStatus.pinValue?.trim().isNotEmpty ?? false)
                _buildInfoRow('PIN', effectivePinStatus.pinValue!.trim()),
              _buildInfoRow(
                'Son PIN Tarihi',
                _formatDateTime(effectivePinStatus.lastPinSetDate),
              ),
              if (pinStatus == null && cachedPinStatus != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Güncel PayCore yanıtı alınamadığı için son sorgulanan durum gösteriliyor.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardProductPreview(PaycoreCardSummary card) {
    final frontAsset = PaycoreCardAssetConstants.frontForSummary(card);
    final backAsset = PaycoreCardAssetConstants.backForSummary(card);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildCardProductImage(
            label: 'Ön Yüz',
            assetPath: frontAsset,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildCardProductImage(
            label: 'Arka Yüz',
            assetPath: backAsset,
          ),
        ),
      ],
    );
  }

  Widget _buildCardProductImage({
    required String label,
    required String assetPath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1.586,
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePreview(PaycoreCardCreationProfile profile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1.586,
        child: Image.asset(
          PaycoreCardAssetConstants.frontForProfile(profile),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> _showSetPinSheet(PaycoreCardSummary card) async {
    final resolvedFullCardNo = _resolvedFullCardNo(card);
    final pinStatus = _pinStatuses[card.id];
    final requiresCurrentPin = pinStatus?.pinSetFlag ?? false;
    final actionLabel = requiresCurrentPin ? 'PIN Güncelle' : 'PIN Oluştur';
    final fullCardNoController = TextEditingController(
      text: resolvedFullCardNo ?? '',
    );
    final currentPinController = TextEditingController();
    final pinController = TextEditingController();
    final pinRepeatController = TextEditingController();
    var isSubmitting = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 8,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
        ),
        child: StatefulBuilder(
          builder: (modalContext, setSheetState) {
            Future<void> submit() async {
              final fullCardNo = fullCardNoController.text
                  .replaceAll(RegExp('[^0-9]'), '')
                  .trim();
              final pin = pinController.text.trim();
              final repeatedPin = pinRepeatController.text.trim();
              final currentPin = currentPinController.text.trim();

              if (fullCardNo.length < 12 || int.tryParse(fullCardNo) == null) {
                _showError('Kart numarasını maskesiz girin.');
                return;
              }

              if (requiresCurrentPin &&
                  (currentPin.length < 4 ||
                      currentPin.length > 6 ||
                      int.tryParse(currentPin) == null)) {
                _showError('Mevcut PIN 4-6 haneli sayısal olmalı.');
                return;
              }

              if (pin.length < 4 ||
                  pin.length > 6 ||
                  int.tryParse(pin) == null) {
                _showError('PIN 4-6 haneli sayısal olmalı.');
                return;
              }

              if (pin != repeatedPin) {
                _showError('PIN tekrarı eşleşmiyor.');
                return;
              }

              setSheetState(() {
                isSubmitting = true;
              });

              final response = await _paycoreService.setPin(
                card.id,
                pin,
                cardNo: fullCardNo,
                currentPin: requiresCurrentPin ? currentPin : null,
              );

              if (!mounted || !sheetContext.mounted) {
                return;
              }

              setSheetState(() {
                isSubmitting = false;
              });

              if (!response.isSuccess) {
                final message = response.message ?? 'PIN set edilemedi.';
                if (message.toLowerCase().contains('yetki') ||
                    message.toLowerCase().contains('unauthorized')) {
                  _showError(
                    '$message Kart numarasının doğru olduğunu kontrol edin.',
                  );
                  return;
                }
                _showError(message);
                return;
              }

              Navigator.of(sheetContext).pop();
              if (!mounted) {
                return;
              }
              _showSuccess(response.message ?? 'PIN set işlemi gönderildi.');
              unawaited(_loadPinStatus(card));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel,
                    style: modalContext.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resolvedFullCardNo ?? card.maskedCardNo,
                    style: modalContext.textTheme.bodyMedium?.copyWith(
                      color: modalContext.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: fullCardNoController,
                    label: 'Kart Numarası',
                    hint: 'Maskesiz kart numarasını girin',
                    keyboardType: TextInputType.number,
                  ),
                  if (requiresCurrentPin)
                    _buildTextField(
                      controller: currentPinController,
                      label: 'Mevcut PIN',
                      hint: '4-6 hane',
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  _buildTextField(
                    controller: pinController,
                    label: 'Yeni PIN',
                    hint: '4-6 hane',
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                  _buildTextField(
                    controller: pinRepeatController,
                    label: 'PIN Tekrar',
                    hint: 'Aynı PIN',
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isSubmitting ? null : submit,
                      icon: isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.lock_rounded),
                      label: Text(
                        isSubmitting ? 'Gönderiliyor...' : actionLabel,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    fullCardNoController.dispose();
    currentPinController.dispose();
    pinController.dispose();
    pinRepeatController.dispose();
  }

  Future<void> _showRandomPinSheet(PaycoreCardSummary card) async {
    final resolvedFullCardNo = _resolvedFullCardNo(card);
    final fullCardNoController = TextEditingController(
      text: resolvedFullCardNo ?? '',
    );
    var sendBySms = false;
    var isSubmitting = false;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: StatefulBuilder(
          builder: (modalContext, setSheetState) {
            Future<void> submit() async {
              final fullCardNo = fullCardNoController.text
                  .replaceAll(RegExp('[^0-9]'), '')
                  .trim();

              if (fullCardNo.length < 12 || int.tryParse(fullCardNo) == null) {
                _showError('Gercek kart numarasini maskesiz girin.');
                return;
              }

              setSheetState(() {
                isSubmitting = true;
              });

              final error = await _setRandomPin(
                card,
                cardNo: fullCardNo,
                isSendPinBySms: sendBySms,
              );

              if (!mounted || !sheetContext.mounted) {
                return;
              }

              setSheetState(() {
                isSubmitting = false;
              });

              if (error != null) {
                _showError(error);
                return;
              }

              Navigator.of(sheetContext).pop();
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Random PIN',
                    style: modalContext.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resolvedFullCardNo ?? card.maskedCardNo,
                    style: modalContext.textTheme.bodyMedium?.copyWith(
                      color: modalContext.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: fullCardNoController,
                    label: 'Gercek Kart Numarasi',
                    hint: 'Maskesiz kart numarasini girin',
                    keyboardType: TextInputType.number,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('PIN SMS ile gönderilsin'),
                    subtitle: const Text(
                      'Random PIN üretilirse müşteriye SMS ile gönderilir.',
                    ),
                    value: sendBySms,
                    onChanged: isSubmitting
                        ? null
                        : (value) => setSheetState(() {
                            sendBySms = value;
                          }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isSubmitting ? null : submit,
                      icon: isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.password_rounded),
                      label: Text(
                        isSubmitting ? 'Gönderiliyor...' : 'Random PIN Üret',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    fullCardNoController.dispose();
  }

  Future<void> _runCardAction(
    PaycoreCardSummary card,
    Future<String?> Function() action,
  ) async {
    if (_busyCards.contains(card.id)) {
      return;
    }

    setState(() {
      _busyCards.add(card.id);
    });

    final errorMessage = await action();

    if (!mounted) {
      return;
    }

    setState(() {
      _busyCards.remove(card.id);
    });

    if (errorMessage != null) {
      _showError(errorMessage);
      return;
    }

    await _loadData(silent: true);
  }

  Future<String?> _setPrimaryCard(PaycoreCardSummary card) async {
    final response = await _paycoreService.setPrimaryCard(card.id);
    if (!response.isSuccess) {
      return response.message ?? 'Ana kart atanamadı.';
    }

    _showSuccess(response.message ?? 'Ana kart güncellendi.');
    return null;
  }

  Future<String?> _cancelCard(PaycoreCardSummary card) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kartı iptal et'),
        content: Text(
          '${card.maskedCardNo} kartını iptal etmek istediğine emin misin? Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB3261E),
              foregroundColor: Colors.white,
            ),
            child: const Text('İptal Et'),
          ),
        ],
      ),
    );

    if (shouldCancel != true) {
      return 'İşlem iptal edildi.';
    }

    final response = await _paycoreService.cancelCard(
      card.id,
      note: 'Mobil uygulama üzerinden kullanıcı onayıyla iptal edildi.',
    );
    if (!response.isSuccess) {
      return response.message ?? 'Kart iptal edilemedi.';
    }

    _showSuccess(response.message ?? 'Kart iptal edildi.');
    return null;
  }

  Future<String?> _setRandomPin(
    PaycoreCardSummary card, {
    String? cardNo,
    bool isSendPinBySms = false,
  }) async {
    final response = await _paycoreService.setRandomPin(
      card.id,
      cardNo: cardNo,
      isSendPinBySms: isSendPinBySms,
    );
    if (!response.isSuccess) {
      return response.message ?? 'Random PIN üretilemedi.';
    }

    _showSuccess(response.message ?? 'Random PIN işlemi gönderildi.');
    await _loadPinStatus(card, silent: true);
    return null;
  }

  Future<String?> _sendPinSms(PaycoreCardSummary card) async {
    final cardNo = await _promptFullCardNo(
      title: 'PIN SMS Gönder',
      card: card,
      description:
          'PIN SMS gönderimi için kart numarasını maskesiz olarak girin.',
    );

    if (cardNo == null) {
      return 'İşlem iptal edildi.';
    }

    final response = await _paycoreService.sendPinBySms(
      card.id,
      cardNo: cardNo,
    );
    if (!response.isSuccess) {
      return response.message ?? 'PIN SMS gönderilemedi.';
    }

    _showSuccess(response.message ?? 'PIN SMS gönderildi.');
    return null;
  }

  Future<void> _showQrPaymentOptions(PaycoreCardSummary card) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'QR ile Öde / Para Çek',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kartınla QR okutma veya PayCore ATM QR para çekme işlemini seç.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  if (!mounted) {
                    return;
                  }
                  await Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const QrScanScreen(),
                    ),
                  );
                },
                child: _buildSurfaceCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.10,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QR ile Öde',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'QR kodu okutarak ödeme akışını başlat.',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _showAtmQrSheet(card);
                },
                child: _buildSurfaceCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.colorScheme.tertiary.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.atm_rounded,
                          color: context.colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ATMden Para Cek',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ATM ekranında oluşan QR veya KKF verisini kullanarak para çekme işlemini başlat.',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAtmQrSheet(PaycoreCardSummary card) async {
    final amountController = TextEditingController();

    var isResolving = false;
    var isSubmitting = false;
    PaycoreAtmQrInfo? qrInfo;
    String? kkfData;

    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (modalContext, setSheetState) {
              Future<void> resolveQrInfo() async {
                final normalizedKkfData = kkfData?.trim() ?? '';
                if (normalizedKkfData.isEmpty) {
                  _showError('Önce QR kodunu okutun.');
                  return;
                }

                setSheetState(() {
                  isResolving = true;
                });

                final response = await _paycoreService.getAtmQrInfo(
                  normalizedKkfData,
                );

                if (!mounted) {
                  return;
                }

                setSheetState(() {
                  isResolving = false;
                });

                if (!response.isSuccess || response.data == null) {
                  _showError(
                    response.message ?? 'ATM QR bilgisi çözümlenemedi.',
                  );
                  return;
                }

                qrInfo = response.data;
                amountController.text = response.data!.amount?.toString() ?? '';

                setSheetState(() {});
                _showSuccess(
                  response.data!.resultDescription ?? 'ATM QR bilgisi çözüldü.',
                );
              }

              Future<void> startQrTransaction() async {
                final normalizedKkfData = kkfData?.trim() ?? '';

                if (normalizedKkfData.isEmpty) {
                  _showError('ATM QR verisi bulunamadı. Lütfen QR okutun.');
                  return;
                }

                if (qrInfo == null) {
                  await resolveQrInfo();
                }

                final resolvedAmount = _parseOptionalDouble(
                  amountController.text,
                );
                final resolvedProcessingCode =
                    qrInfo?.suggestedProcessingCode?.trim().isNotEmpty ?? false
                    ? qrInfo!.suggestedProcessingCode!.trim()
                    : '010000';
                final resolvedTrxType =
                    qrInfo?.resolvedTrxType?.trim().isNotEmpty ?? false
                    ? qrInfo!.resolvedTrxType!.trim()
                    : '1';

                if (resolvedAmount == null || resolvedAmount <= 0) {
                  _showError('Tutar sıfırdan büyük olmalıdır.');
                  return;
                }

                setSheetState(() {
                  isSubmitting = true;
                });

                final response = await _paycoreService.startAtmQrTransaction(
                  cardId: card.id,
                  kkfData: normalizedKkfData,
                  amount: resolvedAmount,
                  processingCode: resolvedProcessingCode,
                  trxType: resolvedTrxType,
                );

                if (!mounted) {
                  return;
                }

                setSheetState(() {
                  isSubmitting = false;
                });

                if (!response.isSuccess || response.data == null) {
                  _showError(
                    response.message ?? 'ATM QR işlemi başlatılamadı.',
                  );
                  return;
                }

                _showSuccess(
                  response.data!.resultDescription ??
                      response.message ??
                      'ATM QR işlemi başlatıldı.',
                );
                if (!sheetContext.mounted) {
                  return;
                }
                Navigator.of(sheetContext).pop();
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'QR ile Öde / Para Çek',
                            style: modalContext.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              Navigator.of(sheetContext).maybePop(),
                          icon: const Icon(Icons.close_rounded),
                          tooltip: 'Kapat',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${card.maskedCardNo} • ${card.profileLabel}',
                      style: modalContext.textTheme.bodyMedium?.copyWith(
                        color: modalContext.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ATM ekranındaki QR kodunu okut, tutarı kontrol et ve işlemi kartla başlat.',
                      style: modalContext.textTheme.bodySmall?.copyWith(
                        color: modalContext.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isResolving || isSubmitting
                            ? null
                            : () async {
                                await showModalBottomSheet<void>(
                                  context: sheetContext,
                                  isScrollControlled: true,
                                  builder: (context) => _PaycoreQrScanModal(
                                    title: 'ATM QR Oku',
                                    description:
                                        'Kamerayı ATM QR koduna doğru tutun.',
                                    onClose: () => Navigator.of(context).pop(),
                                    onQrScanned: (value) async {
                                      kkfData = value.trim();
                                      Navigator.of(context).pop();
                                      setSheetState(() {});
                                      await resolveQrInfo();
                                    },
                                  ),
                                );
                              },
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: Text(
                          (kkfData?.trim().isNotEmpty ?? false)
                              ? 'QR Yeniden Oku'
                              : 'QR Oku',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (isResolving)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(),
                      ),
                    if (qrInfo != null) ...[
                      const SizedBox(height: 16),
                      _buildSurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ATM Bilgisi',
                              style: modalContext.textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            _buildTwoColumnInfo(
                              leftLabel: 'Terminal',
                              leftValue: qrInfo!.terminalTypeLabel,
                              rightLabel: 'İşlem Tipi',
                              rightValue: qrInfo!.resolvedTrxType ?? '-',
                            ),
                            const SizedBox(height: 10),
                            _buildTwoColumnInfo(
                              leftLabel: 'Tutar',
                              leftValue: qrInfo!.amount == null
                                  ? '-'
                                  : '${qrInfo!.amount!.toStringAsFixed(2)} ₺',
                              rightLabel: 'Şehir',
                              rightValue: qrInfo!.merchantCity ?? '-',
                            ),
                            if (qrInfo!.merchantName?.trim().isNotEmpty ??
                                false) ...[
                              const SizedBox(height: 10),
                              _buildInfoRow(
                                'ATM / İşyeri',
                                qrInfo!.merchantName!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: amountController,
                      label: 'Tutar',
                      hint: 'Örnek: 500.00',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isResolving || isSubmitting
                            ? null
                            : startQrTransaction,
                        icon: Icon(
                          isSubmitting
                              ? Icons.sync_rounded
                              : Icons.play_circle_outline_rounded,
                        ),
                        label: Text(
                          isSubmitting
                              ? 'İşlem Başlatılıyor...'
                              : 'ATM QR İşlemini Başlat',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } finally {
      amountController.dispose();
    }
  }

  Future<String?> _promptFullCardNo({
    required String title,
    required PaycoreCardSummary card,
    required String description,
  }) async {
    final resolvedFullCardNo = _resolvedFullCardNo(card);
    final controller = TextEditingController(text: resolvedFullCardNo ?? '');
    String? value;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 8,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
        ),
        child: StatefulBuilder(
          builder: (modalContext, setSheetState) {
            Future<void> submit() async {
              final rawValue = controller.text
                  .replaceAll(RegExp('[^0-9]'), '')
                  .trim();

              if (rawValue.length < 12 || int.tryParse(rawValue) == null) {
                _showError('Gercek kart numarasini maskesiz girin.');
                return;
              }

              value = rawValue;
              Navigator.of(sheetContext).pop();
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: modalContext.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resolvedFullCardNo ?? card.maskedCardNo,
                    style: modalContext.textTheme.bodyMedium?.copyWith(
                      color: modalContext.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: modalContext.textTheme.bodySmall?.copyWith(
                      color: modalContext.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: controller,
                    label: 'Gercek Kart Numarasi',
                    hint: 'Maskesiz kart numarasini girin',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: submit,
                      child: const Text('Devam Et'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    controller.dispose();
    return value;
  }

  ({
    String cityCode,
    String cityName,
    String townCode,
    String townName,
    String district,
    String address1,
    String? address2,
    String? zipCode,
  })?
  get _resolvedCreateCardAddress {
    final addresses =
        _customerInfo?.addresses ?? const <PaycoreCustomerAddress>[];
    if (addresses.isEmpty) {
      return null;
    }

    String? pickValue(
      Iterable<String?> candidates, {
      bool treatZeroAsEmpty = true,
    }) {
      for (final candidate in candidates) {
        final normalized = candidate?.trim();
        if (normalized == null || normalized.isEmpty) {
          continue;
        }
        if (treatZeroAsEmpty && normalized == '0') {
          continue;
        }
        return normalized;
      }
      return null;
    }

    Iterable<PaycoreCustomerAddress> byTypes(List<String> types) sync* {
      for (final type in types) {
        yield* addresses.where((address) => address.addressType == type);
      }
    }

    String? pickField(
      String? Function(PaycoreCustomerAddress address) selector, {
      List<String> preferredTypes = const ['D', 'P', 'W'],
      bool treatZeroAsEmpty = true,
    }) {
      return pickValue(
            byTypes(preferredTypes).map(selector),
            treatZeroAsEmpty: treatZeroAsEmpty,
          ) ??
          pickValue(
            addresses.map(selector),
            treatZeroAsEmpty: treatZeroAsEmpty,
          );
    }

    final address1 = pickField((address) => address.address1);
    final address2 = _normalizeSecondaryAddressLine(
      pickField((address) => address.address2, treatZeroAsEmpty: false),
    );
    final cityCode = pickField((address) => address.cityCode);
    final townCode = pickField((address) => address.townCode);
    final cityName = pickField(
      (address) => address.city,
      preferredTypes: const ['P', 'D', 'W'],
    );
    final townName = pickField(
      (address) => address.town,
      preferredTypes: const ['P', 'D', 'W'],
    );
    final district = pickField((address) => address.district);
    final zipCode = pickField(
      (address) => address.zipCode,
      treatZeroAsEmpty: false,
    );

    if ([address1, cityCode, townCode, cityName, townName, district].any(
      (value) => value == null || value.isEmpty,
    )) {
      return null;
    }

    return (
      cityCode: cityCode!,
      cityName: cityName!,
      townCode: townCode!,
      townName: townName!,
      district: district!,
      address1: address1!,
      address2: address2,
      zipCode: zipCode,
    );
  }

  Widget _buildInfoCallout({required String title, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.42,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetHeader({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final hasDescription = description.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (hasDescription) ...[
                const SizedBox(height: 4),
                Text(
                  description,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSheetSection({
    required String title,
    required Widget child,
    String? description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.28,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
          ] else
            const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    ToastComponent.showSuccessToast(context: context, message: message);
  }

  void _showError(String message) {
    ToastComponent.showErrorToast(context: context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.openActivateTab ? 'Kart Aktive Et' : 'Kartlarım'),
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : () => unawaited(_loadData()),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final loadError = _loadError;
    if (!_isLoading &&
        loadError != null &&
        _cards.isEmpty &&
        _customerInfo == null) {
      return ErrorTryAgain(
        message: loadError,
        onTryAgain: () => unawaited(_loadData()),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (_isLoading) ...[
            const SizedBox(height: 24),
            const Center(child: CustomLoading(dynamicSize: 0.08)),
            const SizedBox(height: 14),
          ],
          if (loadError != null) ...[
            _buildInlineErrorBanner(loadError),
            const SizedBox(height: 12),
          ],
          if (widget.openActivateTab) ...[
            _buildHeroCard(),
            const SizedBox(height: 12),
            _buildStandaloneActivationPage(),
          ] else ...[
            _buildHeroCard(),
            const SizedBox(height: 12),
            _buildModuleSelector(),
            const SizedBox(height: 14),
            _buildSelectedModule(),
          ],
        ],
      ),
    );
  }

  Widget _buildInlineErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorScheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.colorScheme.error.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: context.colorScheme.error,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.error,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildCardLogoBadge(logoHeight: 14),
              const Spacer(),
              Icon(
                Icons.credit_card_rounded,
                color: Colors.white.withValues(alpha: 0.92),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${_userInfoManager.firstName ?? ''} ${_userInfoManager.lastName ?? ''}'
                .trim(),
            style: context.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _userInfoManager.walletAddress ?? '-',
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 12,
            ),
          ),
          if (_customerInfo?.primaryCardNo?.isNotEmpty ?? false) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.workspace_premium_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Ana Kart: ${_customerInfo!.primaryCardNo}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModuleSelector() {
    return SegmentedButton<_PaycoreModule>(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: context.colorScheme.primary,
        selectedForegroundColor: Colors.white,
        foregroundColor: context.colorScheme.onSurfaceVariant,
        backgroundColor: context.colorScheme.surface,
        side: BorderSide(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 2),
        textStyle: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        visualDensity: VisualDensity.compact,
      ),
      segments: const [
        ButtonSegment(
          value: _PaycoreModule.customer,
          icon: Icon(Icons.badge_outlined),
          label: Text('Müşteri'),
        ),
        ButtonSegment(
          value: _PaycoreModule.cards,
          icon: Icon(Icons.credit_card_outlined),
          label: Text('Kart Açılış'),
        ),
        ButtonSegment(
          value: _PaycoreModule.security,
          icon: Icon(Icons.lock_outline_rounded),
          label: Text('Güvenlik'),
        ),
      ],
      selected: {_selectedModule},
      onSelectionChanged: (value) {
        final next = value.first;
        setState(() {
          _selectedModule = next;
        });

        if (next == _PaycoreModule.security && _cards.isNotEmpty) {
          unawaited(_preloadPinStatuses());
        }
      },
    );
  }

  Widget _buildSelectedModule() {
    return switch (_selectedModule) {
      _PaycoreModule.customer => _buildCustomerModule(),
      _PaycoreModule.cards => _buildCardsModule(),
      _PaycoreModule.security => _buildSecurityModule(),
    };
  }

  Widget _buildCustomerModule() {
    final customer = _customerInfo ?? _buildLocalCustomerInfoFallback();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModuleHeader(
          title: 'Müşteri Yönetimi',
          description:
              'Müşteri kaydını kontrol et, gerekiyorsa oluştur ve adres bilgisini güncelle.',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _showCustomerInfoSheet,
                style: _moduleActionStyle(),
                icon: const Icon(Icons.manage_search_rounded),
                label: const Text('Bilgiyi Gör'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _showCreateCustomerSheet,
                style: _moduleFilledActionStyle(),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: Text(
                  _hasPaycoreCustomerRecord
                      ? 'Yeniden Oluştur'
                      : 'Müşteri Oluştur',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (customer == null)
          _buildEmptyBlock(
            title: 'Müşteri kaydı bulunamadı',
            description:
                'Bu kullanıcı için önce müşteri kaydını oluştur, sonra kart açılış ve PIN güvenlik akışlarını yönet.',
            icon: Icons.person_search_outlined,
            actionLabel: 'Müşteri Oluştur',
            onPressed: _showCreateCustomerSheet,
          )
        else ...[
          ...(() {
            final currentCustomer = customer!;

            return [
              _buildSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            currentCustomer.fullName,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              height: 1.15,
                            ),
                          ),
                        ),
                        _buildPrimaryPill(
                          _hasPaycoreCustomerRecord
                              ? 'Kart Sistemi Aktif'
                              : 'Yerel Bilgi',
                        ),
                      ],
                    ),
                    if (!_hasPaycoreCustomerRecord) ...[
                      const SizedBox(height: 12),
                      Text(
                        'PayCore müşteri kaydı doğrulanamadı. Kartlar yerel cüzdan kaydına göre gösteriliyor.',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    _buildInfoGroup('Özet', [
                      ..._buildCustomerInfoRows([
                        ('Ad Soyad', currentCustomer.fullName),
                        (
                          'Banking Customer No',
                          currentCustomer.bankingCustomerNo,
                        ),
                        ('Customer No', currentCustomer.customerNo),
                        ('Ana Kart', currentCustomer.primaryCardNo),
                        ('Statü', currentCustomer.statCode),
                        ('Risk Kodu', currentCustomer.riskCode),
                        ('Müşteri Grubu', currentCustomer.customerGroupCode),
                        ('İletişim Dili', currentCustomer.commLanguage),
                        ('Meslek', currentCustomer.profession),
                        ('Emboss', currentCustomer.customerEmbossNameExt),
                        ('Şirket Adı', currentCustomer.companyName),
                        ('Şirket No', currentCustomer.companyNo),
                        ('Ünvan', currentCustomer.title),
                        ('İşyeri', currentCustomer.workPlace),
                        ('Mezuniyet', currentCustomer.graduation),
                        ('Engel Tipi', currentCustomer.disabledType),
                        ('Şube Kodu', currentCustomer.branchCode?.toString()),
                        (
                          'Dijital Slip Tipi',
                          currentCustomer.digitalSlipType?.toString(),
                        ),
                      ]),
                    ]),
                    if (_hasCustomerIdentityInfo(currentCustomer)) ...[
                      const SizedBox(height: 12),
                      _buildInfoGroup('Kimlik', [
                        ..._buildCustomerInfoRows([
                          ('TC Kimlik No', currentCustomer.nationalIdentityNo),
                          ('Cinsiyet', currentCustomer.gender),
                          (
                            'Doğum Tarihi',
                            _formatDateValue(currentCustomer.birthDate),
                          ),
                          ('Doğum Yeri', currentCustomer.birthPlace),
                          ('Uyruk', currentCustomer.nationality),
                          ('Kimlik Tipi', currentCustomer.identityType),
                          ('Vergi No', currentCustomer.taxNo),
                          ('Vergi Dairesi', currentCustomer.taxDepartmentName),
                          ('Baba Adı', currentCustomer.fatherName),
                          ('Anne Adı', currentCustomer.motherName),
                          ('Kızlık Soyadı', currentCustomer.maidenName),
                          ('Eş / Partner', currentCustomer.partnerName),
                          ('Kimlik Seri No', currentCustomer.identitySerialNo),
                          ('Kimlik Veren', currentCustomer.identityIssuedBy),
                          (
                            'Kimlik Veriliş',
                            _formatDateValue(currentCustomer.identityIssueDate),
                          ),
                          (
                            'Kimlik Geçerlilik',
                            _formatDateValue(
                              currentCustomer.identityValidUntil,
                            ),
                          ),
                          ('Kimlik İl Kodu', currentCustomer.identityCityCode),
                          (
                            'Kimlik İlçe Kodu',
                            currentCustomer.identityTownCode,
                          ),
                        ]),
                      ]),
                    ],
                    if (_hasCustomerStatusInfo(currentCustomer)) ...[
                      const SizedBox(height: 12),
                      _buildInfoGroup('Durum ve Aktivite', [
                        ..._buildCustomerInfoRows([
                          ('Takip Durumu', currentCustomer.followUpStat),
                          ('Ekstre Statü', currentCustomer.stmtStatCode),
                          (
                            'Gecikme Periyodu',
                            currentCustomer.stmtDelinqPeriod?.toString(),
                          ),
                          ('NPL Adedi', currentCustomer.nplCount?.toString()),
                          (
                            'Min Ödeme Adedi',
                            currentCustomer.minPayCount?.toString(),
                          ),
                          (
                            'Önceki Min Ödeme',
                            currentCustomer.prevMinPayCount?.toString(),
                          ),
                          (
                            'Min Ödeme Değişim',
                            _formatDateValue(currentCustomer.minPayChangeDate),
                          ),
                          (
                            'Min Ödeme Gecikme',
                            currentCustomer.minPayDelinq?.toString(),
                          ),
                          (
                            'İlk Gecikme Tarihi',
                            _formatDateValue(currentCustomer.firstDelayDate),
                          ),
                          (
                            'Son İşlem Tarihi',
                            _formatDateTimeValue(currentCustomer.lastTxnDate),
                          ),
                          ('Aktivite Statü', currentCustomer.activityStat),
                          (
                            'Aktivite Sayaç',
                            currentCustomer.activityStatCount?.toString(),
                          ),
                          (
                            'Son Kart Basım',
                            _formatDateValue(
                              currentCustomer.lastCardIssuingDate,
                            ),
                          ),
                          (
                            'İlk Kredi Kartı',
                            _formatDateValue(
                              currentCustomer.firstCreditCardDate,
                            ),
                          ),
                          (
                            'Statü Değişim',
                            _formatDateValue(currentCustomer.statChangeDate),
                          ),
                          (
                            'Garantili',
                            _formatBoolValue(currentCustomer.isGuaranteed),
                          ),
                          (
                            'Tüzel Müşteri',
                            _formatBoolValue(currentCustomer.isBusiness),
                          ),
                          (
                            'Kimlik İbraz',
                            _formatBoolValue(
                              currentCustomer.isIdentityPresented,
                            ),
                          ),
                          (
                            'Araç Sahibi',
                            _formatBoolValue(currentCustomer.hasCar),
                          ),
                          (
                            'Gayrimenkul',
                            _formatBoolValue(currentCustomer.hasRealEstate),
                          ),
                          (
                            'Bilgi Paylaşım İzni',
                            _formatBoolValue(
                              currentCustomer.isAllowedShareCstInfo,
                            ),
                          ),
                          (
                            'Bilgi Paylaşım Güncelleme',
                            _formatDateValue(
                              currentCustomer.shareCstInfoChgDate,
                            ),
                          ),
                          ('Kefil', currentCustomer.guarantor),
                          ('Kefil Meslek', currentCustomer.guarantorProfession),
                        ]),
                      ]),
                    ],
                  ],
                ),
              ),
              if (currentCustomer.communications.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSectionTitle('İletişim Bilgileri'),
                const SizedBox(height: 10),
                ...currentCustomer.communications.map(
                  (item) => _buildSurfaceCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Icon(
                          item.communicationType == 'EM'
                              ? Icons.alternate_email_rounded
                              : Icons.phone_iphone_rounded,
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getCommunicationTypeLabel(
                                  item.communicationType,
                                ),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                  fontSize: 11.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.info,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (item.isDefault) _buildPrimaryPill('Varsayılan'),
                      ],
                    ),
                  ),
                ),
              ],
              if (currentCustomer.addresses.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSectionTitle('Adresler'),
                const SizedBox(height: 10),
                ...currentCustomer.addresses.map(
                  (address) => _buildSurfaceCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _getAddressTypeLabel(address.addressType),
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (address.isDefault)
                              _buildPrimaryPill('Varsayılan'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _buildAddressSummary(address),
                          style: context.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                unawaited(_showAddressEditSheet(address)),
                            style: _compactActionStyle(),
                            icon: const Icon(Icons.edit_location_alt_rounded),
                            label: const Text('Düzenle'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (currentCustomer.limits.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSectionTitle('Limitler'),
                const SizedBox(height: 10),
                ...currentCustomer.limits.map(
                  (limit) => _buildSurfaceCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: _buildTwoColumnInfo(
                      leftLabel: 'Limit',
                      leftValue: '${limit.currentLimit.toStringAsFixed(2)} ₺',
                      rightLabel: 'Durum',
                      rightValue: limit.isLimitBlocked ? 'Blokeli' : 'Açık',
                    ),
                  ),
                ),
              ],
            ];
          })(),
        ],
      ],
    );
  }

  Widget _buildCardsModule() {
    final canCreateCard =
        _hasPaycoreCustomerRecord && _resolvedCreateCardAddress != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModuleHeader(
          title: 'Kart Açılış',
          description:
              'Yeni prepaid kart üret, mevcut kartları incele ve ana kart atamasını yönet.',
        ),
        const SizedBox(height: 12),
        _buildCardActionFeature(
          title: 'Yeni Kart Açılışı',
          icon: Icons.credit_card_rounded,
          badgeLabel: canCreateCard ? 'Hazır' : 'Hazırlık Gerekli',
          badgeColor: canCreateCard
              ? const Color(0xFF08A857)
              : const Color(0xFFEF8F00),
          actionLabel: 'Kart Oluştur',
          actionIcon: Icons.arrow_forward_rounded,
          onPressed: _handleCreateCardPressed,
        ),
        const SizedBox(height: 12),
        _buildSectionTitle('Kartlarım'),
        const SizedBox(height: 10),
        _buildCardsListSection(),
      ],
    );
  }

  Widget _buildCardsListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_cards.isEmpty)
          _buildEmptyBlock(
            title: 'Kayıtlı kart bulunamadı',
            description:
                'İlk kart açılışını yaptıktan sonra kartların burada maskeli PAN ile listelenecek.',
            icon: Icons.credit_card_off_outlined,
            actionLabel: 'Kart Oluştur',
            onPressed: _handleCreateCardPressed,
          )
        else
          ..._cards.map(_buildCardModuleItem),
      ],
    );
  }

  Widget _buildCardActivationPage({
    required bool canAddCard,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF143D9C).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.add_card_rounded,
                      color: Color(0xFF143D9C),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kart Aktivasyon',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Yeni fiziki kartı bu sayfadan okutabilir veya bilgilerini girerek hesabına ekleyebilirsin.',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatusPill(
                    label: canAddCard
                        ? 'Aktivasyona Uygun'
                        : 'Müşteri Kaydı Gerekli',
                    color: canAddCard
                        ? const Color(0xFF08A857)
                        : const Color(0xFFB54708),
                  ),
                  _buildStatusPill(
                    label: 'QR / Manuel Giriş',
                    color: const Color(0xFF143D9C),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInlineInfoBox(
                icon: Icons.info_outline_rounded,
                message:
                    'Kamera ile kart üzerindeki bilgileri hızlıca okutabilir veya numarayı elle girerek devam edebilirsin.',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _handleAddPhysicalCardPressed,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  icon: const Icon(Icons.qr_code_rounded, size: 18),
                  label: const Text('Kartı Aktive Et'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStandaloneActivationPage() {
    final canAddCard = _hasPaycoreCustomerRecord;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModuleHeader(
          title: 'Kart Aktivasyon',
          description:
              'Fiziki kartı hesabına eklemek için QR okut veya kart bilgisini manuel girerek aktivasyonu tamamla.',
        ),
        const SizedBox(height: 12),
        _buildCardActivationPage(canAddCard: canAddCard),
      ],
    );
  }

  Widget _buildCardActionFeature({
    required String title,
    required IconData icon,
    required String badgeLabel,
    required Color badgeColor,
    required String actionLabel,
    required IconData actionIcon,
    required VoidCallback onPressed,
  }) {
    return _buildSurfaceCard(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF7F9FF),
              context.colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF143D9C).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFF143D9C),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: badgeColor.withValues(alpha: 0.18),
                              ),
                            ),
                            child: Text(
                              badgeLabel,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: badgeColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 10.5,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 15.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onPressed,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  icon: Icon(actionIcon, size: 18),
                  label: Text(actionLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill({
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        label,
        style: context.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildInlineInfoBox({
    required IconData icon,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: context.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModuleHeader(
          title: 'PIN / Kart Güvenlik',
          description:
              'Kart bazında PIN durumunu gör, manuel PIN set et, random PIN üret veya SMS gönder.',
        ),
        const SizedBox(height: 12),
        if (_cards.isEmpty)
          _buildEmptyBlock(
            title: 'Güvenlik işlemi için kart yok',
            description:
                'Önce kart açılışını tamamla. Kart üretildikten sonra bu alanda PIN güvenlik aksiyonları açılır.',
            icon: Icons.shield_outlined,
            actionLabel: 'Kart Açılışa Git',
            onPressed: () {
              setState(() {
                _selectedModule = _PaycoreModule.cards;
              });
            },
          )
        else
          ..._cards.map(_buildSecurityCard),
      ],
    );
  }

  Widget _buildCardModuleItem(PaycoreCardSummary card) {
    final isBusy = _busyCards.contains(card.id);
    final pinStatus = _pinStatuses[card.id];
    final isExpanded =
        _expandedCardMenus.isEmpty || _expandedCardMenus.contains(card.id);

    return Container(
      key: ValueKey('paycore-card-module-${card.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PaycoreCardVisual(
            card: card,
            enableFlip: true,
            aspectRatio: 1.48,
            margin: const EdgeInsets.only(bottom: 8),
            shouldIgnoreFlipTap:
                (
                  localPosition,
                  size, {
                  required isBackVisible,
                }) {
                  if (!isBackVisible) {
                    return false;
                  }

                  return localPosition.dx >= size.width - 170 &&
                      localPosition.dy >= size.height * 0.42 &&
                      localPosition.dy <= size.height * 0.78;
                },
            frontChild: _buildCardFrontFace(card, pinStatus),
            backChild: _buildCardBackFace(card, pinStatus),
          ),
          _buildSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    setState(() {
                      if (_expandedCardMenus.isEmpty) {
                        _expandedCardMenus.addAll(
                          _cards.map((item) => item.id),
                        );
                      }

                      if (_expandedCardMenus.contains(card.id)) {
                        _expandedCardMenus.remove(card.id);
                      } else {
                        _expandedCardMenus.add(card.id);
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${card.profileLabel} • ${card.cardTypeName}',
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PIN: ${_pinStatusLabel(pinStatus)}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              unawaited(_showCardDetailSheet(card)),
                          style: _compactActionStyle(),
                          icon: const Icon(Icons.article_outlined, size: 16),
                          label: const Text('Detay'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => unawaited(_showPinStatusSheet(card)),
                          style: _compactActionStyle(),
                          icon: const Icon(Icons.search_rounded, size: 16),
                          label: const Text('PIN Durum'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isBusy || card.isPrimary
                              ? null
                              : () => unawaited(
                                  _runCardAction(
                                    card,
                                    () => _setPrimaryCard(card),
                                  ),
                                ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF143D9C),
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            side: BorderSide(
                              color: card.isPrimary
                                  ? context.colorScheme.outlineVariant
                                  : const Color(0xFF1E1E1E),
                            ),
                          ),
                          icon: const Icon(
                            Icons.workspace_premium_outlined,
                            size: 16,
                          ),
                          label: Text(
                            card.isPrimary ? 'Ana Kart' : 'Ana Kart Ata',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => unawaited(_showSetPinSheet(card)),
                          style: _filledCompactActionStyle(),
                          icon: const Icon(Icons.pin_outlined, size: 16),
                          label: Text(
                            (pinStatus?.pinSetFlag ?? false)
                                ? 'PIN Güncelle'
                                : 'PIN Oluştur',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isBusy
                              ? null
                              : () => unawaited(_showRandomPinSheet(card)),
                          style: _compactActionStyle(),
                          icon: const Icon(Icons.password_rounded, size: 16),
                          label: const Text('Random PIN'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isBusy
                              ? null
                              : () => unawaited(
                                  _runCardAction(card, () => _sendPinSms(card)),
                                ),
                          style: _compactActionStyle(),
                          icon: const Icon(Icons.sms_outlined, size: 16),
                          label: const Text('PIN SMS'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: isBusy
                          ? null
                          : () => unawaited(_showQrPaymentOptions(card)),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                      ),
                      icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                      label: const Text('QR ile Öde / Para Çek'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFrontFace(
    PaycoreCardSummary card,
    PaycorePinStatus? pinStatus,
  ) {
    final resolvedFullCardNo = _resolvedFullCardNo(card);
    final embossName = card.embossName?.trim().isNotEmpty ?? false
        ? card.embossName!.trim().toUpperCase()
        : 'KART SAHIBI';
    final canRevealCardNumber =
        card.resolvedIsDigitalCard && resolvedFullCardNo != null;
    final isCardNumberVisible = _revealedVirtualCardNumbers.contains(card.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildChip(card.brand.label),
                  _buildChip(card.cardModeLabel),
                  _buildChip(card.isActive ? 'Aktif' : 'Pasif'),
                  if (card.isPrimary) _buildPrimaryPill('Ana Kart'),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  if (!canRevealCardNumber || !isCardNumberVisible) {
                    return;
                  }

                  await Clipboard.setData(
                    ClipboardData(text: resolvedFullCardNo!),
                  );
                  if (!mounted) {
                    return;
                  }
                  ToastComponent.showSuccessToast(
                    context: context,
                    message: 'Kart numarası kopyalandı.',
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            isCardNumberVisible && canRevealCardNumber
                                ? resolvedFullCardNo!
                                : card.maskedCardNo,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (canRevealCardNumber) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                if (isCardNumberVisible) {
                                  _revealedVirtualCardNumbers.remove(card.id);
                                } else {
                                  _revealedVirtualCardNumbers.add(card.id);
                                }
                              });
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Icon(
                                isCardNumberVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (canRevealCardNumber && isCardNumberVisible) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Dokun ve kopyala',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'SKT',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  _cardExpiryLabel(card.expiryDate),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: Text(
            embossName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${card.profileLabel} • ${card.cardTypeName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCardBackFace(
    PaycoreCardSummary card,
    PaycorePinStatus? pinStatus,
  ) {
    final isCvvPeeked = _cvvPeekCards.contains(card.id);
    final canRevealCvv =
        card.resolvedIsDigitalCard && (card.cvv?.trim().isNotEmpty ?? false);
    final resolvedPin = pinStatus?.pinValue?.trim().isNotEmpty ?? false
        ? pinStatus!.pinValue!.trim()
        : (card.pin?.trim().isNotEmpty ?? false)
        ? card.pin!.trim()
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildChip('Arka Yüz'),
            const SizedBox(width: 6),
            _buildChip(card.brand.label),
            const SizedBox(width: 6),
            _buildChip(card.cardModeLabel),
            const Spacer(),
            Text(
              card.statusName,
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.88),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (resolvedPin != null) ...[
              SizedBox(
                width: 112,
                child: _buildBackInfoBlock(
                  title: 'PIN',
                  value: resolvedPin,
                  alignEnd: true,
                ),
              ),
              const SizedBox(width: 10),
            ],
            SizedBox(
              width: 136,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!canRevealCvv) {
                    return;
                  }
                  setState(() {
                    if (isCvvPeeked) {
                      _cvvPeekCards.remove(card.id);
                    } else {
                      _cvvPeekCards.add(card.id);
                    }
                  });
                },
                child: _buildBackInfoBlock(
                  title: 'CVV',
                  value: _displayCardCvv(card, reveal: isCvvPeeked),
                  alignEnd: true,
                  trailingIcon: !canRevealCvv
                      ? null
                      : isCvvPeeked
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildBackInfoBlock({
    required String title,
    required String value,
    bool alignEnd = false,
    IconData? trailingIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: alignEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 6),
                Icon(
                  trailingIcon,
                  size: 15,
                  color: Colors.white.withValues(alpha: 0.84),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(PaycoreCardSummary card) {
    final isBusy = _busyCards.contains(card.id);
    final isPinLoading = _loadingPinCards.contains(card.id);
    final pinStatus = _pinStatuses[card.id];

    return _buildSurfaceCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.maskedCardNo,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${card.profileLabel} • ${card.statusName}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.cardModeLabel,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (card.isPrimary) _buildPrimaryPill('Ana Kart'),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.35,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isPinLoading
                      ? Icons.sync_rounded
                      : (pinStatus?.pinSetFlag ?? false)
                      ? Icons.lock_outline_rounded
                      : Icons.lock_open_rounded,
                  color: context.colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isPinLoading
                        ? 'PIN durumu sorgulanıyor...'
                        : _pinStatusLabel(pinStatus),
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (pinStatus?.lastPinSetDate != null)
                  Text(
                    _formatDate(pinStatus!.lastPinSetDate),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => unawaited(_showPinStatusSheet(card)),
                style: _compactActionStyle(),
                icon: const Icon(Icons.search_rounded, size: 16),
                label: const Text('Durum'),
              ),
              FilledButton.icon(
                onPressed: () => unawaited(_showSetPinSheet(card)),
                style: _filledCompactActionStyle(),
                icon: const Icon(Icons.pin_outlined, size: 16),
                label: const Text('PIN Set'),
              ),
              OutlinedButton.icon(
                onPressed: isBusy
                    ? null
                    : () => unawaited(_showRandomPinSheet(card)),
                style: _compactActionStyle(),
                icon: const Icon(Icons.password_rounded, size: 16),
                label: const Text('Random'),
              ),
              OutlinedButton.icon(
                onPressed: isBusy
                    ? null
                    : () => unawaited(
                        _runCardAction(card, () => _sendPinSms(card)),
                      ),
                style: _compactActionStyle(),
                icon: const Icon(Icons.sms_outlined, size: 16),
                label: const Text('SMS'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModuleHeader({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            height: 1.35,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildEmptyBlock({
    required String title,
    required String description,
    required IconData icon,
    required String actionLabel,
    required VoidCallback? onPressed,
  }) {
    return _buildSurfaceCard(
      child: Column(
        children: [
          Icon(
            icon,
            size: 34,
            color: context.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onPressed,
            style: _moduleFilledActionStyle(),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildSurfaceCard({
    required Widget child,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: child,
    );
  }

  String _cardExpiryLabel(String? expiryDate) {
    final value = expiryDate?.trim();
    if (value == null || value.isEmpty) {
      return '--/--';
    }

    if (value.contains('/')) {
      final parts = value.split('/');
      if (parts.length == 2) {
        final left = parts.first.padLeft(2, '0');
        final right = parts.last.length > 2
            ? parts.last
            : parts.last.padLeft(2, '0');
        return '$left/$right';
      }
      return value;
    }

    final digits = value.replaceAll(RegExp('[^0-9]'), '');
    if (digits.length == 4) {
      return '${digits.substring(0, 2)}/${digits.substring(2)}';
    }
    if (digits.length == 6) {
      return '${digits.substring(0, 4)}/${digits.substring(4)}';
    }

    return value;
  }

  String _displayCardCvv(PaycoreCardSummary card, {required bool reveal}) {
    final cvv = card.cvv?.trim();
    if (cvv == null || cvv.isEmpty) {
      return '***';
    }

    return reveal ? cvv : '*' * cvv.length;
  }

  String _displayCardHolder(PaycoreCardSummary card) {
    final embossName = card.embossName?.trim();
    if (embossName != null && embossName.isNotEmpty) {
      return embossName.toUpperCase();
    }

    final fallbackName =
        '${_userInfoManager.firstName ?? ''} ${_userInfoManager.lastName ?? ''}'
            .trim();
    if (fallbackName.isNotEmpty) {
      return fallbackName.toUpperCase();
    }

    return '-';
  }

  Widget _buildPrimaryPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 9.5,
        ),
      ),
    );
  }

  Widget _buildCardLogoBadge({double logoHeight = 12}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.38),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Image.asset(
        IconAssetsConstants.logo,
        height: logoHeight,
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  ButtonStyle _moduleActionStyle() {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      visualDensity: VisualDensity.compact,
      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    );
  }

  ButtonStyle _moduleFilledActionStyle() {
    return FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      visualDensity: VisualDensity.compact,
      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    );
  }

  ButtonStyle _compactActionStyle() {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      visualDensity: VisualDensity.compact,
      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    );
  }

  ButtonStyle _filledCompactActionStyle() {
    return FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      visualDensity: VisualDensity.compact,
      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildTwoColumnInfo({
    required String leftLabel,
    required String leftValue,
    required String rightLabel,
    required String rightValue,
  }) {
    return Row(
      children: [
        Expanded(child: _buildMiniInfo(leftLabel, leftValue)),
        const SizedBox(width: 12),
        Expanded(child: _buildMiniInfo(rightLabel, rightValue)),
      ],
    );
  }

  Widget _buildMiniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontSize: 11.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '-' : value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGroup(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCustomerInfoRows(List<(String, String?)> items) {
    return items
        .where((item) => (item.$2 ?? '').trim().isNotEmpty)
        .map((item) => _buildInfoRow(item.$1, item.$2!.trim()))
        .toList();
  }

  bool _hasCustomerIdentityInfo(PaycoreCustomerInfo customer) {
    return [
      customer.nationalIdentityNo,
      customer.gender,
      _formatDateValue(customer.birthDate),
      customer.birthPlace,
      customer.nationality,
      customer.identityType,
      customer.taxNo,
      customer.taxDepartmentName,
      customer.fatherName,
      customer.motherName,
      customer.maidenName,
      customer.partnerName,
      customer.identitySerialNo,
      customer.identityIssuedBy,
      _formatDateValue(customer.identityIssueDate),
      _formatDateValue(customer.identityValidUntil),
      customer.identityCityCode,
      customer.identityTownCode,
    ].any((value) => value?.trim().isNotEmpty ?? false);
  }

  bool _hasCustomerStatusInfo(PaycoreCustomerInfo customer) {
    return [
      customer.followUpStat,
      customer.stmtStatCode,
      customer.stmtDelinqPeriod?.toString(),
      customer.nplCount?.toString(),
      customer.minPayCount?.toString(),
      customer.prevMinPayCount?.toString(),
      _formatDateValue(customer.minPayChangeDate),
      customer.minPayDelinq?.toString(),
      _formatDateValue(customer.firstDelayDate),
      _formatDateTimeValue(customer.lastTxnDate),
      customer.activityStat,
      customer.activityStatCount?.toString(),
      _formatDateValue(customer.lastCardIssuingDate),
      _formatDateValue(customer.firstCreditCardDate),
      _formatDateValue(customer.statChangeDate),
      _formatBoolValue(customer.isGuaranteed),
      _formatBoolValue(customer.isBusiness),
      _formatBoolValue(customer.isIdentityPresented),
      _formatBoolValue(customer.hasCar),
      _formatBoolValue(customer.hasRealEstate),
      _formatBoolValue(customer.isAllowedShareCstInfo),
      _formatDateValue(customer.shareCstInfoChgDate),
      customer.guarantor,
      customer.guarantorProfession,
    ].any((value) => value?.trim().isNotEmpty ?? false);
  }

  String? _formatDateValue(DateTime? date) {
    final value = _formatDate(date);
    return value == '-' ? null : value;
  }

  String? _formatDateTimeValue(DateTime? date) {
    final value = _formatDateTime(date);
    return value == '-' ? null : value;
  }

  String? _formatBoolValue(bool? value) {
    return switch (value) {
      true => 'Evet',
      false => 'Hayır',
      null => null,
    };
  }

  String? _normalizeCardDigits(String? value) {
    if (value == null) {
      return null;
    }

    final digits = value.replaceAll(RegExp(r'[^0-9]'), '').trim();
    return digits.isEmpty ? null : digits;
  }

  double? _parseOptionalDouble(String? value) {
    if (value == null) {
      return null;
    }

    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) {
      return null;
    }

    return double.tryParse(normalized);
  }

  String? _nullIfBlank(String? value) {
    final normalized = value?.trim() ?? '';
    return normalized.isEmpty ? null : normalized;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool required = true,
    int maxLines = 1,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: context.colorScheme.outlineVariant,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.9),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: context.colorScheme.primary,
              width: 1.4,
            ),
          ),
          filled: true,
          fillColor: context.colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: maxLines > 1 ? 16 : 14,
          ),
        ),
      ),
    );
  }

  String? _resolvedFullCardNo(PaycoreCardSummary card) {
    final normalizedFullCardNo = card.fullCardNo
        ?.replaceAll(RegExp('[^0-9]'), '')
        .trim();
    if (normalizedFullCardNo != null && normalizedFullCardNo.length >= 12) {
      return normalizedFullCardNo;
    }

    final normalizedCardReference = card.cardReference
        .replaceAll(RegExp('[^0-9]'), '')
        .trim();
    if (normalizedCardReference.length >= 12) {
      return normalizedCardReference;
    }

    return null;
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    bool required = true,
    bool enabled = true,
  }) {
    final uniqueItems = LinkedHashSet<String>.from(
      items.where((item) => item.trim().isNotEmpty),
    ).toList();
    final selectedValue = value != null && uniqueItems.contains(value)
        ? value
        : null;
    final displayValue = selectedValue ?? '';
    final hasValue = displayValue.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: !enabled || uniqueItems.isEmpty
            ? null
            : () async {
                final selection = await _showDropdownSelectionSheet(
                  title: required ? '$label *' : label,
                  items: uniqueItems,
                  selectedValue: selectedValue,
                  enableSearch: uniqueItems.length > 8,
                );

                if (selection != null) {
                  onChanged(selection);
                }
              },
        child: InputDecorator(
          isEmpty: !hasValue,
          decoration: InputDecoration(
            labelText: required ? '$label *' : label,
            hintText: '$label seçin',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: context.colorScheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: context.colorScheme.outlineVariant.withValues(
                  alpha: 0.9,
                ),
              ),
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: enabled
                  ? context.colorScheme.onSurfaceVariant
                  : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: enabled
                ? context.colorScheme.surface
                : context.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          child: Text(
            hasValue ? displayValue : '$label seçin',
            style: context.textTheme.bodyMedium?.copyWith(
              color: hasValue
                  ? context.colorScheme.onSurface
                  : context.colorScheme.onSurfaceVariant,
              fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Future<String?> _showDropdownSelectionSheet({
    required String title,
    required List<String> items,
    String? selectedValue,
    bool enableSearch = false,
  }) async {
    final searchController = TextEditingController();
    var filteredItems = List<String>.from(items);
    final maxSheetHeight = MediaQuery.of(context).size.height * 0.72;
    try {
      final selected = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) {
          return StatefulBuilder(
            builder: (modalContext, setModalState) {
              void handleSearch(String query) {
                setModalState(() {
                  filteredItems = items
                      .where(
                        (item) =>
                            item.toLowerCase().contains(query.toLowerCase()),
                      )
                      .toList();
                });
              }

              return Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: SizedBox(
                  height: maxSheetHeight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom:
                          MediaQuery.of(modalContext).viewInsets.bottom + 16,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: context.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          title,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (enableSearch) ...[
                          const SizedBox(height: 14),
                          TextField(
                            controller: searchController,
                            onChanged: handleSearch,
                            decoration: InputDecoration(
                              hintText: 'Ara',
                              prefixIcon: const Icon(Icons.search_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Expanded(
                          child: filteredItems.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24,
                                    ),
                                    child: Text(
                                      'Sonuc bulunamadi',
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: context
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: filteredItems.length,
                                  separatorBuilder: (_, index) =>
                                      const SizedBox(height: 6),
                                  itemBuilder: (itemContext, index) {
                                    final item = filteredItems[index];
                                    final isSelected = item == selectedValue;

                                    return Material(
                                      color: isSelected
                                          ? context.colorScheme.primary
                                                .withValues(
                                                  alpha: 0.08,
                                                )
                                          : context.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(14),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(14),
                                        onTap: () => Navigator.of(
                                          sheetContext,
                                        ).pop(item),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? context.colorScheme.primary
                                                  : context
                                                        .colorScheme
                                                        .outlineVariant
                                                        .withValues(
                                                          alpha: 0.35,
                                                        ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item,
                                                  style: context
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight: isSelected
                                                            ? FontWeight.w700
                                                            : FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                              if (isSelected)
                                                Icon(
                                                  Icons.check_circle_rounded,
                                                  color: context
                                                      .colorScheme
                                                      .primary,
                                                  size: 20,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
      return selected;
    } finally {
      searchController.dispose();
    }
  }

  String _buildAddressSummary(PaycoreCustomerAddress address) {
    return [
      address.address1,
      if (_normalizeSecondaryAddressLine(address.address2)?.isNotEmpty ?? false)
        _normalizeSecondaryAddressLine(address.address2),
      address.district,
      if (address.town?.isNotEmpty ?? false) address.town else address.townCode,
      if (address.city?.isNotEmpty ?? false) address.city else address.cityCode,
      address.zipCode,
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');
  }

  String _buildResolvedCreateCardAddressSummary(
    ({
      String cityCode,
      String cityName,
      String townCode,
      String townName,
      String district,
      String address1,
      String? address2,
      String? zipCode,
    })
    address,
  ) {
    return [
      address.address1,
      if (_normalizeSecondaryAddressLine(address.address2)?.isNotEmpty ?? false)
        _normalizeSecondaryAddressLine(address.address2),
      address.district,
      address.townName,
      address.cityName,
      if (address.zipCode?.isNotEmpty ?? false) address.zipCode,
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) {
      return '-';
    }

    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  String? _normalizeSecondaryAddressLine(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    if (RegExp(r'^\d{8,}$').hasMatch(normalized)) {
      return null;
    }

    return normalized;
  }

  String _pinStatusLabel(PaycorePinStatus? status) {
    if (status == null) {
      return 'Henüz sorgulanmadı';
    }

    return status.pinSetFlag ? 'PIN Tanımlı' : 'PIN Tanımsız';
  }

  String _buildCreateCardSuccessMessage(
    NetworkResponse<PaycoreCreatePrepaidCardResult> response,
  ) {
    final data = response.data;
    if (data == null) {
      return response.message ?? 'Kart oluşturma talebi gönderildi.';
    }

    final maskedCardNo = data.maskedCardNo.trim();
    final profileLabel = _resolveCardProfileTitle(data.cardProfile);

    if (maskedCardNo.isEmpty || maskedCardNo == '-') {
      return response.message ?? '$profileLabel kart başarıyla oluşturuldu.';
    }

    return '$profileLabel kart oluşturuldu. Kart: $maskedCardNo';
  }

  String _buildCreateCardErrorMessage(String? rawMessage) {
    final message = rawMessage?.trim();
    if (message == null || message.isEmpty) {
      return 'Kart oluşturulamadı. Lütfen tekrar deneyin.';
    }

    final normalized = message.toLowerCase();

    if (normalized.contains('customerhascardfromthisproduct') ||
        normalized.contains('zaten bir karti var')) {
      return 'Bu kart profilinde zaten bir kartınız var. Yeni kart oluşturulamadı.';
    }

    if (normalized.contains('citydefinitionnotfound') ||
        normalized.contains('il tan') ||
        normalized.contains('sehir kodu tanimli degil')) {
      return 'Adres bilgileri PayCore ile uyumlu değil. İl ve ilçe kodunu kontrol edip adresinizi güncelleyin.';
    }

    if (normalized.contains('urun tanimi bulunamadi') ||
        normalized.contains('productdefinitionnotfound') ||
        normalized.contains('urun kodu : mcpvb') ||
        normalized.contains('urun kodu : mcfzksl')) {
      return 'Seçtiğiniz kart profili şu anda PayCore tarafında tanımlı değil. Lütfen Troy kart profillerinden birini deneyin.';
    }

    if (normalized.contains('timeout') ||
        normalized.contains('httpclient.timeout') ||
        normalized.contains('the request was canceled')) {
      return 'PayCore servisi zamanında yanıt vermedi. Lütfen kısa süre sonra tekrar deneyin.';
    }

    if (normalized.contains('paycore create-prepaid-card exception:')) {
      final cleaned = message
          .replaceFirst('PayCore create-prepaid-card exception:', '')
          .trim();
      return cleaned.isEmpty
          ? 'Kart oluşturulamadı. Lütfen tekrar deneyin.'
          : cleaned;
    }

    if (normalized.contains('paycore create-prepaid-card hatasi')) {
      return 'Kart oluşturulamadı. Lütfen bilgilerinizi kontrol edip tekrar deneyin.';
    }

    return message;
  }

  String _resolveCardProfileTitle(String? cardProfileCode) {
    final normalized = cardProfileCode?.trim().toLowerCase();
    switch (normalized) {
      case 'troy_virtual':
        return 'Troy Sanal';
      case 'troy_physical':
        return 'Troy Fiziki';
      case 'master_virtual':
        return 'Master Sanal';
      case 'master_physical':
        return 'Master Fiziki';
      default:
        return 'PayCore';
    }
  }

  String _getCommunicationTypeLabel(String code) {
    return switch (code) {
      'MP' => 'Telefon',
      'EM' => 'E-posta',
      _ => code,
    };
  }

  String _getAddressTypeLabel(String code) {
    return switch (code) {
      'D' => 'Teslimat Adresi',
      'P' => 'İkamet Adresi',
      'W' => 'İş Adresi',
      _ => code,
    };
  }
}

final class _PaycoreQrScanModal extends StatefulWidget {
  const _PaycoreQrScanModal({
    required this.title,
    required this.description,
    required this.onQrScanned,
    required this.onClose,
  });

  final String title;
  final String description;
  final ValueChanged<String> onQrScanned;
  final VoidCallback onClose;

  @override
  State<_PaycoreQrScanModal> createState() => _PaycoreQrScanModalState();
}

final class _PaycoreQrScanModalState extends State<_PaycoreQrScanModal> {
  late final MobileScannerController _scannerController;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionTimeoutMs: 1000,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    unawaited(_scannerController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MobileScanner(
                  controller: _scannerController,
                  onDetect: (capture) {
                    if (_hasScanned || capture.barcodes.isEmpty) {
                      return;
                    }

                    final value = capture.barcodes.first.rawValue?.trim() ?? '';
                    if (value.isEmpty) {
                      return;
                    }

                    _hasScanned = true;
                    widget.onQrScanned(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
