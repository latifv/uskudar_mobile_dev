import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/scoring_questions/bloc/scoring_questions_bloc.dart';
import 'package:payinall/presentation/pages/scoring_questions/bloc/scoring_questions_state.dart';
import 'package:payinall/presentation/pages/scoring_questions/mixin/scoring_questions_mixin.dart';
import 'package:payinall/presentation/pages/scoring_questions/widgets/custom_dropdown.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_text_button.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class ScoringQuestionsScreen extends StatefulWidget {
  const ScoringQuestionsScreen({super.key});

  @override
  State<ScoringQuestionsScreen> createState() => _ScoringQuestionsScreenState();
}

final class _ScoringQuestionsScreenState extends State<ScoringQuestionsScreen>
    with ScoringQuestionsMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocListener<ScoringQuestionsBloc, ScoringQuestionsState>(
        listener: blocListener,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: context.paddingBase,
              child: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ScoringQuestionsBloc, ScoringQuestionsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                context.router.pop();
              },
              text: LocaleKeys.skip.translate,
              textStyle: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            _buildHeader(),
            context.spacingNormalHeight,
            _buildForm(),
            context.spacingMediumHeight,
            _buildSubmitButton(),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.user_info_form.translate,
          style: context.textTheme.titleMedium,
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.user_info_form_description.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          BlocBuilder<ScoringQuestionsBloc, ScoringQuestionsState>(
            builder: (context, state) {
              return CustomDropdown(
                hintText: LocaleKeys.work_type.translate,
                controller: workTypeController,
                items: getWorkTypeDropdownItems(),
                onChanged: onWorkTypeChanged,
                focusNode: workTypeFocusNode,
                nextFocusNode: professionFocusNode,
              );
            },
          ),
          context.spacingNormalHeight,
          BlocBuilder<ScoringQuestionsBloc, ScoringQuestionsState>(
            builder: (context, state) {
              return CustomDropdown(
                hintText: LocaleKeys.profession.translate,
                controller: professionController,
                items: getProfessionDropdownItems(),
                onChanged: onProfessionChanged,
                focusNode: professionFocusNode,
                nextFocusNode: incomeFocusNode,
                enableSearch: true,
              );
            },
          ),
          context.spacingNormalHeight,
          BlocBuilder<ScoringQuestionsBloc, ScoringQuestionsState>(
            builder: (context, _) {
              return CustomDropdown(
                hintText: LocaleKeys.income.translate,
                controller: incomeController,
                items: getIncomeDropdownItems(),
                onChanged: onIncomeChanged,
                focusNode: incomeFocusNode,
                nextFocusNode: monthlyTransactionCountFocusNode,
              );
            },
          ),
          context.spacingNormalHeight,
          BlocBuilder<ScoringQuestionsBloc, ScoringQuestionsState>(
            builder: (context, _) {
              return CustomDropdown(
                hintText: LocaleKeys.monthly_transactions.translate,
                controller: monthlyTransactionCountController,
                items: getMonthlyTransactionCountDropdownItems(),
                onChanged: onMonthlyTransactionCountChanged,
                focusNode: monthlyTransactionCountFocusNode,
              );
            },
          ),
          context.spacingNormalHeight,
          _buildIncomeSourceSection(),
        ],
      ),
    );
  }

  Widget _buildIncomeSourceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.income_sources.translate,
          style: context.textTheme.bodyLarge,
        ),
        context.spacingNormalHeight,
        BlocBuilder<ScoringQuestionsBloc, ScoringQuestionsState>(
          builder: (context, state) {
            if (state.incomeSourceList == null ||
                state.incomeSourceList!.isEmpty) {
              return const CircularProgressIndicator();
            }
            final incomeSourceNames = state.incomeSourceList!
                .map((e) => e.name)
                .toList();
            final firstColumn = incomeSourceNames
                .take((incomeSourceNames.length / 2).ceil())
                .toList();
            final secondColumn = incomeSourceNames
                .skip((incomeSourceNames.length / 2).ceil())
                .toList();

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: context.dynamicWidth(0.42),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final source in firstColumn) ...[
                            _buildRadioItem(source),
                            if (source != firstColumn.last)
                              context.spacingLowHeight,
                          ],
                        ],
                      ),
                    ),
                    context.spacingLowWidth,
                    SizedBox(
                      width: context.dynamicWidth(0.42),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final source in secondColumn) ...[
                            _buildRadioItem(source),
                            if (source != secondColumn.last)
                              context.spacingLowHeight,
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRadioItem(String source) {
    return BlocBuilder<ScoringQuestionsBloc, ScoringQuestionsState>(
      builder: (context, state) {
        final isSelected = isIncomeSourceSelected(source);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: source,
              groupValue: isSelected ? source : null,
              onChanged: (value) {
                if (value != null) {
                  onIncomeSourceChanged(value, true);
                }
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            context.spacingLowWidth,
            Expanded(
              child: GestureDetector(
                onTap: () => onIncomeSourceChanged(source, true),
                child: Text(
                  source,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ScoringQuestionsBloc, ScoringQuestionsState>(
      builder: (_, _) {
        return PrimaryElevatedButton(
          onPressed: onSubmitPressed,
          text: LocaleKeys.continue_button.translate,
        );
      },
    );
  }
}
