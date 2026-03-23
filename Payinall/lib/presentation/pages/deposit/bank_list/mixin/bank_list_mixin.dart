import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/app_bank.dart';
import 'package:payinall/presentation/pages/deposit/bank_list/bloc/bank_list_bloc.dart';
import 'package:payinall/presentation/pages/deposit/bank_list/bloc/bank_list_event.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';

mixin BankListMixin<T extends StatefulWidget> on State<T> {
  late final BankListBloc bloc;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    bloc = getIt<BankListBloc>();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    scrollController.dispose();
    super.dispose();
  }

  void onBackPressed() {
    context.router.pop();
  }

  void onBankSelected(AppBank bank) {
    bloc.add(BankSelected(bankId: bank.id));
    unawaited(context.router.push(BankDetailRoute(bank: bank)));
  }

  void onError(String message) {
    ToastComponent.showErrorToast(context: context, message: message);
  }
}
