import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/security_change_phone/bloc/security_change_phone_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin SecurityChangePhoneMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController tcNumberController;
  late final GlobalKey<FormState> formKey;
  late final SecurityChangePhoneBloc bloc;

  @override
  void initState() {
    super.initState();
    tcNumberController = TextEditingController();
    formKey = GlobalKey<FormState>();
    bloc = getIt<SecurityChangePhoneBloc>();
  }

  @override
  void dispose() {
    tcNumberController.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(_, SecurityChangePhoneState state) {
    if (state.status == SecurityChangePhoneStatus.success) {
      if (state.question == null) {
        ToastComponent.showErrorToast(
          context: context,
          message: LocaleKeys.unknown_error.translate,
        );
        return;
      }
      ToastComponent.showSuccessToast(context: context, message: state.message);
      unawaited(context.router.push(
        ChangePhoneRoute(
          question: state.question!,
          tcNumber: tcNumberController.text,
        ),
      ));
    } else if (state.status == SecurityChangePhoneStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  void onSubmitPressed() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    bloc.add(SecurityChangePhoneSubmit(tcNumberController.text));
  }

  void onBackPressed() {
    context.router.pop();
  }
}
