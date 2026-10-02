import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/managers/signalr_manager.dart';

import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/enums/sms_verification_type.dart';
import 'package:uskudar_mobile/presentation/pages/auth/password_confirmation/bloc/password_confirmation_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/constants/validator_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

mixin PasswordConfirmationMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController passwordController;
  late final FocusNode passwordFocusNode;
  late final PasswordConfirmationBloc bloc;
  late final SignalRManager _signalRManager;
  late final String identifier;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    passwordFocusNode = FocusNode();
    bloc = getIt<PasswordConfirmationBloc>();
    _signalRManager = getIt<SignalRManager>();
    passwordFocusNode.requestFocus();
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordFocusNode.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(_, PasswordConfirmationState state) {
    if (state.status == PasswordConfirmationStatus.success) {
      unawaited(_signalRManager.initializeAndConnect());
      unawaited(context.router.replace(const HomeRoute()));
    } else if (state.status == PasswordConfirmationStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
      passwordController.clear();
      passwordFocusNode.requestFocus();
    } else if (state.status == PasswordConfirmationStatus.logoutSuccess) {
      unawaited(context.router.replace(LoginRoute()));
    } else if (state.status == PasswordConfirmationStatus.smsVerification) {
      if (state.activationProcessCode == null) {
        ToastComponent.showErrorToast(context: context, message: state.message);
        return;
      }
      unawaited(
        context.router.replace(
          SmsVerificationRoute(
            phoneNumber: identifier,
            smsVerificationType: SmsVerificationType.login.getValue,
            processCode: state.activationProcessCode!,
          ),
        ),
      );
    }
  }

  void onPasswordChanged(String value) {
    if (value.length != ValidatorConstants.passwordLength) {
      return;
    }
    unawaited(onSubmitPressed());
  }

  Future<void> onSubmitPressed() async {
    FocusScope.of(context).unfocus();
    if (passwordController.text.length != ValidatorConstants.passwordLength) {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.enter_password.translate,
      );
      return;
    }
    bloc.add(PasswordConfirmationSubmit(passwordController.text, identifier));
  }

  Future<void> onForgetMePressed() async {
    bloc.add(const PasswordConfirmationLogout());
  }
}
