import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/enums/transfer_method.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/pages/transfer/amount/bloc/transfer_amount_bloc.dart';
import 'package:payinall/presentation/pages/transfer/amount/mixin/transfer_amount_mixin.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/double_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/widgets/price_text_form_field.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class TransferAmountScreen extends StatefulWidget {
  const TransferAmountScreen({
    @PathParam('transferMethod') required this.transferMethod,
    @PathParam('walletAddress') this.walletAddress,
    @PathParam('amount') this.amount,
    this.iban,
    this.phone,
    super.key,
  });

  final int transferMethod;
  final String? iban;
  final String? phone;
  final String? walletAddress;
  final double? amount;
  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

final class _TransferAmountScreenState extends State<TransferAmountScreen>
    with TransferAmountMixin {
  @override
  void initState() {
    super.initState();
    transferMethod = widget.transferMethod.toTransferMethod();
    phone = widget.phone;
    walletAddress = widget.walletAddress;
    iban = widget.iban;
    if (widget.amount != null) {
      amountController.text = widget.amount!.toFormattedCurrencyWithOutSymbol();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.transfer_money.translate)),
      body: BlocProvider(
        create: (_) => bloc,
        child: BlocConsumer<TransferAmountBloc, TransferAmountState>(
          listener: blocListener,
          builder: (context, state) {
            if (state.status == TransferAmountStatus.submitting) {
              return const Center(child: CustomLoading());
            }
            return _buildContent(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransferAmountState state) {
    final isMerchant = getIt<UserInfoManager>().isMerchant;
    return SafeArea(
      child: SingleChildScrollView(
        padding: context.paddingBaseLow,
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(context),
                  if (transferMethod == TransferMethod.bankAccount &&
                      (iban == null || iban!.isEmpty) &&
                      !isMerchant)
                    _buildManualBankInputs(context),
                  if (isMerchant &&
                      transferMethod == TransferMethod.bankAccount &&
                      (iban != null && iban!.isNotEmpty))
                    _buildDescriptionOnly(context),
                  _buildAmountSection(context, state),
                  _buildQuickAmountButtons(context),
                ],
              ),
            ),
            context.spacingMediumHeight,
            PrimaryElevatedButton(
              text: LocaleKeys.continue_button.translate,
              onPressed: onContinuePressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualBankInputs(BuildContext context) {
    return Padding(
      padding: context.paddingNormalAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.iban.translate,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          context.spacingLowHeight,
          CustomTextFormField(
            controller: ibanController,
            hintText: LocaleKeys.iban.translate,
            style: context.textTheme.bodyMedium,
            prefixIcon: const Icon(Icons.credit_card),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            validator: AppValidators.validateIban,
            inputFormatters: [
              MaskTextInputFormatter(
                mask: 'TR## #### #### #### #### #### ##',
                filter: {'#': RegExp('[0-9]')},
              ),
            ],
          ),
          context.spacingNormalHeight,
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: firstNameController,
                  hintText: LocaleKeys.first_name.translate,
                ),
              ),
              context.spacingLowWidth,
              Expanded(
                child: CustomTextFormField(
                  controller: lastNameController,
                  hintText: LocaleKeys.last_name.translate,
                ),
              ),
            ],
          ),
          context.spacingNormalHeight,
          _buildDescriptionOnly(context),
        ],
      ),
    );
  }

  Widget _buildDescriptionOnly(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.description.translate,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingLowHeight,
        CustomTextFormField(
          controller: descriptionController,
          hintText: LocaleKeys.description.translate,
          maxLines: 3,
        ),
        context.spacingNormalHeight,
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Padding(
      padding: context.paddingNormalAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.transfer_amount_description.translate,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context, TransferAmountState state) {
    return Padding(
      padding: context.paddingNormalAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              context.spacingLowWidth,
              Text(
                LocaleKeys.enter_amount.translate,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          context.spacingNormalHeight,
          PriceTextFormField(
            priceController: amountController,
            priceFocusNode: amountFocusNode,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmountButtons(BuildContext context) {
    final predefinedAmounts = [
      20.00,
      50.00,
      100.00,
      200.00,
      500.00,
      1000.00,
      2000.00,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            context.spacingLowWidth,
            Text(
              LocaleKeys.amount.translate,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        context.spacingNormalHeight,
        Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: predefinedAmounts.map((amount) {
              return _buildAmountButton(context, amount);
            }).toList(),
          ),
        ),
        context.spacingNormalHeight,
      ],
    );
  }

  Widget _buildAmountButton(BuildContext context, double amount) {
    return InkWell(
      onTap: () => onContinuePressed(
        quickAmount: amount.toFormattedCurrencyWithOutSymbol(),
      ),
      borderRadius: context.borderRadiusLowAll,
      child: Ink(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: context.borderRadiusLowAll,
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.onSurface.withAlpha(26),
              blurRadius: 5,
            ),
          ],
        ),
        child: Container(
          padding: context.paddingLowAll,
          child: Text(
            amount.toFormattedCurrency(),
            style: context.textTheme.displayLarge,
          ),
        ),
      ),
    );
  }
}
