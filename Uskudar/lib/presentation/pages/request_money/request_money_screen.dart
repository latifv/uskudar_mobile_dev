import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/pages/request_money/bloc/request_money_bloc.dart';
import 'package:payinall/presentation/pages/request_money/mixin/request_money_mixin.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/widgets/phone_number_text_form_field.dart';
import 'package:payinall/presentation/widgets/price_text_form_field.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class RequestMoneyScreen extends StatefulWidget {
  const RequestMoneyScreen({super.key});

  @override
  State<RequestMoneyScreen> createState() => _RequestMoneyScreenState();
}

final class _RequestMoneyScreenState extends State<RequestMoneyScreen>
    with RequestMoneyMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.request_money.translate)),
      body: BlocProvider(
        create: (context) => bloc,
        child: BlocListener<RequestMoneyBloc, RequestMoneyState>(
          listener: blocListener,
          child: BlocBuilder<RequestMoneyBloc, RequestMoneyState>(
            builder: (context, state) {
              if (state.status == RequestMoneyStatus.loading) {
                return const Center(child: CustomLoading());
              }
              return SingleChildScrollView(
                padding: context.paddingBase,
                child: Form(key: formKey, child: _buildBody(state)),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(RequestMoneyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.spacingLowHeight,
        _buildMethodSelection(state.isPhoneMethod),
        context.spacingMediumHeight,
        _buildAmountField(state.amountError),
        context.spacingMediumHeight,
        if (state.isPhoneMethod)
          _buildPhoneField(state.phoneError)
        else ...[
          _buildWalletField(state.walletError),
          context.spacingLowHeight,
          _buildQrGenerateCard(context),
        ],
        context.spacingMediumHeight,
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildMethodSelection(bool isPhoneMethod) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMethodOption(
                isSelected: isPhoneMethod,
                title: LocaleKeys.phone.translate,
                onTap: () => toggleMethod(true),
              ),
            ),
            context.spacingNormalWidth,
            Expanded(
              child: _buildMethodOption(
                isSelected: !isPhoneMethod,
                title: LocaleKeys.wallet.translate,
                onTap: () => toggleMethod(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodOption({
    required bool isSelected,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.onSurface.withAlpha(25)
              : context.colorScheme.onSurface.withAlpha(10),
          borderRadius: context.borderRadiusLowAll,
          border: Border.all(
            color: isSelected
                ? context.colorScheme.onSurface.withAlpha(50)
                : context.colorScheme.onSurface.withAlpha(25),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: isSelected
                  ? context.colorScheme.onSurface.withAlpha(164)
                  : context.colorScheme.onSurface.withAlpha(100),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField(String? errorText) {
    return PriceTextFormField(
      priceController: amountController,
      priceFocusNode: amountFocusNode,
    );
  }

  Widget _buildPhoneField(String? errorText) {
    return PhoneNumberTextFormField(
      phoneNumberController: phoneController,
      nextFocusNode: walletFocusNode,
    );
  }

  Widget _buildWalletField(String? errorText) {
    return CustomTextFormField(
      controller: walletController,
      focusNode: walletFocusNode,
      hintText: LocaleKeys.wallet_address.translate,
      suffixIcon: const Icon(Icons.account_balance_wallet_outlined),
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: '############',
          filter: {'#': RegExp('[0-9]')},
        ),
      ],
      validator: AppValidators.required,
    );
  }

  Widget _buildQrGenerateCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: context.borderRadiusLowAll,
        border: Border.all(color: context.colorScheme.outline.withAlpha(102)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            unawaited(context.router.push(const QrGenerateRoute()));
          },
          borderRadius: context.borderRadiusLowAll,
          child: Padding(
            padding: context.paddingNormalAll,
            child: Row(
              children: [
                Container(
                  padding: context.paddingLowAll,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withAlpha(51),
                    borderRadius: context.borderRadiusLowAll,
                  ),
                  child: Icon(
                    Icons.qr_code_2_outlined,
                    color: context.colorScheme.primary,
                    size: IconSizeConstants.n,
                  ),
                ),
                context.spacingNormalWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.qr_generate_for_request.translate,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      context.spacingLowHeight,
                      Text(
                        LocaleKeys
                            .qr_generate_for_request_description
                            .translate,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: context.colorScheme.onSurface.withAlpha(153),
                  size: IconSizeConstants.s,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      onPressed: onSendRequest,
      text: LocaleKeys.request_money.translate,
    );
  }
}
