import 'package:flutter/material.dart';
import 'package:payinall/presentation/widgets/price_text_form_field.dart';

final class QrGenerateFormWidget extends StatelessWidget {
  const QrGenerateFormWidget({
    required this.amountController,
    required this.formKey,
    super.key,
  });

  final TextEditingController amountController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(children: [_buildAmountField(context)]),
    );
  }

  Widget _buildAmountField(BuildContext context) {
    return PriceTextFormField(
      priceController: amountController,
      textInputAction: TextInputAction.done,
    );
  }
}
