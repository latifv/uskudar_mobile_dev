import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/params/forgot_change_password_params.dart';
import 'package:uskudar_mobile/domain/params/merchant_user_forgot_change_password_params.dart';
import 'package:uskudar_mobile/domain/usecases/forgot_change_password_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/merchant_user_forgot_change_password_usecase.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

final class ResetPasswordBloc
    extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required this.forgotChangePasswordUsecase,
    required this.merchantUserForgotChangePasswordUsecase,
  }) : super(const ResetPasswordState()) {
    on<ResetPasswordSubmit>(_onResetPasswordSubmit);
  }

  final ForgotChangePasswordUsecase forgotChangePasswordUsecase;
  final MerchantUserForgotChangePasswordUsecase
  merchantUserForgotChangePasswordUsecase;

  Future<void> _onResetPasswordSubmit(
    ResetPasswordSubmit event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (state.status == ResetPasswordStatus.processing) {
      return;
    }

    emit(state.copyWith(status: ResetPasswordStatus.processing));

    if (event.isMerchant) {
      if (event.processCode == null) {
        emit(
          state.copyWith(
            status: ResetPasswordStatus.error,
            message: LocaleKeys
                .merchant_password_reset_process_code_required
                .translate,
          ),
        );
        return;
      }

      final params = MerchantUserForgotChangePasswordParams(
        gsmNumber: event.address,
        customerNumber: event.customerNumber ?? '',
        code: event.code,
        password: event.newPassword,
        processCode: event.processCode!,
      );

      final result = await merchantUserForgotChangePasswordUsecase(params);

      result.fold(
        (l) {
          emit(
            state.copyWith(
              status: ResetPasswordStatus.error,
              message: l.message,
            ),
          );
        },
        (r) {
          emit(state.copyWith(status: ResetPasswordStatus.success));
        },
      );
      return;
    }

    final params = ForgotChangePasswordParams(
      password: event.newPassword,
      rePassword: event.confirmPassword,
      code: event.code,
      address: event.address,
    );

    final result = await forgotChangePasswordUsecase(params);

    result.fold(
      (l) {
        emit(
          state.copyWith(status: ResetPasswordStatus.error, message: l.message),
        );
      },
      (r) {
        emit(state.copyWith(status: ResetPasswordStatus.success));
      },
    );
  }
}
