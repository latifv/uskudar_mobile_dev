import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/secret_question/bloc/secret_question_bloc.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

mixin SecretQuestionMixin<T extends StatefulWidget> on State<T> {
  late final SecretQuestionBloc bloc;
  late final TextEditingController answerController;
  late final FocusNode answerFocusNode;
  late final GlobalKey<FormState> formKey;
  int? selectedQuestionId;

  @override
  void initState() {
    super.initState();
    bloc = getIt<SecretQuestionBloc>();
    answerController = TextEditingController();
    answerFocusNode = FocusNode();
    formKey = GlobalKey<FormState>();
    loadQuestions();
  }

  @override
  void dispose() {
    answerController.dispose();
    answerFocusNode.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void loadQuestions() {
    bloc.add(const SecretQuestionLoadQuestions());
  }

  void onQuestionChanged(int? questionId) {
    selectedQuestionId = questionId;
  }

  void onSubmitPressed() {
    if (formKey.currentState?.validate() ?? false) {
      if (selectedQuestionId == null) {
        ToastComponent.showErrorToast(
          context: context,
          message: LocaleKeys.security_question.translate,
        );
        return;
      }
      bloc.add(
        SecretQuestionSubmit(
          userQuestionId: selectedQuestionId!,
          secretQuestion: answerController.text.trim(),
        ),
      );
    }
  }

  void blocListener(BuildContext context, SecretQuestionState state) {
    if (state.status == SecretQuestionStatus.success) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message,
      );
      unawaited(context.router.maybePop());
    } else if (state.status == SecretQuestionStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message,
      );
    }
  }
}
