import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/customer_demand_subject.dart';
import 'package:payinall/presentation/pages/customer_demand/bloc/customer_demand_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin CustomerDemandMixin<T extends StatefulWidget> on State<T> {
  late final CustomerDemandBloc bloc;
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final FocusNode titleFocusNode;
  late final FocusNode contentFocusNode;
  late final FocusNode submitFocusNode;
  late final GlobalKey<FormState> formKey;
  CustomerDemandSubject? selectedSubject;

  @override
  void initState() {
    super.initState();
    bloc = getIt<CustomerDemandBloc>();
    titleController = TextEditingController();
    contentController = TextEditingController();
    titleFocusNode = FocusNode();
    contentFocusNode = FocusNode();
    submitFocusNode = FocusNode();
    formKey = GlobalKey<FormState>();
    bloc.add(const CustomerDemandLoadSubjects());
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    titleFocusNode.dispose();
    contentFocusNode.dispose();
    submitFocusNode.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(BuildContext context, CustomerDemandState state) {
    if (state.status == CustomerDemandStatus.success) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message,
      );
      context.router.maybePop();
    } else if (state.status == CustomerDemandStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message,
      );
    }
  }

  void onSubjectChanged(CustomerDemandSubject? subject) {
    setState(() {
      selectedSubject = subject;
    });
  }

  void onSubmitPressed() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) return;
    if (selectedSubject == null) {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.customer_demand_select_subject.translate,
      );
      return;
    }

    bloc.add(
      CustomerDemandSubmit(
        requestSubjectId: selectedSubject!.key,
        title: titleController.text,
        content: contentController.text,
      ),
    );
  }
}
