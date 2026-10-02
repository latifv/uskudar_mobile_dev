import 'package:equatable/equatable.dart';
import 'package:uskudar_mobile/domain/entities/constants_data.dart';
import 'package:uskudar_mobile/domain/entities/score_operation.dart';

enum ScoringQuestionsBlocState { initial, loading, loaded, success, error }

final class ScoringQuestionsState extends Equatable {
  const ScoringQuestionsState({
    this.state = ScoringQuestionsBlocState.initial,
    this.workTypeList,
    this.professionList,
    this.incomeList,
    this.monthlyTransactionCountList,
    this.incomeSourceList,
    this.selectedWorkType,
    this.selectedProfession,
    this.selectedIncome,
    this.selectedMonthlyTransactionCount,
    this.selectedIncomeSource,
    this.message,
  });

  final ScoringQuestionsBlocState state;
  final List<ScoreOperation>? workTypeList;
  final List<ScoreOperation>? professionList;
  final List<ConstantsData>? incomeList;
  final List<ConstantsData>? monthlyTransactionCountList;
  final List<ScoreOperation>? incomeSourceList;
  final int? selectedWorkType;
  final int? selectedProfession;
  final int? selectedIncome;
  final int? selectedMonthlyTransactionCount;
  final int? selectedIncomeSource;
  final String? message;

  ScoringQuestionsState copyWith({
    ScoringQuestionsBlocState? state,
    List<ScoreOperation>? workTypeList,
    List<ScoreOperation>? professionList,
    List<ConstantsData>? incomeList,
    List<ConstantsData>? monthlyTransactionCountList,
    List<ScoreOperation>? incomeSourceList,
    int? selectedWorkType,
    int? selectedProfession,
    int? selectedIncome,
    int? selectedMonthlyTransactionCount,
    int? selectedIncomeSource,
    String? message,
  }) {
    return ScoringQuestionsState(
      state: state ?? this.state,
      workTypeList: workTypeList ?? this.workTypeList,
      professionList: professionList ?? this.professionList,
      incomeList: incomeList ?? this.incomeList,
      monthlyTransactionCountList:
          monthlyTransactionCountList ?? this.monthlyTransactionCountList,
      incomeSourceList: incomeSourceList ?? this.incomeSourceList,
      selectedWorkType: selectedWorkType ?? this.selectedWorkType,
      selectedProfession: selectedProfession ?? this.selectedProfession,
      selectedIncome: selectedIncome ?? this.selectedIncome,
      selectedMonthlyTransactionCount:
          selectedMonthlyTransactionCount ??
          this.selectedMonthlyTransactionCount,
      selectedIncomeSource: selectedIncomeSource ?? this.selectedIncomeSource,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    state,
    workTypeList,
    professionList,
    incomeList,
    monthlyTransactionCountList,
    incomeSourceList,
    selectedWorkType,
    selectedProfession,
    selectedIncome,
    selectedMonthlyTransactionCount,
    selectedIncomeSource,
    message,
  ];
}
