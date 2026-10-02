import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/core/services/device_info_service.dart';
import 'package:uskudar_mobile/core/services/firebase_service.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/domain/params/change_phone_code_params.dart';
import 'package:uskudar_mobile/domain/params/change_phone_params.dart';
import 'package:uskudar_mobile/domain/params/check_activation_code_params.dart';
import 'package:uskudar_mobile/domain/params/check_merchant_activation_code_params.dart';
import 'package:uskudar_mobile/domain/params/check_register_code_params.dart';
import 'package:uskudar_mobile/domain/params/create_register_code_params.dart';
import 'package:uskudar_mobile/domain/params/customer_mobiles_params.dart';
import 'package:uskudar_mobile/domain/params/send_new_code_params.dart';
import 'package:uskudar_mobile/domain/usecases/change_phone_code_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/change_phone_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/check_activation_code_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/check_merchant_activation_code_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/check_register_code_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/create_register_code_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/customer_mobiles_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/logout_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/send_new_code_usecase.dart';
import 'package:uskudar_mobile/presentation/shared/constants/validator_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uuid/uuid.dart';

part 'sms_verification_event.dart';
part 'sms_verification_state.dart';

final class SmsVerificationBloc
    extends Bloc<SmsVerificationEvent, SmsVerificationState> {
  SmsVerificationBloc({
    required CheckRegisterCodeUsecase checkRegisterCodeUsecase,
    required CreateRegisterCodeUsecase createRegisterCodeUsecase,
    required CheckActivationCodeUsecase checkActivationCodeUsecase,
    required CheckMerchantActivationCodeUsecase
    checkMerchantActivationCodeUsecase,
    required SendNewCodeUsecase sendNewCodeUsecase,
    required ChangePhoneUsecase changePhoneUsecase,
    required ChangePhoneCodeUsecase changePhoneCodeUsecase,
    required LogoutUsecase logoutUsecase,
    required CustomerMobilesUsecase customerMobilesUsecase,
    required DeviceInfoService deviceInfoService,
    required FirebaseService firebaseService,
    required UserInfoManager userInfoManager,
  }) : _checkRegisterCodeUsecase = checkRegisterCodeUsecase,
       _createRegisterCodeUsecase = createRegisterCodeUsecase,
       _checkActivationCodeUsecase = checkActivationCodeUsecase,
       _checkMerchantActivationCodeUsecase = checkMerchantActivationCodeUsecase,
       _sendNewCodeUsecase = sendNewCodeUsecase,
       _changePhoneUsecase = changePhoneUsecase,
       _changePhoneCodeUsecase = changePhoneCodeUsecase,
       _logoutUsecase = logoutUsecase,
       _customerMobilesUsecase = customerMobilesUsecase,
       _deviceInfoService = deviceInfoService,
       _firebaseService = firebaseService,
       _userInfoManager = userInfoManager,
       super(const SmsVerificationState()) {
    _registerEventHandlers();
    _initTimerController();
  }

  final CheckRegisterCodeUsecase _checkRegisterCodeUsecase;
  final CreateRegisterCodeUsecase _createRegisterCodeUsecase;
  final CheckActivationCodeUsecase _checkActivationCodeUsecase;
  final CheckMerchantActivationCodeUsecase _checkMerchantActivationCodeUsecase;
  final SendNewCodeUsecase _sendNewCodeUsecase;
  final ChangePhoneUsecase _changePhoneUsecase;
  final ChangePhoneCodeUsecase _changePhoneCodeUsecase;
  final LogoutUsecase _logoutUsecase;
  final CustomerMobilesUsecase _customerMobilesUsecase;
  final DeviceInfoService _deviceInfoService;
  final FirebaseService _firebaseService;
  final UserInfoManager _userInfoManager;

  final int _timerDuration = 180;
  int _remainingTime = 0;
  bool _canResend = true;
  Timer? _timer;
  late final StreamController<TimerState> _timerController;

  int get timerDuration => _timerDuration;
  Stream<TimerState> get timerStream => _timerController.stream;
  TimerState get timerState =>
      TimerState(remainingTime: _remainingTime, canResend: _canResend);
  bool get isTimerActive => _timer?.isActive ?? false;

  @override
  Future<void> close() async {
    _timer?.cancel();
    if (!_timerController.isClosed) {
      await _timerController.close();
    }
    return super.close();
  }

  void _initTimerController() {
    _timerController = StreamController<TimerState>.broadcast();
  }

  void _registerEventHandlers() {
    on<RegisterSmsVerificationSubmit>(_onRegisterSubmit);
    on<RegisterSmsVerificationResend>(_onRegisterResend);
    on<LoginSmsVerificationSubmit>(_onLoginSubmit);
    on<LoginSmsVerificationResend>(_onLoginResend);
    on<MerchantLoginSmsVerificationSubmit>(_onMerchantLoginSubmit);
    on<SmsVerificationTimerTick>(_onTimerTick);
    on<SmsVerificationTimerComplete>(_onTimerComplete);
    on<SmsVerificationTimerStart>(_onTimerStart);
    on<SmsVerificationTimerReStart>(_onTimerReStart);
    on<ChangePhoneNumberSmsVerificationSubmit>(_onChangePhoneNumberSubmit);
    on<ChangePhoneNumberSmsVerificationResend>(_onChangePhoneNumberResend);
  }

  Future<void> _onTimerStart(
    SmsVerificationTimerStart event,
    Emitter<SmsVerificationState> emit,
  ) async {
    emit(state.copyWith(status: SmsVerificationBlocStatus.loading));
    _timer?.cancel();
    _remainingTime = _timerDuration;
    _canResend = false;

    _timerController.add(timerState);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const SmsVerificationTimerTick());
    });

    emit(
      state.copyWith(
        status: SmsVerificationBlocStatus.loaded,
        processCode: event.processCode,
      ),
    );
  }

  Future<void> _onTimerReStart(
    SmsVerificationTimerReStart event,
    Emitter<SmsVerificationState> emit,
  ) async {
    _timer?.cancel();
    _remainingTime = _timerDuration;
    _canResend = false;

    _timerController.add(timerState);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const SmsVerificationTimerTick());
    });
  }

  Future<void> _onTimerTick(
    SmsVerificationTimerTick event,
    Emitter<SmsVerificationState> emit,
  ) async {
    _remainingTime--;
    _timerController.add(timerState);

    if (_remainingTime <= 0) {
      add(const SmsVerificationTimerComplete());
    }
  }

  Future<void> _onTimerComplete(
    SmsVerificationTimerComplete event,
    Emitter<SmsVerificationState> emit,
  ) async {
    _timer?.cancel();
    _timer = null;
    _canResend = true;
    _timerController.add(timerState);
  }

  bool _isPinValid(String pin, Emitter<SmsVerificationState> emit) {
    if (pin.length != ValidatorConstants.pinLength) {
      emit(
        state.copyWith(
          key: const Uuid().v4(),
          status: SmsVerificationBlocStatus.error,
          message: LocaleKeys.verification_code_length.translate,
        ),
      );
      return false;
    }
    return true;
  }

  bool _isProcessCodeValid(Emitter<SmsVerificationState> emit) {
    if (state.processCode == null) {
      emit(
        state.copyWith(
          status: SmsVerificationBlocStatus.error,
          message: LocaleKeys.unknown_error.translate,
        ),
      );
      return false;
    }
    return true;
  }

  bool _isTimerValid(Emitter<SmsVerificationState> emit) {
    if (!isTimerActive) {
      emit(
        state.copyWith(
          key: const Uuid().v4(),
          status: SmsVerificationBlocStatus.error,
          message: LocaleKeys.request_new_code.translate,
        ),
      );
      return false;
    }
    return true;
  }

  bool _canResendCode(Emitter<SmsVerificationState> emit) {
    if (!_canResend) {
      emit(
        state.copyWith(
          key: const Uuid().v4(),
          status: SmsVerificationBlocStatus.error,
          message: LocaleKeys.verification_wait_for_resend.translate,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _onRegisterSubmit(
    RegisterSmsVerificationSubmit event,
    Emitter<SmsVerificationState> emit,
  ) async {
    if (!_isTimerValid(emit)) return;
    if (!_isPinValid(event.pin, emit)) return;
    if (!_isProcessCodeValid(emit)) return;
    if (state.status == SmsVerificationBlocStatus.processing) return;

    emit(state.copyWith(status: SmsVerificationBlocStatus.processing));

    final params = CheckRegisterCodeParams(
      activationProcessCode: state.processCode!,
      code: event.pin,
    );

    final result = await _checkRegisterCodeUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SmsVerificationBlocStatus.error,
          message: failure.message,
        ),
      ),
      (success) =>
          emit(state.copyWith(status: SmsVerificationBlocStatus.success)),
    );
  }

  Future<void> _onRegisterResend(
    RegisterSmsVerificationResend event,
    Emitter<SmsVerificationState> emit,
  ) async {
    if (!_canResendCode(emit)) return;
    if (state.status == SmsVerificationBlocStatus.processing) return;
    emit(state.copyWith(status: SmsVerificationBlocStatus.processing));

    final params = CreateRegisterCodeParams(gsmNumber: event.phoneNumber);
    final result = await _createRegisterCodeUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SmsVerificationBlocStatus.error,
          message: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            status: SmsVerificationBlocStatus.loaded,
            message: success.message,
            processCode: success.data,
          ),
        );
        add(SmsVerificationTimerReStart(processCode: success.data));
      },
    );
  }

  Future<void> _onLoginSubmit(
    LoginSmsVerificationSubmit event,
    Emitter<SmsVerificationState> emit,
  ) async {
    if (!_isTimerValid(emit)) return;
    if (!_isPinValid(event.pin, emit)) return;
    if (!_isProcessCodeValid(emit)) return;
    if (state.status == SmsVerificationBlocStatus.processing) return;
    emit(state.copyWith(status: SmsVerificationBlocStatus.processing));

    final params = CheckActivationCodeParams(
      activationProcessCode: state.processCode!,
      activationCode: event.pin,
    );

    final result = await _checkActivationCodeUsecase(params);

    await result.match(
      (failure) async {
        emit(
          state.copyWith(
            status: SmsVerificationBlocStatus.error,
            message: failure.message,
          ),
        );
      },
      (success) async {
        try {
          final deviceId = await _deviceInfoService.getDeviceId();
          final notificationToken = await _firebaseService.getFirebaseToken();
          final customerParams = CustomerMobilesParams(
            deviceId: deviceId,
            notificationToken: notificationToken,
          );

          final customerResult =
              await _customerMobilesUsecase(customerParams);

          if (!emit.isDone) {
            customerResult.fold(
              (failure) => emit(
                state.copyWith(
                  status: SmsVerificationBlocStatus.error,
                  message: failure.message,
                ),
              ),
              (_) {
                _userInfoManager.setIsMerchant(false);
                emit(
                  state.copyWith(
                    status: SmsVerificationBlocStatus.success,
                  ),
                );
              },
            );
          }
        } on Exception catch (e, st) {
          LogHelper.logCriticalError(e, st);
          if (!emit.isDone) {
            emit(
              state.copyWith(
                status: SmsVerificationBlocStatus.error,
                message: LocaleKeys.token_not_ready.translate,
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _onLoginResend(
    LoginSmsVerificationResend event,
    Emitter<SmsVerificationState> emit,
  ) async {
    if (!_canResendCode(emit)) return;
    if (state.status == SmsVerificationBlocStatus.processing) return;
    emit(state.copyWith(status: SmsVerificationBlocStatus.processing));

    final params = SendNewCodeParams(activationProcessCode: event.processCode);
    final result = await _sendNewCodeUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SmsVerificationBlocStatus.error,
          message: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            status: SmsVerificationBlocStatus.loaded,
            message: success.message,
            processCode: success.data,
          ),
        );
        add(SmsVerificationTimerReStart(processCode: success.data));
      },
    );
  }

  Future<void> _onMerchantLoginSubmit(
    MerchantLoginSmsVerificationSubmit event,
    Emitter<SmsVerificationState> emit,
  ) async {
    if (!_isTimerValid(emit)) return;
    if (!_isPinValid(event.pin, emit)) return;
    if (!_isProcessCodeValid(emit)) return;
    if (state.status == SmsVerificationBlocStatus.processing) return;
    emit(state.copyWith(status: SmsVerificationBlocStatus.processing));

    final params = CheckMerchantActivationCodeParams(
      activationProcessCode: state.processCode!,
      activationCode: event.pin,
    );

    final result = await _checkMerchantActivationCodeUsecase(params);

    await result.match(
      (failure) async {
        emit(
          state.copyWith(
            status: SmsVerificationBlocStatus.error,
            message: failure.message,
          ),
        );
      },
      (success) async {
        if (!emit.isDone) {
          _userInfoManager.setIsMerchant(true);
          emit(state.copyWith(status: SmsVerificationBlocStatus.success));
        }
      },
    );
  }

  Future<void> _onChangePhoneNumberSubmit(
    ChangePhoneNumberSmsVerificationSubmit event,
    Emitter<SmsVerificationState> emit,
  ) async {
    if (!_isTimerValid(emit)) return;
    if (!_isPinValid(event.pin, emit)) return;
    if (!_isProcessCodeValid(emit)) return;
    if (state.status == SmsVerificationBlocStatus.processing) return;
    final params = ChangePhoneParams(
      code: event.pin,
      processNumber: event.processCode,
    );

    emit(state.copyWith(status: SmsVerificationBlocStatus.processing));

    final result = await _changePhoneUsecase(params);

    await result.match(
      (failure) async {
        emit(
          state.copyWith(
            status: SmsVerificationBlocStatus.error,
            message: failure.message,
          ),
        );
      },
      (successMessage) async {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              status: SmsVerificationBlocStatus.success,
              message: successMessage,
            ),
          );
        }

        try {
          await _logoutUsecase();
        } on Exception catch (e) {
          LogHelper.log(LogLevel.error, 'Logout hatası: $e');
        }
      },
    );
  }

  Future<void> _onChangePhoneNumberResend(
    ChangePhoneNumberSmsVerificationResend event,
    Emitter<SmsVerificationState> emit,
  ) async {
    if (!_canResendCode(emit)) return;
    if (state.status == SmsVerificationBlocStatus.processing) return;
    final params = ChangePhoneCodeParams(
      newGsmNumber: event.newPhoneNumber,
      identityNumber: event.identityNumber,
      answer: event.securityQuestionAnswer,
    );

    emit(state.copyWith(status: SmsVerificationBlocStatus.processing));

    final result = await _changePhoneCodeUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: SmsVerificationBlocStatus.error,
          message: l.message,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            status: SmsVerificationBlocStatus.loaded,
            message: r.message,
            processCode: r.data,
          ),
        );
        add(SmsVerificationTimerReStart(processCode: r.data));
      },
    );
  }
}
