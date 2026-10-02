import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/params/change_phone_code_params.dart';
import 'package:uskudar_mobile/domain/usecases/change_phone_code_usecase.dart';

part 'change_phone_event.dart';
part 'change_phone_state.dart';

final class ChangePhoneBloc extends Bloc<ChangePhoneEvent, ChangePhoneState> {
  ChangePhoneBloc({required ChangePhoneCodeUsecase changePhoneCodeUsecase})
    : _changePhoneCodeUsecase = changePhoneCodeUsecase,
      super(const ChangePhoneState()) {
    on<ChangePhoneSubmit>(_onChangePhoneSubmit);
  }

  final ChangePhoneCodeUsecase _changePhoneCodeUsecase;

  Future<void> _onChangePhoneSubmit(
    ChangePhoneSubmit event,
    Emitter<ChangePhoneState> emit,
  ) async {
    emit(state.copyWith(state: ChangePhoneBlocState.loading));

    final params = ChangePhoneCodeParams(
      newGsmNumber: event.newPhoneNumber,
      identityNumber: event.identityNumber,
      answer: event.securityQuestionAnswer,
    );

    final result = await _changePhoneCodeUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(state: ChangePhoneBlocState.error, message: l.message),
      ),
      (r) {
        emit(
          state.copyWith(
            state: ChangePhoneBlocState.success,
            processCode: r.data,
          ),
        );
      },
    );
  }
}
