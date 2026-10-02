import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/auth/forgot_password/mixin/forgot_password_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_processing.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/phone_number_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    required this.question,
    required this.tcNumber,
    super.key,
  });

  final String question;
  final String tcNumber;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

final class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with ForgotPasswordMixin {
  @override
  void initState() {
    tcNumber = widget.tcNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
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
              if (state.status == ForgotPasswordStatus.processing)
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
        context.spacingMediumHeight,
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildIcon() {
    return Center(
      child: Icon(
        Icons.security_outlined,
        color: context.colorScheme.primary,
        size: context.dynamicWidth(0.325),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPhoneField(),
          context.spacingNormalHeight,
          Text(widget.question, style: context.textTheme.bodyMedium),
          context.spacingLowHeight,
          _buildAnswerField(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.forgot_password_title.translate,
          style: context.textTheme.headlineSmall,
        ),
        context.spacingLowHeight,
        Text(LocaleKeys.forgot_password_description.translate),
      ],
    );
  }

  Widget _buildPhoneField() {
    return PhoneNumberTextFormField(
      phoneNumberController: phoneNumberController,
      nextFocusNode: answerFocusNode,
    );
  }

  Widget _buildAnswerField() {
    return CustomTextFormField(
      controller: answerController,
      focusNode: answerFocusNode,
      hintText: LocaleKeys.security_question_answer.translate,
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      onPressed: onSubmitPressed,
      text: LocaleKeys.forgot_password_send.translate,
    );
  }
}
