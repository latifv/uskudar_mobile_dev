import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/enums/login_type.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/pages/auth/login/widgets/login_type_segmented_button.dart';
import 'package:payinall/presentation/pages/auth/security_forgot_password/bloc/security_forgot_password_bloc.dart';
import 'package:payinall/presentation/pages/auth/security_forgot_password/mixin/security_forgot_password_mixin.dart';
import 'package:payinall/presentation/shared/constants/validator_constants.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_processing.dart';
import 'package:payinall/presentation/widgets/custom_text_button.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/widgets/phone_number_text_form_field.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/presentation/widgets/tc_number_text_form_field.dart';

@RoutePage()
final class SecurityForgotPasswordScreen extends StatefulWidget {
  const SecurityForgotPasswordScreen({super.key});

  @override
  State<SecurityForgotPasswordScreen> createState() =>
      _SecurityForgotPasswordScreenState();
}

final class _SecurityForgotPasswordScreenState
    extends State<SecurityForgotPasswordScreen>
    with SecurityForgotPasswordMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child:
          BlocConsumer<SecurityForgotPasswordBloc, SecurityForgotPasswordState>(
            listener: blocListener,
            builder: (_, state) {
              return Stack(
                children: [
                  Scaffold(
                    body: SafeArea(
                      child: SingleChildScrollView(
                        padding: context.paddingBase,
                        child: _buildBody(),
                      ),
                    ),
                  ),
                  if (state.status == SecurityForgotPasswordStatus.processing)
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
        SizedBox(
          height: context.dynamicHeight(0.325),
          child: _buildIcon(),
        ),
        context.spacingNormalHeight,
        _buildLoginTypeSelector(),
        context.spacingMediumHeight,
        _buildInformation(),
        context.spacingMediumHeight,
        _buildForm(),
        context.spacingMediumHeight,
        _buildSubmitButton(),
        context.spacingLowHeight,
        _buildLoginRedirect(),
      ],
    );
  }

  Widget _buildInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.forgot_password_title.translate,
          style: context.textTheme.headlineSmall,
        ),
        context.spacingLowHeight,
        Text(LocaleKeys.forgot_password_security_description.translate),
      ],
    );
  }

  Widget _buildLoginTypeSelector() {
    return BlocBuilder<SecurityForgotPasswordBloc, SecurityForgotPasswordState>(
      bloc: bloc,
      builder: (_, state) {
        return LoginTypeSegmentedButton(
          selectedLoginType: state.loginType,
          onSelectionChanged: onLoginTypeChanged,
        );
      },
    );
  }

  Widget _buildForm() {
    return BlocBuilder<SecurityForgotPasswordBloc, SecurityForgotPasswordState>(
      bloc: bloc,
      builder: (_, state) {
        return Form(
          key: formKey,
          child: state.loginType == LoginType.merchant
              ? _buildMerchantForm()
              : _buildIndividualForm(),
        );
      },
    );
  }

  Widget _buildIndividualForm() {
    return TcNumberTextFormField(tcNumberController: tcNumberController);
  }

  Widget _buildMerchantForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          hintText: LocaleKeys.customer_number.translate,
          controller: customerNumberController,
          keyboardType: TextInputType.number,
          focusNode: customerNumberFocusNode,
          suffixIcon: const Icon(Icons.person_outline),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(
              ValidatorConstants.customerNumberLength,
            ),
          ],
          validator: AppValidators.customerNumber,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(phoneNumberFocusNode);
          },
        ),
        context.spacingLowHeight,
        PhoneNumberTextFormField(
          phoneNumberController: phoneNumberController,
          phoneNumberFocusNode: phoneNumberFocusNode,
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Center(
      child: Icon(
        Icons.lock_person,
        color: context.colorScheme.primary,
        size: context.dynamicWidth(0.325),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      onPressed: onSubmitPressed,
      text: LocaleKeys.continue_button.translate,
    );
  }

  Widget _buildLoginRedirect() {
    return CustomTextButton(
      color: context.colorScheme.onSurface,
      onPressed: () {
        context.router.pop();
      },
      text: LocaleKeys.give_up.translate,
    );
  }
}
