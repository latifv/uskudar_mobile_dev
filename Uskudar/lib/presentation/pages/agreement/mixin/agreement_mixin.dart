import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/enums/agreement_type.dart';
import 'package:uskudar_mobile/presentation/pages/agreement/bloc/agreement_bloc.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dialog.dart';

mixin AgreementMixin<T extends StatefulWidget> on State<T> {
  late final AgreementBloc bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void onAgreementAccept() {
    context.router.pop(true);
  }

  void onAgreementDecline() {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.contract_confirm.translate,
        description: LocaleKeys.cancel_process_home_page.translate,
        icon: Icons.exit_to_app,
        primaryButtonText: LocaleKeys.go_main_page.translate,
        onPrimaryButtonPressed: () {
          context.router.pop(false);
        },
        color: context.colorScheme.error,
      ),
    );
  }

  Future<void> onGetAgreement(AgreementType agreementType) async {
    bloc.add(GetAgreement(agreementType: agreementType));
  }
}
