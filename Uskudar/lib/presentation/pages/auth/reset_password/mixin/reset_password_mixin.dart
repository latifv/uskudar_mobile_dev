import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/auth/reset_password/bloc/reset_password_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

mixin ResetPasswordMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController verificationCodeController;
  late final TextEditingController customerNumberController;

  late final FocusNode confirmPasswordFocusNode;
  late final FocusNode verificationCodeFocusNode;
  late final FocusNode customerNumberFocusNode;

  late final GlobalKey<FormState> formKey;

  late final ResetPasswordBloc bloc;

  late final String address;
  bool isMerchant = false;
  String? processCode;

  @override
  void initState() {
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    verificationCodeController = TextEditingController();
    customerNumberController = TextEditingController();

    confirmPasswordFocusNode = FocusNode();
    verificationCodeFocusNode = FocusNode();
    customerNumberFocusNode = FocusNode();

    formKey = GlobalKey<FormState>();

    bloc = getIt<ResetPasswordBloc>();
    super.initState();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    verificationCodeController.dispose();
    customerNumberController.dispose();

    confirmPasswordFocusNode.dispose();
    verificationCodeFocusNode.dispose();
    customerNumberFocusNode.dispose();

    formKey.currentState?.dispose();

    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(BuildContext context, ResetPasswordState state) {
    if (state.status == ResetPasswordStatus.success) {
      ToastComponent.showSuccessToast(
        context: context,
        message: LocaleKeys.password_reset_success.translate,
      );
      unawaited(context.router.replaceAll([LoginRoute()]));
    } else if (state.status == ResetPasswordStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  Future<void> onSubmitPressed() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) {
      return;
    }

    bloc.add(
      ResetPasswordSubmit(
        newPasswordController.text,
        confirmPasswordController.text,
        verificationCodeController.text,
        address,
        isMerchant: isMerchant,
        processCode: processCode,
        customerNumber: customerNumberController.text,
      ),
    );
  }
}
