import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/request_money.dart';
import 'package:payinall/domain/enums/transfer_method.dart';
import 'package:payinall/presentation/pages/pending_money_requests/bloc/pending_money_requests_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_dialog.dart';

mixin PendingMoneyRequestsMixin<T extends StatefulWidget> on State<T> {
  late final PendingMoneyRequestsBloc bloc;
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    bloc = getIt<PendingMoneyRequestsBloc>();
    tabController = TabController(length: 2, vsync: this as TickerProvider);
    tabController.addListener(_handleTabIndexChange);
    loadRequests();
  }

  @override
  void dispose() {
    tabController
      ..removeListener(_handleTabIndexChange)
      ..dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void loadRequests({int? tabIndex}) {
    bloc.add(PendingMoneyRequestsLoadData(tabIndex: tabIndex));
  }

  void onApproveRequest(RequestMoney request) {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.approve_request.translate,
        description: LocaleKeys.approve_request_description.translate,
        icon: Icons.check_circle_outline,
        color: Colors.green,
        textColor: context.colorScheme.surface,
        primaryButtonText: LocaleKeys.approve.translate,
        onPrimaryButtonPressed: () {
          context.router.pop();
          bloc.add(
            PendingMoneyRequestsApprove(
              requestId: request.id,
              request: request,
            ),
          );
        },
      ),
    );
  }

  void onRejectRequest(RequestMoney request) {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.reject_request.translate,
        description: LocaleKeys.reject_request_confirmation.translate,
        icon: Icons.cancel_outlined,
        color: Colors.orange,
        textColor: context.colorScheme.surface,
        primaryButtonText: LocaleKeys.yes_reject.translate,
        onPrimaryButtonPressed: () {
          bloc.add(
            PendingMoneyRequestsReject(
              requestId: request.id,
              request: request,
            ),
          );
        },
      ),
    );
  }

  void onDeleteRequest(RequestMoney request) {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.delete_request.translate,
        description: LocaleKeys.delete_request_confirmation.translate,
        icon: Icons.delete_outline,
        color: Colors.red,
        textColor: context.colorScheme.surface,
        primaryButtonText: LocaleKeys.yes_delete.translate,
        onPrimaryButtonPressed: () {
          bloc.add(
            PendingMoneyRequestsDelete(
              requestId: request.id,
              request: request,
            ),
          );
        },
      ),
    );
  }

  void _handleTabIndexChange() {
    if (!tabController.indexIsChanging) return;
    bloc.add(PendingMoneyRequestsTabChanged(tabIndex: tabController.index));
  }

  void blocListener(BuildContext context, PendingMoneyRequestsState state) {
    if (state is PendingMoneyRequestsActionSuccess) {
      if (!state.navigateToTransfer) {
        ToastComponent.showSuccessToast(
          context: context,
          message: state.message,
        );

        loadRequests();
      }

      if (state.navigateToTransfer && state.walletTransfer != null) {
        unawaited(
          context.router.push(
            TransferConfirmationRoute(
              transferMethod: TransferMethod.wallet,
              walletTransfer: state.walletTransfer,
            ),
          ),
        );
      }
    } else if (state is PendingMoneyRequestsError) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }
}
