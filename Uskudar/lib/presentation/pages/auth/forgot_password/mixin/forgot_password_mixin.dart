import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';

mixin ForgotPasswordMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController phoneNumberController;
  late final TextEditingController answerController;

  late final FocusNode answerFocusNode;

  late final GlobalKey<FormState> formKey;

  late final ForgotPasswordBloc bloc;

  late final String tcNumber;

  @override
  void initState() {
    phoneNumberController = TextEditingController();
    answerController = TextEditingController();

    answerFocusNode = FocusNode();

    formKey = GlobalKey<FormState>();

    bloc = getIt<ForgotPasswordBloc>();
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    answerController.dispose();

    answerFocusNode.dispose();

    formKey.currentState?.dispose();

    unawaited(bloc.close());

    super.dispose();
  }

  void blocListener(_, ForgotPasswordState state) {
    if (state.status == ForgotPasswordStatus.success) {
      ToastComponent.showSuccessToast(context: context, message: state.message);
      unawaited(
        context.router.push(
          ResetPasswordRoute(address: phoneNumberController.text.trim()),
        ),
      );
    } else if (state.status == ForgotPasswordStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  Future<void> onSubmitPressed() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    bloc.add(
      ForgotPasswordSubmit(
        phoneNumberController.text,
        answerController.text,
        tcNumber,
      ),
    );
  }
}
