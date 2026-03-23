import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/core/services/device_info_service.dart';
import 'package:payinall/core/services/firebase_service.dart';
import 'package:payinall/domain/entities/logged_in.dart';
import 'package:payinall/domain/enums/login_type.dart';
import 'package:payinall/domain/params/auth_merchant_params.dart';
import 'package:payinall/domain/params/auth_mobile_params.dart';
import 'package:payinall/domain/params/customer_mobiles_params.dart';
import 'package:payinall/domain/usecases/auth_merchant_usecase.dart';
import 'package:payinall/domain/usecases/auth_mobile_usecase.dart';
import 'package:payinall/domain/usecases/customer_mobiles_usecase.dart';
import 'package:payinall/domain/usecases/save_logged_in_usecase.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

part 'login_event.dart';
part 'login_state.dart';

final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthMobileUsecase authMobileUsecase,
    required AuthMerchantUsecase authMerchantUsecase,
    required DeviceInfoService deviceInfoService,
    required SaveLoggedInUsecase saveLoggedInUsecase,
    required CustomerMobilesUsecase customerMobilesUsecase,
    required FirebaseService firebaseService,
    required UserInfoManager userInfoManager,
  }) : _authMobileUsecase = authMobileUsecase,
       _authMerchantUsecase = authMerchantUsecase,
       _deviceInfoService = deviceInfoService,
       _saveLoggedInUsecase = saveLoggedInUsecase,
       _customerMobilesUsecase = customerMobilesUsecase,
       _firebaseService = firebaseService,
       _userInfoManager = userInfoManager,
       super(const LoginState()) {
    on<LoginSubmit>(_onLoginSubmit);
    on<LoginRememberMeChange>(_onLoginRememberMeChange);
    on<LoginTypeChange>(_onLoginTypeChange);
  }

  final AuthMobileUsecase _authMobileUsecase;
  final AuthMerchantUsecase _authMerchantUsecase;
  final DeviceInfoService _deviceInfoService;
  final SaveLoggedInUsecase _saveLoggedInUsecase;
  final CustomerMobilesUsecase _customerMobilesUsecase;
  final FirebaseService _firebaseService;
  final UserInfoManager _userInfoManager;

  bool _rememberMe = true;
  bool get rememberMe => _rememberMe;
  final _rememberMeController = StreamController<bool>.broadcast();
  Stream<bool> get rememberMeStream => _rememberMeController.stream;

  @override
  Future<void> close() {
    unawaited(_rememberMeController.close());
    return super.close();
  }

  Future<void> _onLoginSubmit(
    LoginSubmit event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status == LoginBlocStatus.processing) {
      return;
    }

    emit(state.copyWith(status: LoginBlocStatus.processing));

    final deviceId = await _deviceInfoService.getDeviceId();

    if (event.isMerchant) {
      if (event.customerNumber == null || event.gsmNumber == null) {
        emit(
          state.copyWith(
            status: LoginBlocStatus.error,
            message: LocaleKeys.unknown_error.translate,
          ),
        );
        return;
      }

      final params = AuthMerchantParams(
        customerNumber: event.customerNumber!,
        gsmNumber: event.gsmNumber!,
        password: event.password,
        deviceId: deviceId,
      );

      final result = await _authMerchantUsecase(params);

      await result.match(
        (failure) async {
          emit(
            state.copyWith(
              status: LoginBlocStatus.error,
              message: failure.message,
            ),
          );
        },
        (response) async {
          if (response.token != null) {
            try {
              if (_rememberMe) {
                final loggedIn = LoggedIn(
                  identifier: event.gsmNumber!,
                );
                unawaited(_saveLoggedInUsecase(loggedIn));
              }

              _userInfoManager.setIsMerchant(true);

              if (!emit.isDone) {
                emit(state.copyWith(status: LoginBlocStatus.success));
              }
            } on Exception catch (e, st) {
              LogHelper.logCriticalError(e, st);
              if (!emit.isDone) {
                emit(
                  state.copyWith(
                    status: LoginBlocStatus.error,
                    message: LocaleKeys.token_not_ready.translate,
                  ),
                );
              }
            }
          } else if (response.customerStatus != null &&
              response.customerStatus == 4 &&
              response.activationProcessCode != null) {
            if (!emit.isDone) {
              emit(
                state.copyWith(
                  status: LoginBlocStatus.newPassword,
                  activationProcessCode: response.activationProcessCode,
                ),
              );
            }
          } else if (response.customerStatus != null &&
              response.customerStatus == 4 &&
              response.activationProcessCode == null) {
            if (!emit.isDone) {
              emit(
                state.copyWith(
                  status: LoginBlocStatus.error,
                  message:
                      LocaleKeys.reset_password_from_forgot_password.translate,
                ),
              );
            }
          } else {
            if (!emit.isDone) {
              emit(
                state.copyWith(
                  status: LoginBlocStatus.smsVerification,
                  activationProcessCode: response.activationProcessCode,
                ),
              );
            }
          }
        },
      );
      return;
    }

    final params = AuthMobileParams(
      loginInfo: event.identifier,
      password: event.password,
      deviceId: deviceId,
    );

    final result = await _authMobileUsecase(params);

    await result.match(
      (failure) async {
        emit(
          state.copyWith(
            status: LoginBlocStatus.error,
            message: failure.message,
          ),
        );
      },
      (response) async {
        if (response.token != null) {
          try {
            if (_rememberMe) {
              final loggedIn = LoggedIn(
                identifier: event.identifier,
              );
              unawaited(_saveLoggedInUsecase(loggedIn));
            }

            _userInfoManager.setIsMerchant(false);

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
                    status: LoginBlocStatus.error,
                    message: failure.message,
                  ),
                ),
                (_) =>
                    emit(state.copyWith(status: LoginBlocStatus.success)),
              );
            }
          } on Exception catch (e, st) {
            LogHelper.logCriticalError(e, st);
            if (!emit.isDone) {
              emit(
                state.copyWith(
                  status: LoginBlocStatus.error,
                  message: LocaleKeys.token_not_ready.translate,
                ),
              );
            }
          }
        } else if (response.customerStatus != null &&
            response.customerStatus == 4 &&
            response.activationProcessCode != null) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                status: LoginBlocStatus.newPassword,
                activationProcessCode: response.activationProcessCode,
              ),
            );
          }
        } else if (response.customerStatus != null &&
            response.customerStatus == 4 &&
            response.activationProcessCode == null) {
          //TODO: Bi bakılacak
          if (!emit.isDone) {
            emit(
              state.copyWith(
                status: LoginBlocStatus.error,
                message:
                    LocaleKeys.reset_password_from_forgot_password.translate,
              ),
            );
          }
        } else {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                status: LoginBlocStatus.smsVerification,
                activationProcessCode: response.activationProcessCode,
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _onLoginRememberMeChange(
    LoginRememberMeChange event,
    Emitter<LoginState> emit,
  ) async {
    _rememberMe = event.isChecked;
    _rememberMeController.add(_rememberMe);
  }

  Future<void> _onLoginTypeChange(
    LoginTypeChange event,
    Emitter<LoginState> emit,
  ) async {
    final shouldResetStatus = state.status == LoginBlocStatus.newPassword;

    emit(
      state.copyWith(
        loginType: event.loginType,
        status: LoginBlocStatus.initial,
        activationProcessCode: shouldResetStatus
            ? null
            : state.activationProcessCode,
      ),
    );
  }
}
