import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/params/register_params.dart';
import 'package:uskudar_mobile/domain/usecases/register_usecase.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

part 'set_password_event.dart';
part 'set_password_state.dart';

final class SetPasswordBloc extends Bloc<SetPasswordEvent, SetPasswordState> {
  SetPasswordBloc({required RegisterUsecase registerUsecase})
    : _registerUsecase = registerUsecase,
      super(const SetPasswordState()) {
    on<SetPasswordSubmit>(_onSetPasswordSubmit);
  }

  final RegisterUsecase _registerUsecase;

  Future<void> _onSetPasswordSubmit(
    SetPasswordSubmit event,
    Emitter<SetPasswordState> emit,
  ) async {
    if (state.status == SetPasswordStatus.processing) {
      return;
    }

    emit(state.copyWith(status: SetPasswordStatus.processing));

    final birthDate = event.birthDate.toDateFromTurkishFormat();
    if (birthDate == null) {
      emit(
        state.copyWith(
          status: SetPasswordStatus.error,
          message: LocaleKeys.unknown_error.translate,
        ),
      );
      return;
    }

    final params = RegisterParams(
      firstName: event.firstName,
      lastName: event.lastName,
      identityNumber: event.tcNo,
      gsmNumber: event.phoneNumber,
      email: event.email,
      password: event.password,
      rePassword: event.confirmPassword,
      isContractConfirm: true,
      code: event.code,
      dateOfBirth: birthDate,
      userQuestionId: event.userQuestionId,
      secretQuestion: event.secretQuestion,
      seriNo: event.seriNo,
    );

    final result = await _registerUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(status: SetPasswordStatus.error, message: l.message),
      ),
      (r) => emit(state.copyWith(status: SetPasswordStatus.success)),
    );
  }
}
