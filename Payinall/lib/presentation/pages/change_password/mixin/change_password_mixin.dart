import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/change_password/bloc/change_password_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin ChangePasswordMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController identityNumberController;
  late final FocusNode currentPasswordFocusNode;
  late final FocusNode newPasswordFocusNode;
  late final FocusNode confirmPasswordFocusNode;
  late final FocusNode identityNumberFocusNode;
  late final FocusNode submitFocusNode;
  late final GlobalKey<FormState> formKey;
  late final ChangePasswordBloc bloc;

  @override
  void initState() {
    super.initState();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    identityNumberController = TextEditingController();
    currentPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    identityNumberFocusNode = FocusNode();
    submitFocusNode = FocusNode();
    formKey = GlobalKey<FormState>();
    bloc = getIt<ChangePasswordBloc>();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    submitFocusNode.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(BuildContext context, ChangePasswordState state) {
    if (state.state == ChangePasswordBlocState.success) {
      ToastComponent.showSuccessToast(
        context: context,
        message: LocaleKeys.password_change_success.translate,
      );
      unawaited(context.router.replaceAll([LoginRoute()]));
    } else if (state.state == ChangePasswordBlocState.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  void onSubmitPressed() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    if (currentPasswordController.text == newPasswordController.text) {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.new_password_same_as_current_password.translate,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.passwords_not_match.translate,
      );
      return;
    }

    bloc.add(
      ChangePasswordSubmit(
        identityNumber: identityNumberController.text,
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      ),
    );
  }

  void onBackPressed() {
    context.router.pop();
  }
}
