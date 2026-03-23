import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';

final class CustomSelectDate extends StatefulWidget {
  const CustomSelectDate({
    required this.birthDateController,
    required this.birthDateFocusNode,
    this.nextFocusNode,
    super.key,
  });

  final TextEditingController birthDateController;
  final FocusNode birthDateFocusNode;
  final FocusNode? nextFocusNode;

  @override
  State<CustomSelectDate> createState() => _CustomSelectDateState();
}

final class _CustomSelectDateState extends State<CustomSelectDate> {
  late DateTime _selectedDate;
  late final DateTime _lastDate;
  late final MaskTextInputFormatter _maskFormatter;

  @override
  void initState() {
    _lastDate = DateTime.now().subtract(const Duration(days: 18 * 365));
    _maskFormatter = MaskTextInputFormatter(
      mask: '##.##.####',
      filter: {'#': RegExp('[0-9]')},
    );
    _initializeDate();
    super.initState();
  }

  void _initializeDate() {
    final currentText = widget.birthDateController.text;
    if (currentText.isEmpty) {
      _selectedDate = _lastDate;
      widget.birthDateController.text = DateFormat(
        'dd.MM.yyyy',
      ).format(_selectedDate);
    } else {
      _selectedDate =
          DateFormat('dd.MM.yyyy').tryParse(currentText) ?? _lastDate;
      widget.birthDateController.text = DateFormat(
        'dd.MM.yyyy',
      ).format(_selectedDate);
    }
    _maskFormatter.updateMask(
      mask: '##.##.####',
      filter: {'#': RegExp('[0-9]')},
      newValue: TextEditingValue(text: widget.birthDateController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: CustomTextFormField(
          controller: widget.birthDateController,
          focusNode: widget.birthDateFocusNode,
          hintText: LocaleKeys.birth_date.translate,
          validator: AppValidators.requiredDate,
          keyboardType: TextInputType.datetime,
          suffixIcon: const Icon(Icons.calendar_month_outlined),
          onFieldSubmitted: (_) => widget.nextFocusNode?.requestFocus(),
          inputFormatters: [_maskFormatter],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1925),
      lastDate: _lastDate,
      locale: context.locale,
      keyboardType: TextInputType.datetime,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        final formattedDate = DateFormat('dd.MM.yyyy').format(picked);
        widget.birthDateController.text = formattedDate;
        _maskFormatter.updateMask(
          mask: '##.##.####',
          filter: {'#': RegExp('[0-9]')},
          newValue: TextEditingValue(text: formattedDate),
        );
      });
      // widget.nextFocusNode?.requestFocus();
    }
  }
}
