import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';

final class BirthDateTextFormField extends StatefulWidget {
  const BirthDateTextFormField({
    required this.birthDateController,
    required this.birthDateFocusNode,
    this.nextFocusNode,
    super.key,
  });

  final TextEditingController birthDateController;
  final FocusNode birthDateFocusNode;
  final FocusNode? nextFocusNode;

  @override
  State<BirthDateTextFormField> createState() => _BirthDateTextFormFieldState();
}

final class _BirthDateTextFormFieldState extends State<BirthDateTextFormField> {
  late DateTime _selectedDate;
  late final DateTime _lastDate;
  late final MaskTextInputFormatter _maskFormatter;

  @override
  void initState() {
    super.initState();
    _lastDate = DateTime.now().subtract(const Duration(days: 18 * 365));
    _maskFormatter = MaskTextInputFormatter(
      mask: '##.##.####',
      filter: {'#': RegExp('[0-9]')},
    );
    _initializeDate();
  }

  void _initializeDate() {
    final currentText = widget.birthDateController.text;
    if (currentText.isEmpty) {
      _selectedDate = _lastDate;
    } else {
      _selectedDate =
          DateFormat('dd.MM.yyyy').tryParse(currentText) ?? _lastDate;
      widget.birthDateController.text = DateFormat(
        'dd.MM.yyyy',
      ).format(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.birthDateController,
      focusNode: widget.birthDateFocusNode,
      hintText: LocaleKeys.birth_date.translate,
      validator: AppValidators.requiredDate,
      keyboardType: TextInputType.number,
      inputFormatters: [_maskFormatter],
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_month_outlined),
        onPressed: () => _selectDate(context),
      ),
      onFieldSubmitted: (_) => widget.nextFocusNode?.requestFocus(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    widget.birthDateFocusNode.unfocus();

    final currentText = widget.birthDateController.text;
    var initialDate = _lastDate;

    if (currentText.isNotEmpty) {
      final parsedDate = DateFormat('dd.MM.yyyy').tryParse(currentText);
      if (parsedDate != null &&
          parsedDate.isAfter(DateTime(1924)) &&
          parsedDate.isBefore(_lastDate.add(const Duration(days: 1)))) {
        initialDate = parsedDate;
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1925),
      lastDate: _lastDate,
      locale: context.locale,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        final formattedDate = DateFormat('dd.MM.yyyy').format(picked);
        widget.birthDateController.text = formattedDate;
      });
      widget.nextFocusNode?.requestFocus();
    }
  }
}
