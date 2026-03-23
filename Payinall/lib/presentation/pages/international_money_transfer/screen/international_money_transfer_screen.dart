import 'package:auto_route/auto_route.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field_v2/intl_phone_field.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/corporation_attribute.dart';
import 'package:payinall/presentation/pages/international_money_transfer/bloc/international_money_transfer_bloc.dart';
import 'package:payinall/presentation/pages/international_money_transfer/mixin/international_money_transfer_mixin.dart';
import 'package:payinall/presentation/pages/international_money_transfer/widgets/bic_bank_selector_widget.dart';
import 'package:payinall/presentation/pages/international_money_transfer/widgets/office_selector_widget.dart';
import 'package:payinall/presentation/pages/international_money_transfer/widgets/required_attribute_field.dart';
import 'package:payinall/presentation/pages/international_money_transfer/widgets/wallet_operator_selector_widget.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
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
final class InternationalMoneyTransferScreen extends StatefulWidget {
  const InternationalMoneyTransferScreen({
    @PathParam('countryCode') this.countryCode,
    @PathParam('transactionTypeCode') this.transactionTypeCode,
    super.key,
  });

  final String? countryCode;
  final String? transactionTypeCode;

  @override
  State<InternationalMoneyTransferScreen> createState() =>
      _InternationalMoneyTransferScreenState();
}

final class _InternationalMoneyTransferScreenState
    extends State<InternationalMoneyTransferScreen>
    with InternationalMoneyTransferMixin {
  @override
  void initState() {
    super.initState();
    if (widget.countryCode != null && widget.countryCode!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadAttributes(
          widget.countryCode!,
          transactionType: widget.transactionTypeCode ?? '001',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.international_money_transfer.translate),
      ),
      body: BlocProvider.value(
        value: bloc,
        child:
            BlocConsumer<
              InternationalMoneyTransferBloc,
              InternationalMoneyTransferState
            >(
              listener: blocListener,
              builder: (context, state) {
                if (state.status ==
                    InternationalMoneyTransferStatus.loadingAttributes) {
                  return const Center(child: CustomLoading());
                }

                if (state.status == InternationalMoneyTransferStatus.error &&
                    state.corporationAttributes == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message ?? LocaleKeys.general_error.translate,
                          textAlign: TextAlign.center,
                        ),
                        context.spacingNormalHeight,
                        PrimaryElevatedButton(
                          text: LocaleKeys.retry.translate,
                          onPressed: () => loadAttributes(selectedCountryCode),
                        ),
                      ],
                    ),
                  );
                }

                return _buildContent(context, state);
              },
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    InternationalMoneyTransferState state,
  ) {
    final corporation = state.selectedCorporation;
    if (corporation == null) {
      return const Center(
        child: CustomLoading(),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeTextControllers(corporation.requiredAttributeList);

      if (!transactionTypeDataLoaded) {
        transactionTypeDataLoaded = true;
        final attributeNames = corporation.requiredAttributeList
            .map((attr) => attr.displayName)
            .toList();
        loadTransactionTypeData(
          countryCode: selectedCountryCode,
          transactionTypeCode: selectedTransactionType,
          corporationCode: corporation.corporationCode,
          requiredAttributeNames: attributeNames,
        );
      }
    });

    return SafeArea(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          padding: context.paddingNormalAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectedCountryInfo(context),
              context.spacingNormalHeight,
              _buildCorporationSelector(context, state),
              context.spacingNormalHeight,
              _buildBeneficiarySection(context),
              if (corporation.requiredAttributeList.isNotEmpty) ...[
                context.spacingNormalHeight,
                _buildRequiredAttributesSection(context, corporation, state),
              ],
              if (state.bicBankList != null &&
                  state.bicBankList!.isNotEmpty) ...[
                context.spacingNormalHeight,
                BicBankSelectorWidget(
                  bicBankList: state.bicBankList!,
                  onBankSelected: onBankSelected,
                ),
              ],
              if (state.officeList != null && state.officeList!.isNotEmpty) ...[
                context.spacingNormalHeight,
                OfficeSelectorWidget(
                  officeList: state.officeList!,
                  onOfficeSelected: onOfficeSelected,
                ),
              ],
              if (state.walletOperatorList != null &&
                  state.walletOperatorList!.isNotEmpty) ...[
                context.spacingNormalHeight,
                WalletOperatorSelectorWidget(
                  walletOperatorList: state.walletOperatorList!,
                  onOperatorSelected: onWalletOperatorSelected,
                ),
              ],
              context.spacingMediumHeight,
              _buildSubmitButton(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorporationSelector(
    BuildContext context,
    InternationalMoneyTransferState state,
  ) {
    final corporations = state.corporationAttributes ?? [];
    final selectedCorporation = state.selectedCorporation;
    if (selectedCorporation == null || corporations.isEmpty) {
      return const Center(child: CustomLoading());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.corporation.translate,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingLowHeight,
        ListView.separated(
          itemCount: corporations.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, _) => context.spacingLowHeight,
          itemBuilder: (context, index) {
            final corporation = corporations[index];
            final isSelected =
                corporation.corporationCode ==
                selectedCorporation.corporationCode;
            return _buildCorporationTile(
              context: context,
              corporation: corporation,
              isSelected: isSelected,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCorporationTile({
    required BuildContext context,
    required CorporationAttribute corporation,
    required bool isSelected,
  }) {
    final backgroundColor = isSelected
        ? context.colorScheme.primaryContainer
        : context.colorScheme.surfaceVariant;
    final foregroundColor = isSelected
        ? context.colorScheme.onPrimaryContainer
        : context.colorScheme.onSurface;
    final secondaryColor = isSelected
        ? context.colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
        : context.colorScheme.onSurfaceVariant;

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusNormalAll,
        side: BorderSide(
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: context.borderRadiusNormalAll,
        onTap: () => onCorporationSelected(corporation),
        child: Padding(
          padding: context.paddingNormalAll,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? context.colorScheme.onPrimaryContainer
                    : context.colorScheme.onSurfaceVariant,
              ),
              context.spacingNormalWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      corporation.corporationName,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: foregroundColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    context.spacingLowHeight,
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          size: context.normalHeight,
                          color: secondaryColor,
                        ),
                        context.spacingLowWidth,
                        Text(
                          corporation.currencyCode,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: secondaryColor,
                          ),
                        ),
                        context.spacingNormalWidth,
                        Icon(
                          Icons.confirmation_number,
                          size: context.normalHeight,
                          color: secondaryColor,
                        ),
                        context.spacingLowWidth,
                        Flexible(
                          child: Text(
                            corporation.corporationCode,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: secondaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCountryInfo(BuildContext context) {
    if (selectedCountryCode.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: context.paddingNormalAll,
        child: Row(
          children: [
            Flag.fromString(
              selectedCountryCode,
              width: 32,
              height: 32,
            ),
            context.spacingNormalWidth,
            Expanded(
              child: Text(
                selectedCountryCode,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeneficiarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.beneficiary_information.translate,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingNormalHeight,
        CustomTextFormField(
          controller: nameController,
          hintText: LocaleKeys.first_name.translate,
          labelText: LocaleKeys.first_name.translate,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return LocaleKeys.enter_first_name.translate;
            }
            return null;
          },
        ),
        context.spacingNormalHeight,
        CustomTextFormField(
          controller: surnameController,
          hintText: LocaleKeys.last_name.translate,
          labelText: LocaleKeys.last_name.translate,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return LocaleKeys.enter_last_name.translate;
            }
            return null;
          },
        ),
        context.spacingNormalHeight,
        IntlPhoneField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: LocaleKeys.phone_number.translate,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: context.borderRadiusLowAll,
            ),
          ),
          initialCountryCode: 'TR',
          autovalidateMode: AutovalidateMode.disabled,
          invalidNumberMessage: LocaleKeys.invalid_phone_number.translate,
          onChanged: (phone) {
            phoneCountryCode = phone.countryCode.replaceAll('+', '');
          },
          validator: (phone) {
            if (phone == null || phone.number.isEmpty) {
              return LocaleKeys.enter_phone_number.translate;
            }
            return null;
          },
        ),
        context.spacingNormalHeight,
        PriceTextFormField(
          priceController: amountController,
          hideSuffixText: true,
        ),
      ],
    );
  }

  Widget _buildRequiredAttributesSection(
    BuildContext context,
    CorporationAttribute corporation,
    InternationalMoneyTransferState state,
  ) {
    if (corporation.requiredAttributeList.isEmpty) {
      return const SizedBox.shrink();
    }

    final cardBinPrefixes = state.cardBinList?.map((e) => e.prefix).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.required_information.translate,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingNormalHeight,
        ...corporation.requiredAttributeList
            .where((attr) => !_isHiddenAttribute(attr.displayName))
            .expand<Widget>((attr) {
              return [
                RequiredAttributeField(
                  key: ValueKey(
                    '${corporation.corporationCode}_${attr.displayName}',
                  ),
                  attribute: attr,
                  textController: getTextController(attr.displayName),
                  onSelected: (item) =>
                      onAttributeSelected(attr.displayName, item),
                  onTextChanged: (value) =>
                      onTextAttributeChanged(attr.displayName, value),
                  cardBinPrefixes:
                      attr.displayName == 'BENEFICIARY_CREDITCARD_NO'
                      ? cardBinPrefixes
                      : null,
                ),
                context.spacingNormalHeight,
              ];
            })
            .toList()
          ..removeLast(),
      ],
    );
  }

  bool _isHiddenAttribute(String displayName) {
    const hiddenAttributes = [
      'WALLET_OPERATOR_CODE',
      'BENEFICIARY_BANK_BIC_CODE',
      'BENEFICIARY_BANK_CODE',
      'BENEFICIARY_OFFICE',
    ];
    return hiddenAttributes.contains(displayName);
  }

  Widget _buildSubmitButton(
    BuildContext context,
    InternationalMoneyTransferState state,
  ) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryElevatedButton(
        text: LocaleKeys.continue_text.translate,
        onPressed: onSubmitPressed,
      ),
    );
  }
}
