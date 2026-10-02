import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/validators/app_validators.dart';
import 'package:uskudar_mobile/presentation/pages/auth/set_password/bloc/set_password_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/auth/set_password/mixin/set_password_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_processing.dart';
import 'package:uskudar_mobile/presentation/widgets/password_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({
    required this.phoneNumber,
    required this.code,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.tcNo,
    required this.birthDate,
    required this.userQuestionId,
    required this.secretQuestion,
    required this.seriNo,
    super.key,
  });

  final String phoneNumber;
  final String code;
  final String email;
  final String firstName;
  final String lastName;
  final String tcNo;
  final String birthDate;
  final int userQuestionId;
  final String secretQuestion;
  final String seriNo;
  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

final class _SetPasswordScreenState extends State<SetPasswordScreen>
    with SetPasswordMixin {
  @override
  void initState() {
    super.initState();
    firstName = widget.firstName;
    lastName = widget.lastName;
    tcNo = widget.tcNo;
    email = widget.email;
    phoneNumber = widget.phoneNumber;
    birthDate = widget.birthDate;
    code = widget.code;
    userQuestionId = widget.userQuestionId;
    secretQuestion = widget.secretQuestion;
    seriNo = widget.seriNo;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<SetPasswordBloc, SetPasswordState>(
        listener: blocListener,
        builder: (_, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: CustomAppBar(
                  title: Text(
                    LocaleKeys.security.translate,
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: context.paddingBase,
                    child: _buildBody(),
                  ),
                ),
              ),
              if (state.status == SetPasswordStatus.processing)
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
          height: context.dynamicHeight(0.4),
          child: _buildIcon(),
        ),
        _buildHeader(),
        context.spacingNormalHeight,
        _buildForm(),
        context.spacingMediumHeight,
        _buildSubmitButton(),
      ],
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
          LocaleKeys.set_password_title.translate,
          style: context.textTheme.headlineSmall,
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.set_password_description.translate,
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          PasswordTextFormField(
            hintText: LocaleKeys.password.translate,
            passwordController: newPasswordController,
            nextFocusNode: confirmPasswordFocusNode,
            textInputAction: TextInputAction.next,
          ),
          context.spacingNormalHeight,
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
      ),
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      focusNode: submitFocusNode,
      onPressed: onSubmitPressed,
      text: LocaleKeys.set_password_submit.translate,
    );
  }
}
