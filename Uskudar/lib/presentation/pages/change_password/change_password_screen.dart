import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/validators/app_validators.dart';
import 'package:uskudar_mobile/presentation/pages/change_password/bloc/change_password_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/change_password/mixin/change_password_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/password_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';
import 'package:uskudar_mobile/presentation/widgets/tc_number_text_form_field.dart';

@RoutePage()
final class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

final class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with ChangePasswordMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: blocListener,
        builder: (_, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Text(LocaleKeys.change_password.translate),
            ),
            body: state.state == ChangePasswordBlocState.success
                ? const Center(child: CustomLoading())
                : SafeArea(
                    child: SingleChildScrollView(
                      padding: context.paddingBase,
                      child: _buildBody(),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.dynamicHeight(0.3), child: _buildIcon()),
          _buildHeader(),
          context.spacingNormalHeight,
          _buildInputs(),
          context.spacingMediumHeight,
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Center(
      child: Icon(
        Icons.lock_open_outlined,
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
          LocaleKeys.password_change_description.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
        ),
      ],
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        TcNumberTextFormField(
          tcNumberController: identityNumberController,
          tcNumberFocusNode: identityNumberFocusNode,
          nextFocusNode: currentPasswordFocusNode,
        ),
        context.spacingLowHeight,
        PasswordTextFormField(
          hintText: LocaleKeys.current_password.translate,
          passwordController: currentPasswordController,
          passwordFocusNode: currentPasswordFocusNode,
          nextFocusNode: newPasswordFocusNode,
          textInputAction: TextInputAction.next,
          validator: AppValidators.password,
        ),
        context.spacingLowHeight,
        PasswordTextFormField(
          hintText: LocaleKeys.new_password.translate,
          passwordController: newPasswordController,
          passwordFocusNode: newPasswordFocusNode,
          nextFocusNode: confirmPasswordFocusNode,
          textInputAction: TextInputAction.next,
          validator: AppValidators.password,
        ),
        context.spacingLowHeight,
        PasswordTextFormField(
          hintText: LocaleKeys.confirm_password.translate,
          passwordController: confirmPasswordController,
          passwordFocusNode: confirmPasswordFocusNode,
          nextFocusNode: submitFocusNode,
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
      focusNode: submitFocusNode,
      onPressed: onSubmitPressed,
      text: LocaleKeys.change_password.translate,
    );
  }
}
