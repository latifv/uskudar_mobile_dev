import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/enums/login_type.dart';
import 'package:payinall/domain/params/merchant_user_forgot_password_params.dart';
import 'package:payinall/domain/params/question_name_params.dart';
import 'package:payinall/domain/usecases/get_question_name_usecase.dart';
import 'package:payinall/domain/usecases/merchant_user_forgot_password_usecase.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

part 'security_forgot_password_event.dart';
part 'security_forgot_password_state.dart';

final class SecurityForgotPasswordBloc
    extends Bloc<SecurityForgotPasswordEvent, SecurityForgotPasswordState> {
  SecurityForgotPasswordBloc({
    required GetQuestionNameUsecase getQuestionNameUsecase,
    required MerchantUserForgotPasswordUsecase
    merchantUserForgotPasswordUsecase,
  }) : _getQuestionNameUsecase = getQuestionNameUsecase,
       _merchantUserForgotPasswordUsecase = merchantUserForgotPasswordUsecase,
       super(const SecurityForgotPasswordState()) {
    on<SecurityForgotPasswordLoginTypeChange>(_onLoginTypeChange);
    on<SecurityForgotPasswordSubmit>(_onSecurityForgotPasswordSubmit);
  }

  final GetQuestionNameUsecase _getQuestionNameUsecase;
  final MerchantUserForgotPasswordUsecase _merchantUserForgotPasswordUsecase;

  Future<void> _onLoginTypeChange(
    SecurityForgotPasswordLoginTypeChange event,
    Emitter<SecurityForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(loginType: event.loginType));
  }

  Future<void> _onSecurityForgotPasswordSubmit(
    SecurityForgotPasswordSubmit event,
    Emitter<SecurityForgotPasswordState> emit,
  ) async {
    if (state.status == SecurityForgotPasswordStatus.processing) {
      return;
    }
    emit(state.copyWith(status: SecurityForgotPasswordStatus.processing));

    if (state.loginType == LoginType.merchant) {
      if (event.gsmNumber == null || event.customerNumber == null) {
        emit(
          state.copyWith(
            status: SecurityForgotPasswordStatus.error,
            message: LocaleKeys.unknown_error.translate,
          ),
        );
        return;
      }

      final params = MerchantUserForgotPasswordParams(
        gsmNumber: event.gsmNumber!,
        customerNumber: event.customerNumber!,
      );
      final result = await _merchantUserForgotPasswordUsecase(params);

      result.fold(
        (l) => emit(
          state.copyWith(
            status: SecurityForgotPasswordStatus.error,
            message: l.message,
          ),
        ),
        (r) => emit(
          state.copyWith(
            status: SecurityForgotPasswordStatus.success,
            message: r,
          ),
        ),
      );
    } else {
      if (event.tcNumber == null) {
        emit(
          state.copyWith(
            status: SecurityForgotPasswordStatus.error,
            message: LocaleKeys.unknown_error.translate,
          ),
        );
        return;
      }

      final params = QuestionNameParams(identityNumber: event.tcNumber!);
      final result = await _getQuestionNameUsecase(params);

      result.fold(
        (l) => emit(
          state.copyWith(
            status: SecurityForgotPasswordStatus.error,
            message: l.message,
          ),
        ),
        (r) => emit(
          state.copyWith(
            status: SecurityForgotPasswordStatus.success,
            question: r,
          ),
        ),
      );
    }
  }
}
