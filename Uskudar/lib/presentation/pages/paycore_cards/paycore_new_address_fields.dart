import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uskudar_mobile/domain/entities/metropol_city.dart';

/// New-address forms never populate fields from stored customer addresses.
class PaycoreNewAddressFields extends StatefulWidget {
  const PaycoreNewAddressFields({
    required this.cities,
    required this.city,
    required this.town,
    required this.district,
    required this.street,
    required this.zip,
    super.key,
  });

  final List<MetropolCity> cities;
  final TextEditingController city;
  final TextEditingController town;
  final TextEditingController district;
  final TextEditingController street;
  final TextEditingController zip;
  static String? validationError(String street, String district, String zip) {
    if (street.trim().isEmpty) return 'Açık adres zorunludur.';
    if (street.trim().length > 200) return 'Açık adres en fazla 200 karakter olmalıdır.';
    if (district.trim().isEmpty) return 'Semt / mahalle zorunludur.';
    if (district.trim().length > 50) return 'Semt / mahalle en fazla 50 karakter olmalıdır.';
    if (!RegExp(r'^\d{5}$').hasMatch(zip.trim())) return 'Posta kodu 5 rakam olmalıdır.';
    return null;
  }

  @override
  State<PaycoreNewAddressFields> createState() =>
      _PaycoreNewAddressFieldsState();
}

class _PaycoreNewAddressFieldsState extends State<PaycoreNewAddressFields> {
  Widget textField(
    String label,
    TextEditingController controller, {
    bool required = true,
    TextInputType? keyboard,
    int? limit,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLength: limit,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          border: const OutlineInputBorder(),
          errorText: limit != null && controller.text.trim().length > limit
              ? '$label en fazla $limit karakter olmalıdır.'
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cities = {for (final city in widget.cities) city.city: city.county};
    final counties = (cities[widget.city.text] ?? <String>[]).toSet().toList();
    return Column(
      children: [
        if (cities.isEmpty)
          const Text(
            'İl ve ilçe listesi yüklenemedi. Lütfen ekranı yeniden açın.',
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField<String>(
            key: ValueKey('city-${widget.city.text}'),
            initialValue: cities.containsKey(widget.city.text)
                ? widget.city.text
                : null,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'İl *',
              border: OutlineInputBorder(),
            ),
            items: cities.keys
                .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                .toList(),
            onChanged: cities.isEmpty
                ? null
                : (city) => setState(() {
                    widget.city.text = city ?? '';
                    widget.town.clear();
                  }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField<String>(
            key: ValueKey('town-${widget.city.text}-${widget.town.text}'),
            initialValue: counties.contains(widget.town.text)
                ? widget.town.text
                : null,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'İlçe *',
              border: OutlineInputBorder(),
            ),
            items: counties
                .map((town) => DropdownMenuItem(value: town, child: Text(town)))
                .toList(),
            onChanged: counties.isEmpty
                ? null
                : (town) => setState(() {
                    widget.town.text = town ?? '';
                  }),
          ),
        ),
        textField('Semt / Mahalle', widget.district, limit: 50),
        textField('Posta Kodu', widget.zip, keyboard: TextInputType.number),
        textField('Açık Adres', widget.street, limit: 200, keyboard: TextInputType.multiline),
      ],
    );
  }
}
