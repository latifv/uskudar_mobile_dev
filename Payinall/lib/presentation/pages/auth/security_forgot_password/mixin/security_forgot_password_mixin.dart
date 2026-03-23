import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/enums/login_type.dart';
import 'package:payinall/presentation/pages/auth/security_forgot_password/bloc/security_forgot_password_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin SecurityForgotPasswordMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController tcNumberController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController customerNumberController;
  late final FocusNode phoneNumberFocusNode;
  late final FocusNode customerNumberFocusNode;
  late final GlobalKey<FormState> formKey;
  late final SecurityForgotPasswordBloc bloc;

  @override
  void initState() {
    tcNumberController = TextEditingController();
    phoneNumberController = TextEditingController();
    customerNumberController = TextEditingController();
    phoneNumberFocusNode = FocusNode();
    customerNumberFocusNode = FocusNode();
    formKey = GlobalKey<FormState>();
    bloc = getIt<SecurityForgotPasswordBloc>();
    super.initState();
  }

  @override
  void dispose() {
    tcNumberController.dispose();
    phoneNumberController.dispose();
    customerNumberController.dispose();
    phoneNumberFocusNode.dispose();
    customerNumberFocusNode.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(_, SecurityForgotPasswordState state) {
    if (state.status == SecurityForgotPasswordStatus.success) {
      if (state.loginType == LoginType.merchant) {
        ToastComponent.showSuccessToast(
          context: context,
          message: state.message ?? LocaleKeys.success.translate,
        );
        context.router.pop();
      } else {
        if (state.question == null) {
          ToastComponent.showErrorToast(
            context: context,
            message: LocaleKeys.unknown_error.translate,
          );
          return;
        }
        ToastComponent.showSuccessToast(
          context: context,
          message: state.message,
        );

        unawaited(
          context.router.push(
            ForgotPasswordRoute(
              question: state.question!,
              tcNumber: tcNumberController.text,
            ),
          ),
        );
      }
    } else if (state.status == SecurityForgotPasswordStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  Future<void> onSubmitPressed() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final currentLoginType = bloc.state.loginType;
    if (currentLoginType == LoginType.merchant) {
      bloc.add(
        SecurityForgotPasswordSubmit(
          gsmNumber: phoneNumberController.text,
          customerNumber: customerNumberController.text,
        ),
      );
    } else {
      bloc.add(
        SecurityForgotPasswordSubmit(
          tcNumber: tcNumberController.text,
        ),
      );
    }
  }

  void onLoginTypeChanged(LoginType loginType) {
    bloc.add(SecurityForgotPasswordLoginTypeChange(loginType));
  }
}
