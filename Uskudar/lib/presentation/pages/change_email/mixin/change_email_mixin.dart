import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/change_email/bloc/change_email_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';

mixin ChangeEmailMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController newEmailController;
  late final FocusNode newEmailFocusNode;
  late final FocusNode submitFocusNode;
  late final GlobalKey<FormState> formKey;
  late final ChangeEmailBloc bloc;
  late final UserInfoManager _userInfoManager;

  @override
  void initState() {
    super.initState();
    newEmailController = TextEditingController();
    newEmailFocusNode = FocusNode();
    submitFocusNode = FocusNode();
    formKey = GlobalKey<FormState>();
    bloc = getIt<ChangeEmailBloc>();
    _userInfoManager = getIt<UserInfoManager>();
  }

  @override
  void dispose() {
    newEmailController.dispose();
    newEmailFocusNode.dispose();
    submitFocusNode.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(BuildContext context, ChangeEmailState state) {
    if (state.status == ChangeEmailStatus.success) {
      final currentEmail = _userInfoManager.email ?? '';
      unawaited(
        context.router
            .push<bool>(
              EmailVerificationRoute(
                email: currentEmail,
                newEmail: newEmailController.text,
                emailVerificationType: 1,
                processCode: state.processCode ?? '',
              ),
            )
            .then((result) {
              if (context.mounted) {
                if (result ?? false) {
                  unawaited(context.router.maybePop(true));
                } else {
                  bloc.add(const ChangeEmailReset());
                }
              }
            }),
      );
    } else if (state.status == ChangeEmailStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  void onSubmitPressed() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    bloc.add(
      ChangeEmailSubmit(
        newEmailAddress: newEmailController.text,
      ),
    );
  }

  void onBackPressed() {
    context.router.pop();
  }
}
