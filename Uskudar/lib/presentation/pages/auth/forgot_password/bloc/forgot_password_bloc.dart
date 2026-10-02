import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/params/forgot_password_params.dart';
import 'package:uskudar_mobile/domain/usecases/forgot_password_usecase.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

final class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required this.forgotPasswordUsecase})
    : super(const ForgotPasswordState()) {
    on<ForgotPasswordSubmit>(_onForgotPasswordSubmit);
  }

  final ForgotPasswordUsecase forgotPasswordUsecase;

  Future<void> _onForgotPasswordSubmit(
    ForgotPasswordSubmit event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.status == ForgotPasswordStatus.processing) {
      return;
    }

    emit(state.copyWith(status: ForgotPasswordStatus.processing));

    final params = ForgotPasswordParams(
      gsmNumber: event.phoneNumber,
      identityNumber: event.tcNumber,
      answer: event.answer,
    );

    final result = await forgotPasswordUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(status: ForgotPasswordStatus.error, message: l.message),
      ),
      (r) => emit(
        state.copyWith(status: ForgotPasswordStatus.success, message: r),
      ),
    );
  }
}
