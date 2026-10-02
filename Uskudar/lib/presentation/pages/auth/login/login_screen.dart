import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/enums/login_type.dart';
import 'package:uskudar_mobile/domain/validators/app_validators.dart';
import 'package:uskudar_mobile/presentation/pages/auth/login/bloc/login_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/auth/login/mixin/login_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/auth/login/widgets/login_type_segmented_button.dart';
import 'package:uskudar_mobile/presentation/shared/constants/validator_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_checkbox.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_processing.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_button.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/info_dialog.dart';
import 'package:uskudar_mobile/presentation/widgets/logo_image.dart';
import 'package:uskudar_mobile/presentation/widgets/password_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/phone_number_and_tc_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/phone_number_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';
import 'package:uskudar_mobile/presentation/widgets/surface_elevated_button.dart';

@RoutePage()
final class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.phoneNumber,
    this.isSessionExpired = false,
    this.notAcceptableMessage,
  });

  final String? phoneNumber;
  final bool isSessionExpired;
  final String? notAcceptableMessage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final class _LoginScreenState extends State<LoginScreen> with LoginMixin {
  final _logoHeightFactor = .075;

  @override
  void initState() {
    phoneNumberController = TextEditingController();
    if (widget.phoneNumber?.isNotEmpty ?? false) {
      phoneNumberController.text = widget.phoneNumber!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isSessionExpired) {
        unawaited(
          InfoDialog.show(
            context: context,
            title: LocaleKeys.session_expired_title.translate,
            description: LocaleKeys.session_expired.translate,
            icon: Icons.warning,
            iconColor: context.colorScheme.error,
            buttonActive: false,
            descriptionStyle: context.textTheme.bodyMedium,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      if (widget.notAcceptableMessage != null) {
        unawaited(
          InfoDialog.show(
            context: context,
            title: LocaleKeys.warning.translate,
            description: widget.notAcceptableMessage!,
            icon: Icons.warning,
            iconColor: context.colorScheme.error,
            buttonActive: false,
            descriptionStyle: context.textTheme.bodyMedium,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<LoginBloc, LoginState>(
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
              if (state.status == LoginBlocStatus.processing)
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
          height: context.dynamicHeight(0.225),
          child: _buildHeader(),
        ),
        context.spacingNormalHeight,
        _buildLoginTypeSelector(),
        context.spacingNormalHeight,
        Text(
          LocaleKeys.login_with.translate,
          style: context.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingNormalHeight,
        _buildForm(),
        context.spacingNormalHeight,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRememberMeCheckbox(),
            _buildForgotPassword(),
          ],
        ),
        SizedBox(height: context.dynamicHeight(0.05)),
        _buildLogin(),
        context.spacingLowHeight,
        _buildCreateAccount(),
        context.spacingLowHeight,
      ],
    );
  }

  Widget _buildHeader() {
    return Center(child: LogoImage(heightFactor: _logoHeightFactor));
  }

  Widget _buildLogin() {
    return PrimaryElevatedButton(
      focusNode: loginFocusNode,
      onPressed: onLoginPressed,
      text: LocaleKeys.login.translate,
    );
  }

  Widget _buildCreateAccount() {
    return SurfaceElevatedButton(
      onPressed: onCreateAccountPressed,
      text: LocaleKeys.create_account.translate,
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        StreamBuilder<bool>(
          stream: bloc.rememberMeStream,
          initialData: bloc.rememberMe,
          builder: (_, snapshot) {
            return CustomCheckbox(
              value: snapshot.data,
              onChanged: (value) => onRememberMeChanged(value: value),
            );
          },
        ),
        context.spacingNormalWidth,
        Text(
          LocaleKeys.remember_me.translate,
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return CustomTextButton(
      alignment: Alignment.centerRight,
      onPressed: onForgotPasswordPressed,
      text: LocaleKeys.forgot_password.translate,
    );
  }

  Widget _buildForm() {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: bloc,
      builder: (_, state) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.loginType == LoginType.merchant) ...[
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
                  nextFocusNode: passwordFocusNode,
                ),
              ] else
                _buildIdentifierField(),
              context.spacingLowHeight,
              PasswordTextFormField(
                passwordController: passwordController,
                passwordFocusNode: passwordFocusNode,
                nextFocusNode: loginFocusNode,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginTypeSelector() {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: bloc,
      builder: (_, state) {
        return LoginTypeSegmentedButton(
          selectedLoginType: state.loginType,
          onSelectionChanged: onLoginTypeChanged,
        );
      },
    );
  }

  Widget _buildIdentifierField() {
    return PhoneNumberAndTCTextFormField(
      phoneNumberController: phoneNumberController,
      nextFocusNode: passwordFocusNode,
    );
  }
}
