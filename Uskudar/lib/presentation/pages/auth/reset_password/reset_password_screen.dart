import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/validators/app_validators.dart';
import 'package:uskudar_mobile/presentation/pages/auth/reset_password/bloc/reset_password_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/auth/reset_password/mixin/reset_password_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/constants/validator_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_processing.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/password_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    required this.address,
    this.code,
    this.processCode,
    this.isMerchant = false,
    super.key,
  });

  final String address;
  final String? code;
  final String? processCode;
  final bool isMerchant;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

final class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with ResetPasswordMixin {
  @override
  void initState() {
    super.initState();
    address = widget.address;
    isMerchant = widget.isMerchant;
    processCode = widget.processCode;
    if (widget.code != null) {
      verificationCodeController.text = widget.code!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: blocListener,
        builder: (_, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: const CustomAppBar(),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: context.paddingBase,
                    child: _buildBody(),
                  ),
                ),
              ),
              if (state.status == ResetPasswordStatus.processing)
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
          height: context.dynamicHeight(0.385),
          child: _buildIcon(),
        ),
        _buildHeader(),
        context.spacingNormalHeight,
        _buildForm(),
        context.spacingNormalHeight,
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isMerchant) ...[
            CustomTextFormField(
              hintText: LocaleKeys.customer_number.translate,
              controller: customerNumberController,
              focusNode: customerNumberFocusNode,
              keyboardType: TextInputType.number,
              validator: AppValidators.customerNumber,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(
                  ValidatorConstants.customerNumberLength,
                ),
              ],
            ),
            context.spacingNormalHeight,
          ],
          _buildPasswordInputs(),
          context.spacingNormalHeight,
          Visibility(
            visible: widget.code == null,
            child: CustomTextFormField(
              hintText: LocaleKeys.verification_code.translate,
              controller: verificationCodeController,
              focusNode: verificationCodeFocusNode,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              validator: AppValidators.pinWith6,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(
                  ValidatorConstants.pinLength + 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Center(
      child: Icon(
        Icons.password_outlined,
        size: context.dynamicHeight(0.2),
        color: context.colorScheme.primary,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.reset_password_title.translate,
          style: context.textTheme.headlineSmall,
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.reset_password_description.translate,
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildPasswordInputs() {
    return Column(
      children: [
        PasswordTextFormField(
          hintText: LocaleKeys.new_password.translate,
          passwordController: newPasswordController,
          nextFocusNode: confirmPasswordFocusNode,
          validator: AppValidators.password,
          textInputAction: TextInputAction.next,
        ),
        context.spacingNormalHeight,
        PasswordTextFormField(
          hintText: LocaleKeys.confirm_password.translate,
          passwordController: confirmPasswordController,
          passwordFocusNode: confirmPasswordFocusNode,
          nextFocusNode: verificationCodeFocusNode,
          validator: (value) => AppValidators.confirmPassword(
            value,
            newPasswordController.text,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      onPressed: onSubmitPressed,
      text: LocaleKeys.reset_password_submit.translate,
    );
  }
}
