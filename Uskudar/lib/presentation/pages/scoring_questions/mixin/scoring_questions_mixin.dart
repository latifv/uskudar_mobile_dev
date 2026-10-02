import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/scoring_questions/bloc/scoring_questions_bloc.dart';
import 'package:payinall/presentation/pages/scoring_questions/bloc/scoring_questions_event.dart';
import 'package:payinall/presentation/pages/scoring_questions/bloc/scoring_questions_state.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin ScoringQuestionsMixin<T extends StatefulWidget> on State<T> {
  final formKey = GlobalKey<FormState>();

  late final ScoringQuestionsBloc bloc;

  late final TextEditingController workTypeController;
  late final TextEditingController professionController;
  late final TextEditingController incomeController;
  late final TextEditingController monthlyTransactionCountController;

  late final FocusNode workTypeFocusNode;
  late final FocusNode professionFocusNode;
  late final FocusNode incomeFocusNode;
  late final FocusNode monthlyTransactionCountFocusNode;

  @override
  void initState() {
    super.initState();
    bloc = getIt<ScoringQuestionsBloc>();
    bloc.add(const GetConstantsData());

    workTypeController = TextEditingController();
    professionController = TextEditingController();
    incomeController = TextEditingController();
    monthlyTransactionCountController = TextEditingController();

    workTypeFocusNode = FocusNode();
    professionFocusNode = FocusNode();
    incomeFocusNode = FocusNode();
    monthlyTransactionCountFocusNode = FocusNode();
  }

  @override
  void dispose() {
    workTypeController.dispose();
    professionController.dispose();
    incomeController.dispose();
    monthlyTransactionCountController.dispose();
    workTypeFocusNode.dispose();
    professionFocusNode.dispose();
    incomeFocusNode.dispose();
    monthlyTransactionCountFocusNode.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> getWorkTypeDropdownItems() {
    if (bloc.state.workTypeList != null &&
        bloc.state.workTypeList!.isNotEmpty) {
      return bloc.state.workTypeList!
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.id.toString(),
              child: Text(e.name),
            ),
          )
          .toList();
    }
    return [];
  }

  List<DropdownMenuItem<String>> getProfessionDropdownItems() {
    if (bloc.state.professionList != null &&
        bloc.state.professionList!.isNotEmpty) {
      return bloc.state.professionList!
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.id.toString(),
              child: Text(e.name),
            ),
          )
          .toList();
    }
    return [];
  }

  List<DropdownMenuItem<String>> getIncomeDropdownItems() {
    if (bloc.state.incomeList != null && bloc.state.incomeList!.isNotEmpty) {
      return bloc.state.incomeList!
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.key.toString(),
              child: Text(e.value),
            ),
          )
          .toList();
    }
    return [];
  }

  List<DropdownMenuItem<String>> getMonthlyTransactionCountDropdownItems() {
    if (bloc.state.monthlyTransactionCountList != null &&
        bloc.state.monthlyTransactionCountList!.isNotEmpty) {
      return bloc.state.monthlyTransactionCountList!
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.key.toString(),
              child: Text(e.value),
            ),
          )
          .toList();
    }
    return [];
  }

  void onWorkTypeChanged(String? selectedId) {
    if (selectedId == null) return;

    final dropdownItems = getWorkTypeDropdownItems();
    final selectedItem = dropdownItems.firstWhere(
      (item) => item.value == selectedId,
      orElse: () => const DropdownMenuItem(value: '', child: Text('')),
    );

    workTypeController.text = (selectedItem.child as Text).data ?? '';
    bloc.add(ScoringQuestionsUpdateWorkType(workType: int.parse(selectedId)));
  }

  void onProfessionChanged(String? selectedId) {
    if (selectedId == null) return;

    final dropdownItems = getProfessionDropdownItems();
    final selectedItem = dropdownItems.firstWhere(
      (item) => item.value == selectedId,
      orElse: () => const DropdownMenuItem(value: '', child: Text('')),
    );

    professionController.text = (selectedItem.child as Text).data ?? '';
    bloc.add(
      ScoringQuestionsUpdateProfession(profession: int.parse(selectedId)),
    );
  }

  void onIncomeChanged(String? selectedId) {
    if (selectedId == null) return;

    final dropdownItems = getIncomeDropdownItems();
    final selectedItem = dropdownItems.firstWhere(
      (item) => item.value == selectedId,
      orElse: () => const DropdownMenuItem(value: '', child: Text('')),
    );

    incomeController.text = (selectedItem.child as Text).data ?? '';
    bloc.add(ScoringQuestionsUpdateIncome(income: int.parse(selectedId)));
  }

  void onMonthlyTransactionCountChanged(String? selectedId) {
    if (selectedId == null) return;

    final dropdownItems = getMonthlyTransactionCountDropdownItems();
    final selectedItem = dropdownItems.firstWhere(
      (item) => item.value == selectedId,
      orElse: () => const DropdownMenuItem(value: '', child: Text('')),
    );

    monthlyTransactionCountController.text =
        (selectedItem.child as Text).data ?? '';
    bloc.add(
      ScoringQuestionsUpdateMonthlyTransaction(
        monthlyTransactionCount: int.parse(selectedId),
      ),
    );
  }

  void onIncomeSourceChanged(String name, bool isSelected) {
    if (isSelected && bloc.state.incomeSourceList != null) {
      final sources = bloc.state.incomeSourceList!;
      for (final source in sources) {
        if (source.name == name) {
          bloc.add(ScoringQuestionsUpdateIncomeSource(incomeSource: source.id));
          break;
        }
      }
    }
  }

  bool isIncomeSourceSelected(String name) {
    final state = bloc.state;
    if (state.selectedIncomeSource == null || state.incomeSourceList == null) {
      return false;
    }

    for (final source in state.incomeSourceList!) {
      if (source.name == name && source.id == state.selectedIncomeSource) {
        return true;
      }
    }

    return false;
  }

  void onSubmitPressed() {
    if (formKey.currentState?.validate() != true) return;

    final state = bloc.state;

    if (state.selectedWorkType == null ||
        state.selectedProfession == null ||
        state.selectedIncome == null ||
        state.selectedMonthlyTransactionCount == null ||
        state.selectedIncomeSource == null) {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.fill_all_fields.translate,
      );
      return;
    }

    bloc.add(
      ScoringQuestionsSubmit(
        workType: state.selectedWorkType!,
        profession: state.selectedProfession!,
        income: state.selectedIncome!,
        monthlyTransactionCount: state.selectedMonthlyTransactionCount!,
        incomeSource: state.selectedIncomeSource!,
      ),
    );
  }

  void blocListener(BuildContext context, ScoringQuestionsState state) {
    switch (state.state) {
      case ScoringQuestionsBlocState.success:
        context.router.pop(true);
      case ScoringQuestionsBlocState.error:
        ToastComponent.showErrorToast(context: context, message: state.message);
      case ScoringQuestionsBlocState.loading:
      case ScoringQuestionsBlocState.initial:
      case ScoringQuestionsBlocState.loaded:
        break;
    }
  }
}
