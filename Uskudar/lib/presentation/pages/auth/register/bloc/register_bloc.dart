import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/enums/agreement_type.dart';
import 'package:uskudar_mobile/domain/params/create_register_code_params.dart';
import 'package:uskudar_mobile/domain/usecases/create_register_code_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

final class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required CreateRegisterCodeUsecase createRegisterCodeUsecase})
    : _createRegisterCodeUsecase = createRegisterCodeUsecase,
      super(const RegisterState()) {
    on<RegisterSubmit>(_onRegisterSubmit);
  }

  final CreateRegisterCodeUsecase _createRegisterCodeUsecase;

  Future<void> _onRegisterSubmit(
    RegisterSubmit event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.status == RegisterBlocStatus.processing) {
      return;
    }

    emit(state.copyWith(status: RegisterBlocStatus.processing));

    final params = CreateRegisterCodeParams(gsmNumber: event.phoneNumber);
    final result = await _createRegisterCodeUsecase(params);
    result.fold(
      (l) => emit(
        state.copyWith(status: RegisterBlocStatus.error, message: l.message),
      ),
      (r) {
        emit(
          state.copyWith(
            status: RegisterBlocStatus.success,
            processCode: r.data,
            message: r.message,
          ),
        );
      },
    );
  }
}
