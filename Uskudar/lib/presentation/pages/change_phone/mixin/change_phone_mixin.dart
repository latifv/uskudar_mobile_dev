import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/enums/sms_verification_type.dart';
import 'package:payinall/presentation/pages/change_phone/bloc/change_phone_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';

mixin ChangePhoneMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController newPhoneNumberController;
  late final TextEditingController securityQuestionAnswerController;
  late final FocusNode newPhoneNumberFocusNode;
  late final FocusNode identityNumberFocusNode;
  late final FocusNode securityQuestionAnswerFocusNode;
  late final FocusNode submitFocusNode;
  late final GlobalKey<FormState> formKey;
  late final ChangePhoneBloc bloc;
  late final UserInfoManager _userInfoManager;
  late final String tcNumber;

  @override
  void initState() {
    super.initState();
    newPhoneNumberController = TextEditingController();
    securityQuestionAnswerController = TextEditingController();
    newPhoneNumberFocusNode = FocusNode();
    identityNumberFocusNode = FocusNode();
    securityQuestionAnswerFocusNode = FocusNode();
    submitFocusNode = FocusNode();
    formKey = GlobalKey<FormState>();
    bloc = getIt<ChangePhoneBloc>();
    _userInfoManager = getIt<UserInfoManager>();
  }

  @override
  void dispose() {
    newPhoneNumberController.dispose();
    securityQuestionAnswerController.dispose();
    newPhoneNumberFocusNode.dispose();
    identityNumberFocusNode.dispose();
    securityQuestionAnswerFocusNode.dispose();
    submitFocusNode.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(BuildContext context, ChangePhoneState state) {
    if (state.state == ChangePhoneBlocState.success) {
      final currentPhoneNumber = _userInfoManager.gsmNumber ?? '';
      unawaited(
        context.router.replace(
          SmsVerificationRoute(
            phoneNumber: currentPhoneNumber,
            smsVerificationType: SmsVerificationType.changePhoneNumber.getValue,
            processCode: state.processCode ?? '',
            newPhoneNumber: newPhoneNumberController.text,
            identityNumber: tcNumber,
            securityQuestionAnswer: securityQuestionAnswerController.text,
          ),
        ),
      );
    } else if (state.state == ChangePhoneBlocState.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  void onSubmitPressed() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    bloc.add(
      ChangePhoneSubmit(
        identityNumber: tcNumber,
        newPhoneNumber: newPhoneNumberController.text,
        securityQuestionAnswer: securityQuestionAnswerController.text,
      ),
    );
  }

  void onBackPressed() {
    context.router.pop();
  }
}
