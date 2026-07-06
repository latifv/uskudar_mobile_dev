import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/core/models/paycore_mobile_models.dart';
import 'package:payinall/core/services/paycore_mobile_service.dart';
import 'package:payinall/data/network/network_client.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/metropol_city.dart';
import 'package:payinall/domain/usecases/get_metropol_cities_usecase.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/constants/icon_asset_constants.dart';
import 'package:payinall/presentation/shared/constants/paycore_card_asset_constants.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

enum _PaycoreModule { customer, cards, security }

final class PaycoreCardsScreen extends StatefulWidget {
  const PaycoreCardsScreen({super.key});

  @override
  State<PaycoreCardsScreen> createState() => _PaycoreCardsScreenState();
}

final class _PaycoreCardsScreenState extends State<PaycoreCardsScreen> {
  late final PaycoreMobileService _paycoreService;
  late final UserInfoManager _userInfoManager;
  late final GetMetropolCitiesUsecase _getMetropolCitiesUsecase;

  bool _isLoading = true;
  String? _loadError;
  final Set<int> _busyCards = <int>{};
  final Set<int> _loadingPinCards = <int>{};

  PaycoreCustomerInfo? _customerInfo;
  List<PaycoreCardSummary> _cards = const [];
  Map<int, PaycorePinStatus> _pinStatuses =
      const <int, PaycorePinStatus>{};
  List<MetropolCity> _metropolCities = const [];
  _PaycoreModule _selectedModule = _PaycoreModule.cards;

  @override
  void initState() {
    super.initState();
    _paycoreService = PaycoreMobileService(getIt<NetworkClient>());
    _userInfoManager = getIt<UserInfoManager>();
    _getMetropolCitiesUsecase = getIt<GetMetropolCitiesUsecase>();
    unawaited(_loadData());
    unawaited(_loadMetropolCities());
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    final cardsResponse = await _paycoreService.getMyCards();
    final customerResponse = await _paycoreService.getCustomerInfo();

    if (!mounted) {
      return;
    }

    final cards = cardsResponse.data ?? const <PaycoreCardSummary>[];
    final customerInfo = customerResponse.data;
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
    return _findMetropolCity(cityName)?.county ?? const <String>[];
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
          _buildTextField(controller: cityNameController, label: 'İl'),
          _buildTextField(controller: townNameController, label: 'İlçe'),
        ],
      );
    }

    return Column(
      children: [
        _buildDropdownField(
          label: 'İl',
          value: selectedCity,
          items: _metropolCities.map((city) => city.city).toList(),
          onChanged: (value) {
            setSheetState(() {
              cityNameController.text = value ?? '';
              townNameController.clear();
            });
          },
        ),
        _buildDropdownField(
          label: 'İlçe',
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
    if (response.isSuccess && response.data != null) {
      nextStatuses[card.id] = response.data!;
    }

    setState(() {
      _loadingPinCards.remove(card.id);
      _pinStatuses = nextStatuses;
    });

    if (!response.isSuccess || response.data == null) {
      if (!silent) {
        _showError(response.message ?? 'PIN durumu alınamadı.');
      }
      return null;
    }

    return response.data;
  }

  Future<void> _showCustomerInfoSheet() async {
    if (_customerInfo == null) {
      final response = await _paycoreService.getCustomerInfo();
      if (!mounted) {
        return;
      }

      if (!response.isSuccess || response.data == null) {
        _showError(response.message ?? 'Müşteri bilgisi alınamadı.');
        return;
      }

      setState(() {
        _customerInfo = response.data;
      });
    }

    final customer = _customerInfo;
    if (customer == null) {
      _showError('Müşteri kaydı bulunamadı.');
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Müşteri Bilgisi',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoGroup(
                'Özet',
                [
                  _buildInfoRow('Ad Soyad', customer.fullName),
                  _buildInfoRow(
                    'Banking Customer No',
                    customer.bankingCustomerNo,
                  ),
                  _buildInfoRow('Customer No', customer.customerNo),
                  _buildInfoRow('TC No', customer.nationalIdentityNo ?? '-'),
                  _buildInfoRow('Cinsiyet', customer.gender ?? '-'),
                  _buildInfoRow(
                    'Doğum Tarihi',
                    _formatDate(customer.birthDate),
                  ),
                  _buildInfoRow(
                    'Primary Card',
                    customer.primaryCardNo?.isNotEmpty ?? false
                        ? customer.primaryCardNo!
                        : '-',
                  ),
                ],
              ),
              if (customer.communications.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildInfoGroup(
                  'İletişim',
                  customer.communications
                      .map(
                        (item) => _buildInfoRow(
                          _getCommunicationTypeLabel(item.communicationType),
                          '${item.info}${item.isDefault ? ' • Varsayılan' : ''}',
                        ),
                      )
                      .toList(),
                ),
              ],
              if (customer.addresses.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildInfoGroup(
                  'Adresler',
                  customer.addresses
                      .map(
                        (address) => _buildInfoRow(
                          _getAddressTypeLabel(address.addressType),
                          _buildAddressSummary(address),
                        ),
                      )
                      .toList(),
                ),
              ],
              if (customer.limits.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildInfoGroup(
                  'Limitler',
                  customer.limits
                      .map(
                        (limit) => _buildInfoRow(
                          'Kullanılabilir Limit',
                          '${limit.currentLimit.toStringAsFixed(2)} ₺'
                              '${limit.isLimitBlocked ? ' • Blokeli' : ''}',
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
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
    var isSubmitting = false;
    String? submitError;

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
          builder: (context, setSheetState) {
            Future<void> submit() async {
              final gender = genderController.text.trim();
              final cityName = cityNameController.text.trim();
              final townName = townNameController.text.trim();
              final townCode = townCodeController.text.trim();
              final cityCode = cityCodeController.text.trim();
              final postalCode = postalCodeController.text.trim();
              final address = addressController.text.trim();

              if ([
                gender,
                cityName,
                townName,
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
                townCode: townCode,
                cityCode: cityCode,
                postalCode: postalCode,
                address: address,
              );

              if (!mounted || !sheetContext.mounted) {
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

              Navigator.of(sheetContext).pop();
              _showSuccess(response.message ?? 'Müşteri kaydı oluşturuldu.');
              await _loadData(silent: true);
              setState(() {
                _selectedModule = _PaycoreModule.customer;
              });
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Müşteri Oluştur',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withValues(
                        alpha: 0.08,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PayCore test kayıtları için çalışan varsayılan adres hazır geldi. Gerekirse alanları düzenleyebilirsin.',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: genderController,
                    label: 'Cinsiyet Kodu',
                    hint: 'M / F',
                  ),
                  _buildCityCountySelectors(
                    setSheetState: setSheetState,
                    cityNameController: cityNameController,
                    townNameController: townNameController,
                  ),
                  _buildTextField(
                    controller: townCodeController,
                    label: 'İlçe Kodu',
                  ),
                  _buildTextField(
                    controller: cityCodeController,
                    label: 'İl Kodu',
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
                  if (submitError != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colorScheme.error.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.colorScheme.error.withValues(
                            alpha: 0.20,
                          ),
                        ),
                      ),
                      child: Text(
                        submitError!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.error,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
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
                          : const Icon(Icons.person_add_alt_1_rounded),
                      label: Text(
                        isSubmitting ? 'Gönderiliyor...' : 'Müşteri Oluştur',
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

    genderController.dispose();
    cityNameController.dispose();
    townNameController.dispose();
    townCodeController.dispose();
    cityCodeController.dispose();
    postalCodeController.dispose();
    addressController.dispose();
  }

  Future<void> _showAddressEditSheet(PaycoreCustomerAddress? address) async {
    if (address == null) {
      _showError('Düzenlenecek adres bulunamadı.');
      return;
    }

    final cityNameController = TextEditingController(
      text: address.city ?? '',
    );
    final townNameController = TextEditingController(
      text: address.town ?? '',
    );
    final townCodeController = TextEditingController(
      text: address.townCode ?? '',
    );
    final cityCodeController = TextEditingController(
      text: address.cityCode ?? '',
    );
    final postalCodeController = TextEditingController(
      text: address.zipCode ?? '',
    );
    final addressController = TextEditingController(
      text: [
        address.address1,
        address.address2,
      ].whereType<String>().where((value) => value.isNotEmpty).join(' '),
    );
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
          builder: (context, setSheetState) {
            Future<void> submit() async {
              final cityName = cityNameController.text.trim();
              final townName = townNameController.text.trim();
              final townCode = townCodeController.text.trim();
              final cityCode = cityCodeController.text.trim();
              final postalCode = postalCodeController.text.trim();
              final addressValue = addressController.text.trim();

              if ([
                cityName,
                townName,
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

              Navigator.of(sheetContext).pop();
              _showSuccess(response.message ?? 'Adres güncellendi.');
              await _loadData(silent: true);
              await _showCustomerInfoSheet();
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Adres Güncelle',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCityCountySelectors(
                    setSheetState: setSheetState,
                    cityNameController: cityNameController,
                    townNameController: townNameController,
                  ),
                  _buildTextField(
                    controller: townCodeController,
                    label: 'İlçe Kodu',
                  ),
                  _buildTextField(
                    controller: cityCodeController,
                    label: 'İl Kodu',
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

    cityNameController.dispose();
    townNameController.dispose();
    townCodeController.dispose();
    cityCodeController.dispose();
    postalCodeController.dispose();
    addressController.dispose();
  }

  Future<void> _showCreateCardSheet() async {
    if (_customerInfo == null) {
      _showError('Önce müşteri kaydını oluştur ya da bilgileri yenile.');
      return;
    }

    final address = _resolvedCreateCardAddress;
    if (address == null) {
      _showError(
        'Kart oluşturmak için kayıtlı müşteri adresi gerekli. Önce adresi güncelle.',
      );
      return;
    }

    var isSubmitting = false;
    var selectedProfile = PaycoreCardCreationProfile.troyVirtual;

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
          builder: (context, setSheetState) {
            Future<void> submit() async {
              setSheetState(() {
                isSubmitting = true;
              });

              final response = await _paycoreService.createPrepaidCard(
                cardProfile: selectedProfile,
                cityCode: address.cityCode,
                cityName: address.cityName,
                townCode: address.townCode,
                townName: address.townName,
                district: address.district,
                address1: address.address1,
                address2: address.address2,
                zipCode: address.zipCode,
              );

              if (!mounted || !sheetContext.mounted) {
                return;
              }

              setSheetState(() {
                isSubmitting = false;
              });

              if (!response.isSuccess) {
                _showError(response.message ?? 'Kart oluşturulamadı.');
                return;
              }

              Navigator.of(sheetContext).pop();
              _showSuccess(
                response.message ?? 'Kart oluşturma talebi gönderildi.',
              );
              await _loadData(silent: true);
              setState(() {
                _selectedModule = _PaycoreModule.cards;
              });
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Yeni Kart Açılışı',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Kart Profili',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...PaycoreCardCreationProfile.values.map((profile) {
                    final isSelected = profile == selectedProfile;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: isSubmitting
                            ? null
                            : () {
                                setSheetState(() {
                                  selectedProfile = profile;
                                });
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.colorScheme.primaryContainer
                                : context.colorScheme.surfaceContainerHighest
                                      .withValues(alpha: 0.42),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? context.colorScheme.primary
                                  : context.colorScheme.outlineVariant,
                              width: isSelected ? 1.4 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 92,
                                child: _buildProfilePreview(profile),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.title,
                                      style: context.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      profile.description,
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                            color: context
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isSelected
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: isSelected
                                    ? context.colorScheme.primary
                                    : context.colorScheme.outline,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 6),
                  _buildInfoCallout(
                    title: 'Kayıtlı Adres Kullanılacak',
                    message: _buildResolvedCreateCardAddressSummary(address),
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
                          : const Icon(Icons.add_card_rounded),
                      label: Text(
                        isSubmitting ? 'Gönderiliyor...' : 'Kart Oluştur',
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
  }

  Future<void> _showCardDetailSheet(PaycoreCardSummary card) async {
    final pinStatus =
        _pinStatuses[card.id] ??
        await _loadPinStatus(card, silent: true);
    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kart Detayı',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCardProductPreview(card),
                const SizedBox(height: 16),
                _buildInfoGroup(
                  'Kart',
                  [
                    _buildInfoRow('Maskeli Kart', card.maskedCardNo),
                    _buildInfoRow('Profil', card.profileLabel),
                    _buildInfoRow('Ürün Kodu', card.productCode ?? '-'),
                    _buildInfoRow('Durum', card.statusName),
                    _buildInfoRow('Kart Tipi', card.cardTypeName),
                    _buildInfoRow('Expiry', card.expiryDate ?? '-'),
                    _buildInfoRow(
                      'Ana Kart',
                      card.isPrimary ? 'Evet' : 'Hayır',
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
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: card.isPrimary
                          ? null
                          : () => unawaited(
                              _runCardAction(card, () => _setPrimaryCard(card)),
                            ),
                      icon: const Icon(Icons.workspace_premium_outlined),
                      label: Text(card.isPrimary ? 'Ana Kart' : 'Ana Kart Yap'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => unawaited(_showSetPinSheet(card)),
                      icon: const Icon(Icons.pin_outlined),
                      label: const Text('PIN Belirle'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPinStatusSheet(PaycoreCardSummary card) async {
    final pinStatus = await _loadPinStatus(card);
    if (!mounted || pinStatus == null) {
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
                pinStatus.pinSetFlag ? 'PIN Tanımlı' : 'PIN Tanımsız',
              ),
              _buildInfoRow(
                'Son PIN Tarihi',
                _formatDateTime(pinStatus.lastPinSetDate),
              ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.onSurfaceVariant,
          ),
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
          builder: (context, setSheetState) {
            Future<void> submit() async {
              final pin = pinController.text.trim();
              final repeatedPin = pinRepeatController.text.trim();

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
              );

              if (!mounted || !sheetContext.mounted) {
                return;
              }

              setSheetState(() {
                isSubmitting = false;
              });

              if (!response.isSuccess) {
                _showError(response.message ?? 'PIN set edilemedi.');
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
                    'PIN Belirle',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.maskedCardNo,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        isSubmitting ? 'Gönderiliyor...' : 'PIN Set Et',
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
  }

  Future<void> _showRandomPinSheet(PaycoreCardSummary card) async {
    var sendBySms = false;
    var isSubmitting = false;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> submit() async {
              setSheetState(() {
                isSubmitting = true;
              });

              final error = await _setRandomPin(
                card,
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
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.maskedCardNo,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
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

  Future<String?> _setRandomPin(
    PaycoreCardSummary card, {
    bool isSendPinBySms = false,
  }) async {
    final response = await _paycoreService.setRandomPin(
      card.id,
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
    final response = await _paycoreService.sendPinBySms(card.id);
    if (!response.isSuccess) {
      return response.message ?? 'PIN SMS gönderilemedi.';
    }

    _showSuccess(response.message ?? 'PIN SMS gönderildi.');
    return null;
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
    final address2 = pickField(
      (address) => address.address2,
      treatZeroAsEmpty: false,
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

  void _showSuccess(String message) {
    ToastComponent.showSuccessToast(context: context, message: message);
  }

  void _showError(String message) {
    ToastComponent.showErrorToast(context: context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Kartlarım'),
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
    if (_isLoading) {
      return const Center(child: CustomLoading());
    }

    final loadError = _loadError;
    if (loadError != null && _cards.isEmpty && _customerInfo == null) {
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
          _buildHeroCard(),
          const SizedBox(height: 12),
          _buildModuleSelector(),
          const SizedBox(height: 14),
          _buildSelectedModule(),
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
    final customer = _customerInfo;

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
                  customer == null ? 'Müşteri Oluştur' : 'Yeniden Oluştur',
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
                    _buildPrimaryPill('Kart Sistemi Aktif'),
                  ],
                ),
                const SizedBox(height: 14),
                _buildTwoColumnInfo(
                  leftLabel: 'Customer No',
                  leftValue: customer.customerNo,
                  rightLabel: 'TC No',
                  rightValue: customer.nationalIdentityNo ?? '-',
                ),
                const SizedBox(height: 12),
                _buildTwoColumnInfo(
                  leftLabel: 'Cinsiyet',
                  leftValue: customer.gender ?? '-',
                  rightLabel: 'Doğum Tarihi',
                  rightValue: _formatDate(customer.birthDate),
                ),
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
                            _getCommunicationTypeLabel(item.communicationType),
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
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (address.isDefault) _buildPrimaryPill('Varsayılan'),
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
          if (customer.limits.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionTitle('Limitler'),
            const SizedBox(height: 10),
            ...customer.limits.map(
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
        ],
      ],
    );
  }

  Widget _buildCardsModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModuleHeader(
          title: 'Kart Açılış',
          description:
              'Yeni prepaid kart üret, mevcut kartları incele ve ana kart atamasını yönet.',
        ),
        const SizedBox(height: 12),
        _buildSurfaceCard(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add_card_rounded,
                  color: context.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yeni Kart Açılışı',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _customerInfo == null
                          ? 'Kart açmadan önce müşteri kaydını oluştur.'
                          : 'Teslimat adresini kontrol edip yeni prepaid kart aç.',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _customerInfo == null ? null : _showCreateCardSheet,
                style: _filledCompactActionStyle(),
                child: const Text('Kart Oluştur'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _buildSectionTitle('Kartların'),
        const SizedBox(height: 10),
        if (_cards.isEmpty)
          _buildEmptyBlock(
            title: 'Kayıtlı kart bulunamadı',
            description:
                'İlk kart açılışını yaptıktan sonra kartların burada maskeli PAN ile listelenecek.',
            icon: Icons.credit_card_off_outlined,
            actionLabel: 'Kart Oluştur',
            onPressed: _customerInfo == null ? null : _showCreateCardSheet,
          )
        else
          ..._cards.map(_buildCardModuleItem),
      ],
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

    return _buildGradientCard(
      card: card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildChip(card.statusName),
              const SizedBox(width: 6),
              _buildChip(card.isActive ? 'Aktif' : 'Pasif'),
              const Spacer(),
              if (card.isPrimary) _buildPrimaryPill('Ana Kart'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            card.maskedCardNo,
            style: context.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${card.profileLabel} • ${card.cardTypeName}',
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.84),
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.embossName?.isNotEmpty ?? false
                ? card.embossName!
                : 'Kart sahibi tanımsız',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'PIN: ${_pinStatusLabel(pinStatus)}',
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              OutlinedButton.icon(
                onPressed: () => unawaited(_showCardDetailSheet(card)),
                style: _cardActionStyle(),
                icon: const Icon(Icons.article_outlined, size: 15),
                label: const Text('Detay'),
              ),
              FilledButton.tonalIcon(
                onPressed: isBusy || card.isPrimary
                    ? null
                    : () => unawaited(
                        _runCardAction(card, () => _setPrimaryCard(card)),
                      ),
                style: FilledButton.styleFrom(
                  foregroundColor: const Color(0xFF143D9C),
                  backgroundColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                icon: const Icon(Icons.workspace_premium_outlined, size: 15),
                label: Text(card.isPrimary ? 'Ana Kart' : 'Ana Kart Ata'),
              ),
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

  Widget _buildGradientCard({
    required PaycoreCardSummary card,
    required Widget child,
  }) {
    final backgroundAsset = PaycoreCardAssetConstants.frontForSummary(card);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(
          image: AssetImage(backgroundAsset),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.05),
              Colors.black.withValues(alpha: 0.16),
              Colors.black.withValues(alpha: 0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
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

  ButtonStyle _cardActionStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: BorderSide(color: Colors.white.withValues(alpha: 0.45)),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      visualDensity: VisualDensity.compact,
      textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool required = true,
    int maxLines = 1,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: selectedValue,
        isExpanded: true,
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          border: const OutlineInputBorder(),
        ),
        items: uniqueItems
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _buildAddressSummary(PaycoreCustomerAddress address) {
    return [
      address.address1,
      if (address.address2?.isNotEmpty ?? false) address.address2,
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
      if (address.address2?.isNotEmpty ?? false) address.address2,
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

  String _pinStatusLabel(PaycorePinStatus? status) {
    if (status == null) {
      return 'Henüz sorgulanmadı';
    }

    return status.pinSetFlag ? 'PIN Tanımlı' : 'PIN Tanımsız';
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
