import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/enums/agreement_type.dart';
import 'package:payinall/presentation/pages/auth/account_verification/bloc/account_verification_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin AccountVerificationMixin<T extends StatefulWidget> on State<T> {
  late final String phoneNumber;
  late final String code;
  int? userQuestionId;

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController tcNoController;
  late final TextEditingController birthDateController;
  late final TextEditingController emailController;
  late final TextEditingController answerController;
  late final TextEditingController seriNoController;

  late final FocusNode tcNoFocusNode;
  late final FocusNode birthDateFocusNode;
  late final FocusNode emailFocusNode;
  late final FocusNode submitFocusNode;
  late final FocusNode lastNameFocusNode;
  late final FocusNode answerFocusNode;
  late final FocusNode seriNoFocusNode;

  late final GlobalKey<FormState> formKey;

  late final AccountVerificationBloc bloc;

  late final ValueNotifier<bool> frameworkAgreementAccepted;
  late final ValueNotifier<bool> clarificationTextAccepted;
  late final ValueNotifier<bool> allAgreementsAccepted;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    tcNoController = TextEditingController();
    birthDateController = TextEditingController();
    emailController = TextEditingController();
    answerController = TextEditingController();
    seriNoController = TextEditingController();
    tcNoFocusNode = FocusNode();
    birthDateFocusNode = FocusNode();
    lastNameFocusNode = FocusNode();
    answerFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    submitFocusNode = FocusNode();
    seriNoFocusNode = FocusNode();
    formKey = GlobalKey<FormState>();

    bloc = getIt<AccountVerificationBloc>();
    Future.microtask(() => bloc.add(GetUserQuestions()));

    frameworkAgreementAccepted = ValueNotifier<bool>(false);
    clarificationTextAccepted = ValueNotifier<bool>(false);
    allAgreementsAccepted = ValueNotifier<bool>(false);

    frameworkAgreementAccepted.addListener(_checkAllAgreements);
    clarificationTextAccepted.addListener(_checkAllAgreements);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    tcNoController.dispose();
    birthDateController.dispose();
    emailController.dispose();
    answerController.dispose();
    seriNoController.dispose();
    tcNoFocusNode.dispose();
    lastNameFocusNode.dispose();
    birthDateFocusNode.dispose();
    emailFocusNode.dispose();
    submitFocusNode.dispose();
    answerFocusNode.dispose();
    formKey.currentState?.dispose();
    seriNoFocusNode.dispose();
    frameworkAgreementAccepted.dispose();
    clarificationTextAccepted.dispose();
    allAgreementsAccepted.dispose();

    unawaited(bloc.close());

    super.dispose();
  }

  void blocListener(_, AccountVerificationState state) {
    if (state.status == AccountVerificationStatus.success) {
      if (userQuestionId == null) {
        ToastComponent.showErrorToast(
          context: context,
          message: LocaleKeys.security_question_required.translate,
        );
        return;
      }
      final email = emailController.text.trim();

      unawaited(
        context.router.push(
          SetPasswordRoute(
            phoneNumber: phoneNumber,
            code: code,
            email: email,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            tcNo: tcNoController.text,
            birthDate: birthDateController.text,
            secretQuestion: answerController.text,
            userQuestionId: userQuestionId!,
            seriNo: seriNoController.text,
          ),
        ),
      );
    } else if (state.status == AccountVerificationStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  void onUserQuestionChanged(int? value) {
    if (value != null) {
      userQuestionId = value;
    }
  }

  Future<void> onSubmitPressed() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    if (!allAgreementsAccepted.value) {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.accept_all_agreements.translate,
      );
      return;
    }

    if (userQuestionId == null) {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.security_question_required.translate,
      );
    }

    final email = emailController.text.trim();

    bloc.add(
      AccountVerificationSubmit(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        tcNo: tcNoController.text,
        birthDate: birthDateController.text,
        email: email,
        phoneNumber: phoneNumber,
        userQuestionId: userQuestionId,
        secretQuestion: answerController.text,
      ),
    );
  }

  void _checkAllAgreements() {
    allAgreementsAccepted.value =
        frameworkAgreementAccepted.value && clarificationTextAccepted.value;
  }

  Future<bool> navigateToAgreement(AgreementType agreementType) async {
    final result = await context.router.push(
      AgreementRoute(agreementType: agreementType.getValue, isRead: false),
    );
    return result == true;
  }
}
