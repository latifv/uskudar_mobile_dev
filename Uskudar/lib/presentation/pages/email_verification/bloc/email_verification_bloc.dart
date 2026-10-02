import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/domain/params/email_verification_confirm_params.dart';
import 'package:uskudar_mobile/domain/params/update_email_confirm_params.dart';
import 'package:uskudar_mobile/domain/params/update_email_send_code_params.dart';
import 'package:uskudar_mobile/domain/usecases/email_verification_confirm_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/email_verification_send_code_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/update_email_confirm_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/update_email_send_code_usecase.dart';
import 'package:uskudar_mobile/presentation/shared/constants/validator_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

part 'email_verification_event.dart';
part 'email_verification_state.dart';

final class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  EmailVerificationBloc({
    required EmailVerificationSendCodeUsecase emailVerificationSendCodeUsecase,
    required EmailVerificationConfirmUsecase emailVerificationConfirmUsecase,
    required UpdateEmailSendCodeUsecase updateEmailSendCodeUsecase,
    required UpdateEmailConfirmUsecase updateEmailConfirmUsecase,
  })  : _emailVerificationSendCodeUsecase = emailVerificationSendCodeUsecase,
        _emailVerificationConfirmUsecase = emailVerificationConfirmUsecase,
        _updateEmailSendCodeUsecase = updateEmailSendCodeUsecase,
        _updateEmailConfirmUsecase = updateEmailConfirmUsecase,
        super(const EmailVerificationState()) {
    _registerEventHandlers();
    _initTimerController();
  }

  final EmailVerificationSendCodeUsecase _emailVerificationSendCodeUsecase;
  final EmailVerificationConfirmUsecase _emailVerificationConfirmUsecase;
  final UpdateEmailSendCodeUsecase _updateEmailSendCodeUsecase;
  final UpdateEmailConfirmUsecase _updateEmailConfirmUsecase;

  final int _timerDuration = 180;
  int _remainingTime = 0;
  bool _canResend = true;
  Timer? _timer;
  late final StreamController<EmailTimerState> _timerController;

  int get timerDuration => _timerDuration;
  Stream<EmailTimerState> get timerStream => _timerController.stream;
  EmailTimerState get timerState =>
      EmailTimerState(remainingTime: _remainingTime, canResend: _canResend);
  bool get isTimerActive => _timer?.isActive ?? false;

  @override
  Future<void> close() async {
    _timer?.cancel();
    if (!_timerController.isClosed) {
      await _timerController.close();
    }
    return super.close();
  }

  void _registerEventHandlers() {
    on<EmailUpdateVerificationSubmit>(_onEmailUpdateSubmit);
    on<EmailChangeVerificationSubmit>(_onEmailChangeSubmit);
    on<EmailUpdateVerificationResend>(_onEmailUpdateResend);
    on<EmailChangeVerificationResend>(_onEmailChangeResend);
    on<EmailVerificationTimerStart>(_onTimerStart);
    on<EmailVerificationTimerReStart>(_onTimerReStart);
    on<EmailVerificationTimerTick>(_onTimerTick);
    on<EmailVerificationTimerComplete>(_onTimerComplete);
  }

  void _initTimerController() {
    _timerController = StreamController<EmailTimerState>.broadcast();
  }

  Future<void> _onEmailUpdateSubmit(
    EmailUpdateVerificationSubmit event,
    Emitter<EmailVerificationState> emit,
  ) async {
    if (!_isTimerValid(emit)) return;
    if (!_isCodeValid(event.code, emit)) return;
    if (!_isProcessCodeValid(emit)) return;
    if (state.status == EmailVerificationBlocStatus.processing) return;
    emit(state.copyWith(status: EmailVerificationBlocStatus.processing));

    final params = EmailVerificationConfirmParams(
      code: event.code,
      processCode: event.processCode,
    );

    final result = await _emailVerificationConfirmUsecase(params);

    await result.match(
      (failure) async {
        emit(
          state.copyWith(
            status: EmailVerificationBlocStatus.error,
            message: failure.message,
          ),
        );
      },
      (success) async {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              status: EmailVerificationBlocStatus.success,
              message: success,
            ),
          );
        }
      },
    );
  }

  Future<void> _onEmailChangeSubmit(
    EmailChangeVerificationSubmit event,
    Emitter<EmailVerificationState> emit,
  ) async {
    if (!_isTimerValid(emit)) return;
    if (!_isCodeValid(event.code, emit)) return;
    if (!_isProcessCodeValid(emit)) return;
    if (state.status == EmailVerificationBlocStatus.processing) return;
    emit(state.copyWith(status: EmailVerificationBlocStatus.processing));

    final params = UpdateEmailConfirmParams(
      code: event.code,
      processCode: event.processCode,
    );

    final result = await _updateEmailConfirmUsecase(params);

    await result.match(
      (failure) async {
        emit(
          state.copyWith(
            status: EmailVerificationBlocStatus.error,
            message: failure.message,
          ),
        );
      },
      (success) async {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              status: EmailVerificationBlocStatus.success,
              message: success,
            ),
          );
        }
      },
    );
  }

  Future<void> _onEmailUpdateResend(
    EmailUpdateVerificationResend event,
    Emitter<EmailVerificationState> emit,
  ) async {
    if (!_canResendCode(emit)) return;
    if (state.status == EmailVerificationBlocStatus.processing) return;

    emit(state.copyWith(status: EmailVerificationBlocStatus.processing));

    final result = await _emailVerificationSendCodeUsecase();

    await result.match(
      (failure) async {
        emit(
          state.copyWith(
            status: EmailVerificationBlocStatus.error,
            message: failure.message,
          ),
        );
      },
      (processCode) async {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              status: EmailVerificationBlocStatus.loaded,
              processCode: processCode,
            ),
          );
          add(EmailVerificationTimerReStart(processCode: processCode));
        }
      },
    );
  }

  Future<void> _onEmailChangeResend(
    EmailChangeVerificationResend event,
    Emitter<EmailVerificationState> emit,
  ) async {
    if (!_canResendCode(emit)) return;
    if (state.status == EmailVerificationBlocStatus.processing) return;

    emit(state.copyWith(status: EmailVerificationBlocStatus.processing));

    final params = UpdateEmailSendCodeParams(
      newEmailAddress: event.newEmailAddress,
    );

    final result = await _updateEmailSendCodeUsecase(params);

    await result.match(
      (failure) async {
        emit(
          state.copyWith(
            status: EmailVerificationBlocStatus.error,
            message: failure.message,
          ),
        );
      },
      (processCode) async {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              status: EmailVerificationBlocStatus.loaded,
              processCode: processCode,
            ),
          );
          add(EmailVerificationTimerReStart(processCode: processCode));
        }
      },
    );
  }

  Future<void> _onTimerStart(
    EmailVerificationTimerStart event,
    Emitter<EmailVerificationState> emit,
  ) async {
    _startTimer();
    emit(state.copyWith(
      status: EmailVerificationBlocStatus.loaded,
      processCode: event.processCode,
    ));
  }

  Future<void> _onTimerReStart(
    EmailVerificationTimerReStart event,
    Emitter<EmailVerificationState> emit,
  ) async {
    _startTimer();
    emit(state.copyWith(
      status: EmailVerificationBlocStatus.loaded,
      processCode: event.processCode,
    ));
  }

  Future<void> _onTimerTick(
    EmailVerificationTimerTick event,
    Emitter<EmailVerificationState> emit,
  ) async {
    if (_remainingTime > 0) {
      _remainingTime--;
      _canResend = false;
      _timerController.add(EmailTimerState(
        remainingTime: _remainingTime,
        canResend: _canResend,
      ));
    } else {
      add(const EmailVerificationTimerComplete());
    }
  }

  Future<void> _onTimerComplete(
    EmailVerificationTimerComplete event,
    Emitter<EmailVerificationState> emit,
  ) async {
    _timer?.cancel();
    _canResend = true;
    _timerController.add(EmailTimerState(
      remainingTime: _remainingTime,
      canResend: _canResend,
    ));
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingTime = _timerDuration;
    _canResend = false;
    _timerController.add(EmailTimerState(
      remainingTime: _remainingTime,
      canResend: _canResend,
    ));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const EmailVerificationTimerTick());
    });
  }

  bool _isTimerValid(Emitter<EmailVerificationState> emit) {
    if (_remainingTime <= 0) {
      final message = LocaleKeys.session_expired.translate;
      emit(state.copyWith(
        status: EmailVerificationBlocStatus.error,
        message: message,
      ));
      LogHelper.log(LogLevel.warning, message);
      return false;
    }
    return true;
  }

  bool _isCodeValid(String code, Emitter<EmailVerificationState> emit) {
    if (code.isEmpty || code.length != ValidatorConstants.pinLength) {
      final message = LocaleKeys.enter_verification_code.translate;
      emit(state.copyWith(
        status: EmailVerificationBlocStatus.error,
        message: message,
      ));
      LogHelper.log(LogLevel.warning, message);
      return false;
    }
    return true;
  }

  bool _isProcessCodeValid(Emitter<EmailVerificationState> emit) {
    if (state.processCode == null || state.processCode!.isEmpty) {
      final message = LocaleKeys.process_code_missing.translate;
      emit(state.copyWith(
        status: EmailVerificationBlocStatus.error,
        message: message,
      ));
      LogHelper.log(LogLevel.warning, message);
      return false;
    }
    return true;
  }

  bool _canResendCode(Emitter<EmailVerificationState> emit) {
    if (!_canResend) {
      final message = LocaleKeys.please_wait_resend.translate;
      emit(state.copyWith(
        status: EmailVerificationBlocStatus.error,
        message: message,
      ));
      LogHelper.log(LogLevel.warning, message);
      return false;
    }
    return true;
  }
}
