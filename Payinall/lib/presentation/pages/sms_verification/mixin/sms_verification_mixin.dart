import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/managers/signalr_manager.dart';

import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/logged_in.dart';
import 'package:payinall/domain/enums/sms_verification_type.dart';
import 'package:payinall/domain/usecases/save_logged_in_usecase.dart';
import 'package:payinall/presentation/pages/sms_verification/bloc/sms_verification_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/constants/validator_constants.dart';

mixin VerificationMixin<T extends StatefulWidget> on State<T> {
  late final SmsVerificationBloc bloc;
  late final String phoneNumber;
  late final String? newPhoneNumber;
  late final String? identityNumber;
  late final String? securityQuestionAnswer;
  late final FocusNode focusNode;
  late final SmsVerificationType smsVerificationType;
  late final TextEditingController pinController;
  late final String processCode;
  late final SaveLoggedInUsecase _saveLoggedInUsecase;
  late final SignalRManager _signalRManager;
  late final bool? rememberMe;

  @override
  void initState() {
    super.initState();
    _saveLoggedInUsecase = getIt<SaveLoggedInUsecase>();
    _signalRManager = getIt<SignalRManager>();
    pinController = TextEditingController();
    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    focusNode.dispose();
    pinController.dispose();
    super.dispose();
  }

  void blocListener(BuildContext context, SmsVerificationState state) {
    if (state.status == SmsVerificationBlocStatus.success) {
      if (smsVerificationType == SmsVerificationType.register) {
        unawaited(
          context.router.replace(
            AccountVerificationRoute(
              phoneNumber: phoneNumber,
              code: pinController.text,
            ),
          ),
        );
      } else if (smsVerificationType == SmsVerificationType.forgotPassword) {
      } else if (smsVerificationType == SmsVerificationType.login ||
          smsVerificationType == SmsVerificationType.merchantLogin) {
        if (rememberMe != null &&
            rememberMe! &&
            smsVerificationType != SmsVerificationType.merchantLogin) {
          final loggedIn = LoggedIn(
            identifier: phoneNumber,
          );
          unawaited(_saveLoggedInUsecase(loggedIn));
        }

        unawaited(_signalRManager.initializeAndConnect());
        unawaited(context.router.replaceAll([const HomeRoute()]));
      } else if (smsVerificationType == SmsVerificationType.changePhoneNumber) {
        unawaited(context.router.replaceAll([LoginRoute()]));
      }
      ToastComponent.showSuccessToast(context: context, message: state.message);
    } else if (state.status == SmsVerificationBlocStatus.loaded) {
      ToastComponent.showSuccessToast(context: context, message: state.message);
    } else if (state.status == SmsVerificationBlocStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  void onPinChanged(String value) {
    if (value.length == ValidatorConstants.pinLength) {
      onVerifyPressed();
    }
  }

  void onVerifyPressed() {
    FocusScope.of(context).unfocus();
    if (smsVerificationType == SmsVerificationType.register) {
      bloc.add(
        RegisterSmsVerificationSubmit(
          processCode: processCode,
          pin: pinController.text,
        ),
      );
    } else if (smsVerificationType == SmsVerificationType.login) {
      bloc.add(
        LoginSmsVerificationSubmit(
          processCode: processCode,
          pin: pinController.text,
        ),
      );
    } else if (smsVerificationType == SmsVerificationType.merchantLogin) {
      bloc.add(
        MerchantLoginSmsVerificationSubmit(
          processCode: processCode,
          pin: pinController.text,
        ),
      );
    } else if (smsVerificationType == SmsVerificationType.changePhoneNumber) {
      bloc.add(
        ChangePhoneNumberSmsVerificationSubmit(
          processCode: processCode,
          pin: pinController.text,
        ),
      );
    }
  }

  void onResendPressed() {
    if (smsVerificationType == SmsVerificationType.register) {
      bloc.add(RegisterSmsVerificationResend(phoneNumber: phoneNumber));
    } else if (smsVerificationType == SmsVerificationType.login) {
      bloc.add(LoginSmsVerificationResend(processCode: processCode));
    } else if (smsVerificationType == SmsVerificationType.merchantLogin) {
      return;
    } else if (smsVerificationType == SmsVerificationType.changePhoneNumber) {
      bloc.add(
        ChangePhoneNumberSmsVerificationResend(
          newPhoneNumber: newPhoneNumber!,
          identityNumber: identityNumber!,
          securityQuestionAnswer: securityQuestionAnswer!,
        ),
      );
    }
  }
}
