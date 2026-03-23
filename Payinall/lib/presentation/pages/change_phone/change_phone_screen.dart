import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/pages/change_phone/bloc/change_phone_bloc.dart';
import 'package:payinall/presentation/pages/change_phone/mixin/change_phone_mixin.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/widgets/phone_number_text_form_field.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({
    required this.question,
    required this.tcNumber,
    super.key,
  });
  final String question;
  final String tcNumber;

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

final class _ChangePhoneScreenState extends State<ChangePhoneScreen>
    with ChangePhoneMixin {
  @override
  void initState() {
    super.initState();
    tcNumber = widget.tcNumber;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<ChangePhoneBloc, ChangePhoneState>(
        listener: blocListener,
        builder: (_, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Text(LocaleKeys.change_phone.translate),
            ),
            body: state.state == ChangePhoneBlocState.success
                ? const Center(child: CustomLoading())
                : SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: context.paddingBase,
                        child: _buildBody(),
                      ),
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
          SizedBox(
            height: context.dynamicHeight(0.45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                context.spacingNormalHeight,
                _buildPhoneInputs(),
                context.spacingHighHeight,
                _buildSubmitButton(),
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
        Icons.phone_outlined,
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
          LocaleKeys.change_phone_number_description.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(200),
          ),
        ),
        context.spacingLowHeight,
        _buildSecurityQuestion(),
        context.spacingNormalHeight,
        PhoneNumberTextFormField(
          phoneNumberController: newPhoneNumberController,
          phoneNumberFocusNode: newPhoneNumberFocusNode,
          nextFocusNode: submitFocusNode,
          hintText: LocaleKeys.new_phone_number.translate,
        ),
      ],
    );
  }

  Widget _buildSecurityQuestion() {
    return CustomTextFormField(
      controller: securityQuestionAnswerController,
      focusNode: securityQuestionAnswerFocusNode,
      hintText: LocaleKeys.security_question_answer.translate,
      validator: AppValidators.required,
      onFieldSubmitted: (_) => newPhoneNumberFocusNode.requestFocus(),
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      focusNode: submitFocusNode,
      onPressed: onSubmitPressed,
      text: LocaleKeys.continue_button.translate,
    );
  }
}
