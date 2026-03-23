import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/pages/add_bank_account/bloc/add_bank_account_bloc.dart';
import 'package:payinall/presentation/pages/add_bank_account/mixin/add_bank_account_mixin.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_processing.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class AddBankAccountScreen extends StatefulWidget {
  const AddBankAccountScreen({super.key});

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

final class _AddBankAccountScreenState extends State<AddBankAccountScreen>
    with AddBankAccountMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<AddBankAccountBloc, AddBankAccountState>(
        listener: blocListener,
        builder: (_, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: CustomAppBar(
                  title: Text(LocaleKeys.add_bank_account.translate),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: context.paddingBase,
                    child: _buildBody(),
                  ),
                ),
              ),
              if (state.state == AddBankAccountBlocState.processing)
                const CustomProcessing(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPersonalAccountNote(),
        context.spacingNormalHeight,
        _buildForm(),
        context.spacingMediumHeight,
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccountNameField(),
          context.spacingNormalHeight,
          _buildIbanField(),
        ],
      ),
    );
  }

  Widget _buildPersonalAccountNote() {
    return Container(
      padding: context.paddingLowAll,
      decoration: BoxDecoration(
        color: context.colorScheme.error.withAlpha(40),
        borderRadius: context.borderRadiusLowAll,
        border: Border.all(color: context.colorScheme.error.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: context.colorScheme.error,
            size: IconSizeConstants.m,
          ),
          context.spacingLowWidth,
          Expanded(
            child: Text(
              LocaleKeys.personal_account_note.translate,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountNameField() {
    return CustomTextFormField(
      controller: accountNameController,
      hintText: LocaleKeys.account_name.translate,
      prefixIcon: const Icon(Icons.person),
      validator: AppValidators.required,
    );
  }

  Widget _buildIbanField() {
    final ibanMaskFormatter = MaskTextInputFormatter(
      mask: 'TR## #### #### #### #### #### ##',
      filter: {'#': RegExp('[0-9]')},
    );

    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            controller: ibanController,
            focusNode: ibanFocusNode,
            hintText: LocaleKeys.iban.translate,
            style: context.textTheme.bodyMedium,
            prefixIcon: const Icon(Icons.credit_card),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            validator: AppValidators.validateIban,
            inputFormatters: [ibanMaskFormatter],
          ),
        ),
        context.spacingLowWidth,
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: context.borderRadiusLowAll,
          ),
          child: IconButton(
            onPressed: onQrScanPressed,
            icon: Icon(
              Icons.qr_code_scanner,
              color: context.colorScheme.onPrimary,
              size: IconSizeConstants.m,
            ),
            tooltip: LocaleKeys.scan_iban_qr.translate,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return PrimaryElevatedButton(
      focusNode: submitFocusNode,
      onPressed: onSubmitPressed,
      text: LocaleKeys.save.translate,
    );
  }
}
