import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/user_question.dart';
import 'package:uskudar_mobile/domain/usecases/get_user_questions_usecase.dart';

part 'account_verification_event.dart';
part 'account_verification_state.dart';

final class AccountVerificationBloc
    extends Bloc<AccountVerificationEvent, AccountVerificationState> {
  AccountVerificationBloc({
    required GetUserQuestionsUsecase getUserQuestionsUsecase,
  }) : _getUserQuestionsUsecase = getUserQuestionsUsecase,
       super(const AccountVerificationState()) {
    on<AccountVerificationSubmit>(_onAccountVerificationSubmit);
    on<GetUserQuestions>(_onGetUserQuestions);
  }

  final GetUserQuestionsUsecase _getUserQuestionsUsecase;

  Future<void> _onGetUserQuestions(
    GetUserQuestions event,
    Emitter<AccountVerificationState> emit,
  ) async {
    emit(state.copyWith(status: AccountVerificationStatus.loading));

    final result = await _getUserQuestionsUsecase();
    result.fold(
      (l) => emit(
        state.copyWith(
          status: AccountVerificationStatus.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: AccountVerificationStatus.loaded,
          userQuestions: r,
        ),
      ),
    );
  }

  Future<void> _onAccountVerificationSubmit(
    AccountVerificationSubmit event,
    Emitter<AccountVerificationState> emit,
  ) async {
    if (state.status == AccountVerificationStatus.processing) {
      return;
    }

    emit(state.copyWith(status: AccountVerificationStatus.processing));

    emit(state.copyWith(status: AccountVerificationStatus.success));
  }
}
