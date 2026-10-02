import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/secret_question/bloc/secret_question_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/secret_question/mixin/secret_question_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dropdown_button_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class SecretQuestionScreen extends StatefulWidget {
  const SecretQuestionScreen({super.key});

  @override
  State<SecretQuestionScreen> createState() => _SecretQuestionScreenState();
}

final class _SecretQuestionScreenState extends State<SecretQuestionScreen>
    with SecretQuestionMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(LocaleKeys.update_secret_question.translate),
        ),
        body: SafeArea(
          child: BlocConsumer<SecretQuestionBloc, SecretQuestionState>(
            listener: blocListener,
            builder: (_, state) {
              return _buildBody(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(SecretQuestionState state) {
    if (state.status == SecretQuestionStatus.loading) {
      return const Center(child: CustomLoading());
    }

    if (state.status == SecretQuestionStatus.error &&
        state.userQuestions.isEmpty) {
      return ErrorTryAgain(
        message: state.message ?? LocaleKeys.unknown_error.translate,
        onTryAgain: loadQuestions,
      );
    }

    return _buildContent(state);
  }

  Widget _buildContent(SecretQuestionState state) {
    return Form(
      key: formKey,
      child: ListView(
        padding: context.paddingNormalAll,
        children: [
          context.spacingNormalHeight,
          Text(
            LocaleKeys.security_question.translate,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          context.spacingLowHeight,
          CustomDropdownButtonFormField<int>(
            items: state.userQuestions
                .map(
                  (q) => DropdownMenuItem<int>(
                    value: q.id,
                    child: Text(
                      q.name,
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                )
                .toList(),
            onChanged: onQuestionChanged,
            hintText: LocaleKeys.please_select.translate,
            validator: (value) {
              if (value == null) {
                return LocaleKeys.required_field.translate;
              }
              return null;
            },
          ),
          context.spacingNormalHeight,
          Text(
            LocaleKeys.security_question_answer.translate,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          context.spacingLowHeight,
          CustomTextFormField(
            controller: answerController,
            focusNode: answerFocusNode,
            hintText: LocaleKeys.security_question_answer.translate,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.required_field.translate;
              }
              return null;
            },
          ),
          context.spacingNormalHeight,
          context.spacingNormalHeight,
          PrimaryElevatedButton(
            text: LocaleKeys.save.translate,
            onPressed: onSubmitPressed,
          ),
        ],
      ),
    );
  }
}
