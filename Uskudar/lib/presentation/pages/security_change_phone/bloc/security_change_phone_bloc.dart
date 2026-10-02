import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/params/question_name_params.dart';
import 'package:uskudar_mobile/domain/usecases/get_question_name_usecase.dart';

part 'security_change_phone_event.dart';
part 'security_change_phone_state.dart';

final class SecurityChangePhoneBloc
    extends Bloc<SecurityChangePhoneEvent, SecurityChangePhoneState> {
  SecurityChangePhoneBloc({
    required GetQuestionNameUsecase getQuestionNameUsecase,
  }) : _getQuestionNameUsecase = getQuestionNameUsecase,
       super(const SecurityChangePhoneState()) {
    on<SecurityChangePhoneSubmit>(_onSecurityChangePhoneSubmit);
  }

  final GetQuestionNameUsecase _getQuestionNameUsecase;

  Future<void> _onSecurityChangePhoneSubmit(
    SecurityChangePhoneSubmit event,
    Emitter<SecurityChangePhoneState> emit,
  ) async {
    emit(state.copyWith(status: SecurityChangePhoneStatus.loading));
    final params = QuestionNameParams(identityNumber: event.tcNumber);
    final result = await _getQuestionNameUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: SecurityChangePhoneStatus.error,
          message: l.message,
          key: UniqueKey(),
        ),
      ),
      (r) => emit(
        state.copyWith(status: SecurityChangePhoneStatus.success, question: r),
      ),
    );
  }
}
