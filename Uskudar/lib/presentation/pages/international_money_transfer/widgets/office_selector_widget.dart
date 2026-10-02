import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/office.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dropdown_button_form_field.dart';

class OfficeSelectorWidget extends StatefulWidget {
  const OfficeSelectorWidget({
    required this.officeList,
    required this.onOfficeSelected,
    super.key,
  });

  final List<Office> officeList;
  final void Function(Office office) onOfficeSelected;

  @override
  State<OfficeSelectorWidget> createState() => _OfficeSelectorWidgetState();
}

class _OfficeSelectorWidgetState extends State<OfficeSelectorWidget> {
  Office? selectedOffice;

  @override
  Widget build(BuildContext context) {
    return CustomDropdownButtonFormField<Office>(
      value: selectedOffice,
      hintText: LocaleKeys.select_office.translate,
      items: widget.officeList.map((office) {
        return DropdownMenuItem<Office>(
          value: office,
          child: Text(
            office.officeName,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedOffice = value;
          });
          widget.onOfficeSelected(value);
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
