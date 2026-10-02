import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/enums/sms_verification_type.dart';
import 'package:payinall/presentation/pages/auth/register/bloc/register_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin RegisterMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController phoneNumberController;
  late final FocusNode phoneNumberFocusNode;
  late final GlobalKey<FormState> formKey;
  late final RegisterBloc bloc;

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
    phoneNumberFocusNode = FocusNode();
    formKey = GlobalKey<FormState>();
    bloc = getIt<RegisterBloc>();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    phoneNumberFocusNode.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(_, RegisterState state) {
    if (state.status == RegisterBlocStatus.success) {
      if (state.processCode == null) {
        ToastComponent.showErrorToast(
          context: context,
          message: state.message ?? LocaleKeys.unknown_error.translate,
        );
        return;
      }
      if (state.message != null) {
        ToastComponent.showSuccessToast(
          context: context,
          message: state.message,
        );
      }
      unawaited(context.router.push(
        SmsVerificationRoute(
          phoneNumber: phoneNumberController.text,
          processCode: state.processCode!,
          smsVerificationType: SmsVerificationType.register.getValue,
        ),
      ));
    }
    if (state.status == RegisterBlocStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  Future<void> onRegisterPressed() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    bloc.add(RegisterSubmit(phoneNumberController.text));
  }

  void onLoginPressed() {
    context.router.pop();
  }
}
