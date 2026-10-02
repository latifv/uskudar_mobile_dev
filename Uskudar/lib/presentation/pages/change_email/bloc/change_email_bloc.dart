import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/params/update_email_send_code_params.dart';
import 'package:uskudar_mobile/domain/usecases/update_email_send_code_usecase.dart';

part 'change_email_event.dart';
part 'change_email_state.dart';

final class ChangeEmailBloc extends Bloc<ChangeEmailEvent, ChangeEmailState> {
  ChangeEmailBloc({
    required UpdateEmailSendCodeUsecase updateEmailSendCodeUsecase,
  })  : _updateEmailSendCodeUsecase = updateEmailSendCodeUsecase,
        super(const ChangeEmailState()) {
    on<ChangeEmailSubmit>(_onSubmit);
    on<ChangeEmailReset>(_onReset);
  }

  final UpdateEmailSendCodeUsecase _updateEmailSendCodeUsecase;

  Future<void> _onSubmit(
    ChangeEmailSubmit event,
    Emitter<ChangeEmailState> emit,
  ) async {
    emit(state.copyWith(status: ChangeEmailStatus.loading));

    final params = UpdateEmailSendCodeParams(
      newEmailAddress: event.newEmailAddress,
    );

    final result = await _updateEmailSendCodeUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChangeEmailStatus.error,
          message: failure.message,
        ),
      ),
      (processCode) => emit(
        state.copyWith(
          status: ChangeEmailStatus.success,
          processCode: processCode,
        ),
      ),
    );
  }

  void _onReset(
    ChangeEmailReset event,
    Emitter<ChangeEmailState> emit,
  ) {
    emit(const ChangeEmailState());
  }
}
