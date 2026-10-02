import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/core/services/device_info_service.dart';
import 'package:uskudar_mobile/core/services/firebase_service.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/domain/params/auth_mobile_params.dart';
import 'package:uskudar_mobile/domain/params/customer_mobiles_params.dart';
import 'package:uskudar_mobile/domain/usecases/auth_mobile_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/customer_mobiles_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/logout_usecase.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

part 'password_confirmation_event.dart';
part 'password_confirmation_state.dart';

final class PasswordConfirmationBloc
    extends Bloc<PasswordConfirmationEvent, PasswordConfirmationState> {
  PasswordConfirmationBloc({
    required LogoutUsecase logoutUsecase,
    required AuthMobileUsecase authMobileUsecase,
    required DeviceInfoService deviceInfoService,
    required CustomerMobilesUsecase customerMobilesUsecase,
    required FirebaseService firebaseService,
    required UserInfoManager userInfoManager,
  }) : _logoutUsecase = logoutUsecase,
       _authMobileUsecase = authMobileUsecase,
       _deviceInfoService = deviceInfoService,
       _customerMobilesUsecase = customerMobilesUsecase,
       _firebaseService = firebaseService,
       _userInfoManager = userInfoManager,
       super(const PasswordConfirmationState()) {
    on<PasswordConfirmationSubmit>(_onSubmit);
    on<PasswordConfirmationLogout>(_onLogout);
  }

  final LogoutUsecase _logoutUsecase;
  final AuthMobileUsecase _authMobileUsecase;
  final DeviceInfoService _deviceInfoService;
  final CustomerMobilesUsecase _customerMobilesUsecase;
  final FirebaseService _firebaseService;
  final UserInfoManager _userInfoManager;
  Future<void> _onSubmit(
    PasswordConfirmationSubmit event,
    Emitter<PasswordConfirmationState> emit,
  ) async {
    if (state.status == PasswordConfirmationStatus.processing) {
      return;
    }

    emit(state.copyWith(status: PasswordConfirmationStatus.processing));

    final deviceId = await _deviceInfoService.getDeviceId();
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
            status: PasswordConfirmationStatus.error,
            message: failure.message,
          ),
        );
      },
      (response) async {
        if (response.token != null) {
          try {
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
                    status: PasswordConfirmationStatus.error,
                    message: failure.message,
                  ),
                ),
                (_) {
                  _userInfoManager.setIsMerchant(false);
                  emit(
                    state.copyWith(
                      status: PasswordConfirmationStatus.success,
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
                  status: PasswordConfirmationStatus.error,
                  message: LocaleKeys.token_not_ready.translate,
                ),
              );
            }
          }
        } else {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                status: PasswordConfirmationStatus.smsVerification,
                activationProcessCode: response.activationProcessCode,
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _onLogout(
    PasswordConfirmationLogout event,
    Emitter<PasswordConfirmationState> emit,
  ) async {
    if (state.status == PasswordConfirmationStatus.processing) {
      return;
    }

    emit(state.copyWith(status: PasswordConfirmationStatus.processing));

    final result = await _logoutUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PasswordConfirmationStatus.error,
          message: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(status: PasswordConfirmationStatus.logoutSuccess),
      ),
    );
  }
}
