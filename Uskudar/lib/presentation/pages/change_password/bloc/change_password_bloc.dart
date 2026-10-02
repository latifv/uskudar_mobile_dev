import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/params/change_password_params.dart';
import 'package:uskudar_mobile/domain/usecases/change_password_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/logout_usecase.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

final class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({
    required ChangePasswordUsecase changePasswordUsecase,
    required LogoutUsecase logOutUsecase,
  }) : _changePasswordUsecase = changePasswordUsecase,
       _logOutUsecase = logOutUsecase,
       super(const ChangePasswordState()) {
    on<ChangePasswordSubmit>(_onChangePasswordSubmit);
  }

  final ChangePasswordUsecase _changePasswordUsecase;
  final LogoutUsecase _logOutUsecase;

  Future<void> _onChangePasswordSubmit(
    ChangePasswordSubmit event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(state: ChangePasswordBlocState.loading));

    final params = ChangePasswordParams(
      identityNumber: event.identityNumber,
      oldPassword: event.currentPassword,
      newPassword: event.newPassword,
      retryNewPassword: event.confirmPassword,
    );

    final result = await _changePasswordUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          state: ChangePasswordBlocState.error,
          message: failure.message,
        ),
      ),
      (_) {
        unawaited(_logOutUsecase());
        emit(state.copyWith(state: ChangePasswordBlocState.success));
      },
    );
  }
}
