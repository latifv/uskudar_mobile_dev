import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/managers/signalr_manager.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/enums/login_type.dart';
import 'package:uskudar_mobile/domain/enums/sms_verification_type.dart';
import 'package:uskudar_mobile/presentation/pages/auth/login/bloc/login_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

mixin LoginMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController phoneNumberController;
  late final TextEditingController tcNumberController;
  late final TextEditingController passwordController;
  late final TextEditingController customerNumberController;

  late final FocusNode passwordFocusNode;
  late final FocusNode loginFocusNode;
  late final FocusNode customerNumberFocusNode;
  late final FocusNode phoneNumberFocusNode;

  late final GlobalKey<FormState> formKey;

  late final LoginBloc bloc;
  late final SignalRManager _signalRManager;

  @override
  void initState() {
    super.initState();
    tcNumberController = TextEditingController();
    passwordController = TextEditingController();
    customerNumberController = TextEditingController();

    passwordFocusNode = FocusNode();
    loginFocusNode = FocusNode();
    customerNumberFocusNode = FocusNode();
    phoneNumberFocusNode = FocusNode();

    formKey = GlobalKey<FormState>();

    bloc = getIt<LoginBloc>();
    _signalRManager = getIt<SignalRManager>();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    tcNumberController.dispose();
    passwordController.dispose();
    customerNumberController.dispose();

    passwordFocusNode.dispose();
    loginFocusNode.dispose();
    customerNumberFocusNode.dispose();
    phoneNumberFocusNode.dispose();

    formKey.currentState?.dispose();

    unawaited(bloc.close());

    super.dispose();
  }

  void blocListener(_, LoginState state) {
    if (state.status == LoginBlocStatus.success) {
      unawaited(_signalRManager.initializeAndConnect());
      unawaited(context.router.replace(const HomeRoute()));
    } else if (state.status == LoginBlocStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    } else if (state.status == LoginBlocStatus.smsVerification) {
      if (state.activationProcessCode == null) {
        ToastComponent.showErrorToast(
          context: context,
          message: LocaleKeys.unknown_error.translate,
        );
        return;
      }
      final smsVerificationType = state.loginType == LoginType.merchant
          ? SmsVerificationType.merchantLogin.getValue
          : SmsVerificationType.login.getValue;
      unawaited(
        context.router.push(
          SmsVerificationRoute(
            phoneNumber: phoneNumberController.text,
            smsVerificationType: smsVerificationType,
            processCode: state.activationProcessCode!,
            rememberMe: bloc.rememberMe,
          ),
        ),
      );
    } else if (state.status == LoginBlocStatus.newPassword) {
      unawaited(
        context.router.push(
          ResetPasswordRoute(
            address: phoneNumberController.text,
            code: passwordController.text,
            isMerchant: state.loginType == LoginType.merchant,
            processCode: state.activationProcessCode,
          ),
        ),
      );
    }
  }

  Future<void> onLoginPressed() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final currentLoginType = bloc.state.loginType;
    if (currentLoginType == LoginType.merchant) {
      bloc.add(
        LoginSubmit(
          customerNumberController.text,
          passwordController.text,
          isMerchant: true,
          customerNumber: customerNumberController.text,
          gsmNumber: phoneNumberController.text,
        ),
      );
    } else {
      final identifier = phoneNumberController.text;
      bloc.add(LoginSubmit(identifier, passwordController.text));
    }
  }

  void onLoginTypeChanged(LoginType loginType) {
    bloc.add(LoginTypeChange(loginType));
  }

  void onCreateAccountPressed() {
    unawaited(context.router.push(const RegisterRoute()));
  }

  void onForgotPasswordPressed() {
    unawaited(context.router.push(const SecurityForgotPasswordRoute()));
  }

  void onRememberMeChanged({bool? value}) {
    if (value == null) {
      return;
    }
    bloc.add(LoginRememberMeChange(isChecked: value));
  }
}
