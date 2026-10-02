import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/wallet_operator.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_dropdown_button_form_field.dart';

class WalletOperatorSelectorWidget extends StatefulWidget {
  const WalletOperatorSelectorWidget({
    required this.walletOperatorList,
    required this.onOperatorSelected,
    super.key,
  });

  final List<WalletOperator> walletOperatorList;
  final void Function(WalletOperator) onOperatorSelected;

  @override
  State<WalletOperatorSelectorWidget> createState() =>
      _WalletOperatorSelectorWidgetState();
}

class _WalletOperatorSelectorWidgetState
    extends State<WalletOperatorSelectorWidget> {
  WalletOperator? selectedOperator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.select_wallet_operator.translate,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingLowHeight,
        CustomDropdownButtonFormField<WalletOperator>(
          value: selectedOperator,
          hintText: LocaleKeys.select_wallet_operator.translate,
          items: widget.walletOperatorList.map((operator) {
            return DropdownMenuItem<WalletOperator>(
              value: operator,
              child: Text(operator.operatorName),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedOperator = value;
              });
              widget.onOperatorSelected(value);
            }
          },
          validator: (value) {
            if (value == null) {
              return LocaleKeys.required_field.translate;
            }
            return null;
          },
        ),
      ],
    );
  }
}
