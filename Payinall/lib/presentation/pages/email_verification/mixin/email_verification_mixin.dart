import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/domain/enums/email_verification_type.dart';
import 'package:payinall/presentation/pages/email_verification/bloc/email_verification_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/constants/validator_constants.dart';

mixin EmailVerificationMixin<T extends StatefulWidget> on State<T> {
  late final EmailVerificationBloc bloc;
  late final String? email;
  late final String? newEmail;
  late final FocusNode focusNode;
  late final EmailVerificationType emailVerificationType;
  late final TextEditingController codeController;
  late final String processCode;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    focusNode.dispose();
    codeController.dispose();
    super.dispose();
  }

  void blocListener(BuildContext context, EmailVerificationState state) {
    if (state.status == EmailVerificationBlocStatus.success) {
      ToastComponent.showSuccessToast(context: context, message: state.message);
      unawaited(context.router.maybePop(true));
    } else if (state.status == EmailVerificationBlocStatus.loaded) {
      ToastComponent.showSuccessToast(context: context, message: state.message);
    } else if (state.status == EmailVerificationBlocStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  void onCodeChanged(String value) {
    if (value.length == ValidatorConstants.pinLength) {
      onVerifyPressed();
    }
  }

  void onVerifyPressed() {
    FocusScope.of(context).unfocus();
    if (emailVerificationType == EmailVerificationType.emailUpdate) {
      bloc.add(
        EmailUpdateVerificationSubmit(
          processCode: processCode,
          code: codeController.text,
        ),
      );
    } else if (emailVerificationType == EmailVerificationType.emailChange) {
      bloc.add(
        EmailChangeVerificationSubmit(
          processCode: processCode,
          code: codeController.text,
        ),
      );
    }
  }

  void onResendPressed() {
    if (emailVerificationType == EmailVerificationType.emailUpdate) {
      bloc.add(const EmailUpdateVerificationResend());
    } else if (emailVerificationType == EmailVerificationType.emailChange) {
      bloc.add(EmailChangeVerificationResend(newEmailAddress: newEmail!));
    }
  }
}
