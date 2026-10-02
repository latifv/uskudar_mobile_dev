import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/user_question.dart';
import 'package:payinall/domain/params/update_secret_question_params.dart';
import 'package:payinall/domain/usecases/get_user_questions_usecase.dart';
import 'package:payinall/domain/usecases/update_secret_question_usecase.dart';

part 'secret_question_event.dart';
part 'secret_question_state.dart';

final class SecretQuestionBloc
    extends Bloc<SecretQuestionEvent, SecretQuestionState> {
  SecretQuestionBloc({
    required GetUserQuestionsUsecase getUserQuestionsUsecase,
    required UpdateSecretQuestionUsecase updateSecretQuestionUsecase,
  }) : _getUserQuestionsUsecase = getUserQuestionsUsecase,
       _updateSecretQuestionUsecase = updateSecretQuestionUsecase,
       super(const SecretQuestionState()) {
    on<SecretQuestionLoadQuestions>(_onLoadQuestions);
    on<SecretQuestionSubmit>(_onSubmit);
  }

  final GetUserQuestionsUsecase _getUserQuestionsUsecase;
  final UpdateSecretQuestionUsecase _updateSecretQuestionUsecase;

  Future<void> _onLoadQuestions(
    SecretQuestionLoadQuestions event,
    Emitter<SecretQuestionState> emit,
  ) async {
    emit(state.copyWith(status: SecretQuestionStatus.loading));

    final result = await _getUserQuestionsUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SecretQuestionStatus.error,
          message: failure.message,
        ),
      ),
      (questions) => emit(
        state.copyWith(
          status: SecretQuestionStatus.loaded,
          userQuestions: questions,
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    SecretQuestionSubmit event,
    Emitter<SecretQuestionState> emit,
  ) async {
    emit(state.copyWith(status: SecretQuestionStatus.submitting));

    final params = UpdateSecretQuestionParams(
      userQuestionId: event.userQuestionId,
      secretQuestion: event.secretQuestion,
    );

    final result = await _updateSecretQuestionUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SecretQuestionStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: SecretQuestionStatus.success,
          message: message,
        ),
      ),
    );
  }
}
