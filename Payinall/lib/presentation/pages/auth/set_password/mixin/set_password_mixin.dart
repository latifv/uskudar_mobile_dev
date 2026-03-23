import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/auth/set_password/bloc/set_password_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/info_dialog.dart';

mixin SetPasswordMixin<T extends StatefulWidget> on State<T> {
  late final String firstName;
  late final String lastName;
  late final String tcNo;
  late final String email;
  late final String phoneNumber;
  late final String birthDate;
  late final String code;
  late final int userQuestionId;
  late final String secretQuestion;
  late final String seriNo;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;

  late final FocusNode confirmPasswordFocusNode;
  late final FocusNode submitFocusNode;

  late final GlobalKey<FormState> formKey;

  late final SetPasswordBloc bloc;

  @override
  void initState() {
    super.initState();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    confirmPasswordFocusNode = FocusNode();
    submitFocusNode = FocusNode();

    formKey = GlobalKey<FormState>();

    bloc = getIt<SetPasswordBloc>();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    confirmPasswordFocusNode.dispose();
    submitFocusNode.dispose();
    formKey.currentState?.dispose();

    unawaited(bloc.close());

    super.dispose();
  }

  Future<void> blocListener(_, SetPasswordState state) async {
    if (state.status == SetPasswordStatus.success) {
      await _buildRegisterSuccessDialog();
      if (mounted) {
        unawaited(
          //! Kesinlikle UniqueKey Silinmemeli!
          context.router.replaceAll([
            LoginRoute(phoneNumber: phoneNumber, key: UniqueKey()),
          ]),
        );
      }
    } else if (state.status == SetPasswordStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  Future<void> _buildRegisterSuccessDialog() {
    return InfoDialog.show(
      context: context,
      title: LocaleKeys.register_success.translate,
      description: LocaleKeys.register_success_message.translate,
      icon: Icons.check_circle,
      iconColor: Colors.green,
      buttonActive: false,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> onSubmitPressed() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.passwords_not_match.translate,
      );
      return;
    }

    bloc.add(
      SetPasswordSubmit(
        code,
        firstName,
        lastName,
        tcNo,
        email,
        phoneNumber,
        birthDate,
        newPassword,
        confirmPassword,
        userQuestionId,
        secretQuestion,
        seriNo,
      ),
    );
  }
}
