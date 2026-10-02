import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/enums/score_operation_type.dart';
import 'package:uskudar_mobile/domain/params/score_operation_params.dart';
import 'package:uskudar_mobile/domain/params/user_score_calculate_params.dart';
import 'package:uskudar_mobile/domain/usecases/get_average_revenue_types_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_monthly_transaction_count_types_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_score_operations_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/user_score_calculate_usecase.dart';
import 'package:uskudar_mobile/presentation/pages/scoring_questions/bloc/scoring_questions_event.dart';
import 'package:uskudar_mobile/presentation/pages/scoring_questions/bloc/scoring_questions_state.dart';

final class ScoringQuestionsBloc
    extends Bloc<ScoringQuestionsEvent, ScoringQuestionsState> {
  ScoringQuestionsBloc({
    required GetAverageRevenueTypesUsecase getAverageRevenueTypesUsecase,
    required GetMonthlyTransactionCountTypesUsecase
    getMonthlyTransactionCountTypesUsecase,
    required GetScoreOperationsUsecase getScoreOperationsUsecase,
    required UserScoreCalculateUsecase userScoreCalculateUsecase,
  }) : _getAverageRevenueTypesUsecase = getAverageRevenueTypesUsecase,
       _getMonthlyTransactionCountTypesUsecase =
           getMonthlyTransactionCountTypesUsecase,
       _getScoreOperationsUsecase = getScoreOperationsUsecase,
       _userScoreCalculateUsecase = userScoreCalculateUsecase,
       super(const ScoringQuestionsState()) {
    on<ScoringQuestionsSubmit>(_onScoringQuestionsSubmit);
    on<GetConstantsData>(_onGetConstantsData);
    on<ScoringQuestionsUpdateWorkType>(_onUpdateWorkType);
    on<ScoringQuestionsUpdateProfession>(_onUpdateProfession);
    on<ScoringQuestionsUpdateIncome>(_onUpdateIncome);
    on<ScoringQuestionsUpdateMonthlyTransaction>(_onUpdateMonthlyTransaction);
    on<ScoringQuestionsUpdateIncomeSource>(_onUpdateIncomeSource);
  }

  final GetAverageRevenueTypesUsecase _getAverageRevenueTypesUsecase;
  final GetMonthlyTransactionCountTypesUsecase
  _getMonthlyTransactionCountTypesUsecase;
  final GetScoreOperationsUsecase _getScoreOperationsUsecase;
  final UserScoreCalculateUsecase _userScoreCalculateUsecase;

  void _onUpdateWorkType(
    ScoringQuestionsUpdateWorkType event,
    Emitter<ScoringQuestionsState> emit,
  ) {
    emit(state.copyWith(selectedWorkType: event.workType));
  }

  void _onUpdateProfession(
    ScoringQuestionsUpdateProfession event,
    Emitter<ScoringQuestionsState> emit,
  ) {
    emit(state.copyWith(selectedProfession: event.profession));
  }

  void _onUpdateIncome(
    ScoringQuestionsUpdateIncome event,
    Emitter<ScoringQuestionsState> emit,
  ) {
    emit(state.copyWith(selectedIncome: event.income));
  }

  void _onUpdateMonthlyTransaction(
    ScoringQuestionsUpdateMonthlyTransaction event,
    Emitter<ScoringQuestionsState> emit,
  ) {
    emit(
      state.copyWith(
        selectedMonthlyTransactionCount: event.monthlyTransactionCount,
      ),
    );
  }

  void _onUpdateIncomeSource(
    ScoringQuestionsUpdateIncomeSource event,
    Emitter<ScoringQuestionsState> emit,
  ) {
    emit(state.copyWith(selectedIncomeSource: event.incomeSource));
  }

  Future<void> _onScoringQuestionsSubmit(
    ScoringQuestionsSubmit event,
    Emitter<ScoringQuestionsState> emit,
  ) async {
    emit(state.copyWith(state: ScoringQuestionsBlocState.loading));

    final params = UserScoreCalculateParams(
      businessTypeId: event.workType,
      jobId: event.profession,
      presenceSourceId: event.incomeSource,
      monthlyTransactionCountTypeId: event.monthlyTransactionCount,
      averageRevenueTypeId: event.income,
    );

    final result = await _userScoreCalculateUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(
          state: ScoringQuestionsBlocState.error,
          message: l.message,
        ),
      ),
      (r) => emit(state.copyWith(state: ScoringQuestionsBlocState.success)),
    );
  }

  Future<void> _onGetConstantsData(
    GetConstantsData event,
    Emitter<ScoringQuestionsState> emit,
  ) async {
    emit(state.copyWith(state: ScoringQuestionsBlocState.loading));

    final averageRevenueTypes = await _getAverageRevenueTypesUsecase();

    averageRevenueTypes.fold(
      (l) => emit(
        state.copyWith(
          state: ScoringQuestionsBlocState.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(state: ScoringQuestionsBlocState.loading, incomeList: r),
      ),
    );

    final monthlyTransactionCountTypes =
        await _getMonthlyTransactionCountTypesUsecase();

    monthlyTransactionCountTypes.fold(
      (l) => emit(
        state.copyWith(
          state: ScoringQuestionsBlocState.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          state: ScoringQuestionsBlocState.loading,
          monthlyTransactionCountList: r,
        ),
      ),
    );

    final workTypeList = await _getScoreOperationsUsecase(
      ScoreOperationParams(
        scoreOperationTypes: ScoreOperationType.businessType.value,
      ),
    );

    workTypeList.fold(
      (l) => emit(
        state.copyWith(
          state: ScoringQuestionsBlocState.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          state: ScoringQuestionsBlocState.loading,
          workTypeList: r,
        ),
      ),
    );

    final professionList = await _getScoreOperationsUsecase(
      ScoreOperationParams(scoreOperationTypes: ScoreOperationType.job.value),
    );

    professionList.fold(
      (l) => emit(
        state.copyWith(
          state: ScoringQuestionsBlocState.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          state: ScoringQuestionsBlocState.loading,
          professionList: r,
        ),
      ),
    );

    final incomeSourceList = await _getScoreOperationsUsecase(
      ScoreOperationParams(
        scoreOperationTypes: ScoreOperationType.presenceSource.value,
      ),
    );

    incomeSourceList.fold(
      (l) => emit(
        state.copyWith(
          state: ScoringQuestionsBlocState.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          state: ScoringQuestionsBlocState.loading,
          incomeSourceList: r,
        ),
      ),
    );

    emit(state.copyWith(state: ScoringQuestionsBlocState.loaded));
  }
}
