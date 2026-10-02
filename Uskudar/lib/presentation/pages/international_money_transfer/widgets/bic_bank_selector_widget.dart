import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/bic_bank.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/custom_dropdown_button_form_field.dart';

class BicBankSelectorWidget extends StatefulWidget {
  const BicBankSelectorWidget({
    required this.bicBankList,
    required this.onBankSelected,
    super.key,
  });

  final List<BicBank> bicBankList;
  final void Function(BicBank bank) onBankSelected;

  @override
  State<BicBankSelectorWidget> createState() => _BicBankSelectorWidgetState();
}

class _BicBankSelectorWidgetState extends State<BicBankSelectorWidget> {
  BicBank? selectedBank;

  @override
  Widget build(BuildContext context) {
    return CustomDropdownButtonFormField<BicBank>(
      value: selectedBank,
      hintText: LocaleKeys.select_bank.translate,
      items: widget.bicBankList.map((bank) {
        return DropdownMenuItem<BicBank>(
          value: bank,
          child: Text(
            bank.name.isNotEmpty ? bank.name : bank.branchName,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedBank = value;
          });
          widget.onBankSelected(value);
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
}
