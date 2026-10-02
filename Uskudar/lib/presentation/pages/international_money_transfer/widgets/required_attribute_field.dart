import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/attribute_item.dart';
import 'package:uskudar_mobile/domain/entities/required_attribute.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dropdown_button_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';

class RequiredAttributeField extends StatefulWidget {
  const RequiredAttributeField({
    required this.attribute,
    required this.onSelected,
    required this.onTextChanged,
    required this.textController,
    this.cardBinPrefixes,
    super.key,
  });

  final RequiredAttribute attribute;
  final void Function(AttributeItem) onSelected;
  final void Function(String) onTextChanged;
  final TextEditingController textController;
  final List<String>? cardBinPrefixes;

  @override
  State<RequiredAttributeField> createState() => _RequiredAttributeFieldState();
}

class _RequiredAttributeFieldState extends State<RequiredAttributeField> {
  AttributeItem? selectedItem;

  String _getDisplayLabel(String displayName) {
    switch (displayName) {
      case 'SEND_REASON':
        return LocaleKeys.send_reason.translate;
      case 'MONEY_RESOURCE':
        return LocaleKeys.money_resource.translate;
      case 'BENEFICIARY_NATIONALITY':
        return LocaleKeys.beneficiary_nationality.translate;
      case 'SENDER_RECIPIENT_RELATIONSHIP':
        return LocaleKeys.sender_recipient_relationship.translate;
      case 'SENDER_OCCUPATION':
        return LocaleKeys.sender_occupation.translate;
      case 'BENEFICIARY_CREDITCARD_NO':
        return LocaleKeys.credit_card_number.translate;
      default:
        return displayName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.attribute.localizationDisplayName ??
        _getDisplayLabel(widget.attribute.displayName);

    return widget.attribute.hasSelectableItems
        ? _buildDropdown(context, label)
        : _buildTextField(context, label);
  }

  Widget _buildDropdown(BuildContext context, String label) {
    return CustomDropdownButtonFormField<AttributeItem>(
      value: selectedItem,
      hintText: label,
      items: widget.attribute.attributeItems!.map((item) {
        return DropdownMenuItem<AttributeItem>(
          value: item,
          child: Text(item.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedItem = value;
          });
          widget.onSelected(value);
        }
      },
      validator: (value) {
        if (value == null) {
          return LocaleKeys.required_field.translate;
        }
        return null;
      },
    );
  }

  Widget _buildTextField(BuildContext context, String label) {
    return CustomTextFormField(
      controller: widget.textController,
      hintText: label,
      labelText: label,
      onChanged: widget.onTextChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return LocaleKeys.required_field.translate;
        }

        if (widget.attribute.displayName == 'BENEFICIARY_CREDITCARD_NO' &&
            widget.cardBinPrefixes != null &&
            widget.cardBinPrefixes!.isNotEmpty) {
          final cardNumber = value.replaceAll(RegExp(r'\s+'), '');
          final hasValidPrefix = widget.cardBinPrefixes!.any(
            cardNumber.startsWith,
          );
          if (!hasValidPrefix) {
            return LocaleKeys.invalid_card_prefix.translate;
          }
        }

        return null;
      },
    );
  }
}
