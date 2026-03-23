import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/iwallet_agreements/bloc/iwallet_agreements_bloc.dart';
import 'package:payinall/presentation/shared/components/snackbar_component.dart';

mixin IWalletAgreementsMixin<T extends StatefulWidget> on State<T> {
  late final IWalletAgreementsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<IWalletAgreementsBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(const GetIWalletAgreements());
    });
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(_, IWalletAgreementsState state) {
    switch (state.status) {
      case IWalletAgreementsStatus.initial:
      case IWalletAgreementsStatus.loading:
      case IWalletAgreementsStatus.loaded:
        break;
      case IWalletAgreementsStatus.error:
        SnackBarComponent.showErrorSnackBar(
          context: context,
          message: state.message,
        );
    }
  }

  void onAgreementAccept() {
    bloc.add(const AcceptCurrentAgreement());

    if (bloc.state.allAgreementsAccepted) {
      context.router.pop(true);
    }
  }
}
