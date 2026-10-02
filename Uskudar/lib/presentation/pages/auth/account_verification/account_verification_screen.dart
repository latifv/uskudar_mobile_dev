import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/enums/agreement_type.dart';
import 'package:uskudar_mobile/domain/validators/app_validators.dart';
import 'package:uskudar_mobile/presentation/pages/auth/account_verification/bloc/account_verification_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/auth/account_verification/mixin/account_verification_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/auth/account_verification/widgets/agreement_checkbox.dart';
import 'package:uskudar_mobile/presentation/shared/constants/validator_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/birth_date_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dropdown_button_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_processing.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';
import 'package:uskudar_mobile/presentation/widgets/tc_number_text_form_field.dart';

@RoutePage()
final class AccountVerificationScreen extends StatefulWidget {
  const AccountVerificationScreen({
    required this.phoneNumber,
    required this.code,
    super.key,
  });

  final String phoneNumber;
  final String code;
  @override
  State<AccountVerificationScreen> createState() =>
      _AccountVerificationScreenState();
}

final class _AccountVerificationScreenState
    extends State<AccountVerificationScreen>
    with AccountVerificationMixin {
  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phoneNumber;
    code = widget.code;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<AccountVerificationBloc, AccountVerificationState>(
        listener: blocListener,
        builder: (_, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: CustomAppBar(
                  title: Text(
                    LocaleKeys.form.translate,
                  ),
                ),
                body: SafeArea(
                  child: state.status == AccountVerificationStatus.loading
                      ? const Center(child: CustomLoading())
                      : Center(
                          child: SingleChildScrollView(
                            padding:
                                context.paddingBase - context.paddingNormalTop,
                            child: _buildBody(),
                          ),
                        ),
                ),
              ),
              if (state.status == AccountVerificationStatus.processing)
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
        _buildHeader(),
        context.spacingLowHeight,
        _buildInputs(),
        context.spacingLowHeight,
        _buildAgreements(),
        context.spacingNormalHeight,
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.account_verification_title.translate,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          LocaleKeys.account_verification_description.translate,
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildInputs() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: firstNameController,
                  hintText: LocaleKeys.first_name.translate,
                  validator: AppValidators.firstName,
                  onFieldSubmitted: (_) => lastNameFocusNode.requestFocus(),
                ),
              ),
              context.spacingLowWidth,
              Expanded(
                child: CustomTextFormField(
                  focusNode: lastNameFocusNode,
                  controller: lastNameController,
                  hintText: LocaleKeys.last_name.translate,
                  validator: AppValidators.lastName,
                  onFieldSubmitted: (_) => tcNoFocusNode.requestFocus(),
                ),
              ),
            ],
          ),
          context.spacingLowHeight,
          TcNumberTextFormField(
            tcNumberController: tcNoController,
            tcNumberFocusNode: tcNoFocusNode,
            nextFocusNode: birthDateFocusNode,
          ),
          context.spacingLowHeight,
          BirthDateTextFormField(
            birthDateController: birthDateController,
            birthDateFocusNode: birthDateFocusNode,
            nextFocusNode: emailFocusNode,
          ),
          context.spacingLowHeight,
          CustomTextFormField(
            controller: emailController,
            focusNode: emailFocusNode,
            hintText: LocaleKeys.email.translate,
            validator: AppValidators.email,
            keyboardType: TextInputType.emailAddress,
            suffixIcon: const Icon(Icons.email_outlined),
            onFieldSubmitted: (_) => answerFocusNode.requestFocus(),
          ),
          context.spacingLowHeight,
          BlocBuilder<AccountVerificationBloc, AccountVerificationState>(
            builder: (_, state) {
              if (state.userQuestions?.isEmpty ?? true) {
                return const SizedBox.shrink();
              }
              return CustomDropdownButtonFormField<int>(
                hintText: LocaleKeys.security_question.translate,
                items:
                    state.userQuestions
                        ?.map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(
                              e.name,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                        .toList() ??
                    [],
                onChanged: onUserQuestionChanged,
              );
            },
          ),
          context.spacingLowHeight,
          CustomTextFormField(
            controller: answerController,
            focusNode: answerFocusNode,
            hintText: LocaleKeys.security_question_answer.translate,
            validator: AppValidators.required,
            onFieldSubmitted: (_) => seriNoFocusNode.requestFocus(),
          ),
          context.spacingLowHeight,
          CustomTextFormField(
            controller: seriNoController,
            focusNode: seriNoFocusNode,
            hintText: LocaleKeys.seri_no.translate,
            validator: AppValidators.seriNo,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                ValidatorConstants.seriNoLength,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgreements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AgreementCheckbox(
          text: LocaleKeys.kullanici_cerceve_sozlesmesi.translate,
          valueNotifier: frameworkAgreementAccepted,
          onTextTap: () async {
            final result = await navigateToAgreement(
              AgreementType.kullaniciCerceveSozlesmesi,
            );
            frameworkAgreementAccepted.value = result;
          },
        ),
        context.spacingNormalHeight,
        AgreementCheckbox(
          text:
              LocaleKeys.odeme_hizmeti_kullanicilari_aydinlatma_metni.translate,
          valueNotifier: clarificationTextAccepted,
          onTextTap: () async {
            final result = await navigateToAgreement(
              AgreementType.odemeHizmetiKullanicilariAydinlatmaMetni,
            );
            clarificationTextAccepted.value = result;
          },
        ),
      ],
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
