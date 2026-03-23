import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/enums/agreement_type.dart';
import 'package:payinall/presentation/pages/agreement/bloc/agreement_bloc.dart';
import 'package:payinall/presentation/pages/agreement/mixin/agreement_mixin.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class AgreementScreen extends StatefulWidget {
  const AgreementScreen({
    required this.agreementType,
    required this.isRead,
    super.key,
  });

  final String agreementType;
  final bool isRead;
  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

final class _AgreementScreenState extends State<AgreementScreen>
    with AgreementMixin {
  @override
  void initState() {
    super.initState();
    bloc = getIt<AgreementBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(onGetAgreement(widget.agreementType.toAgreementType()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: CustomAppBar(title: Text(LocaleKeys.agreement.translate)),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: context.paddingMediumHorizontal,
            child: BlocBuilder<AgreementBloc, AgreementState>(
              builder: (context, state) {
                switch (state.status) {
                  case AgreementBlocStatus.initial:
                  case AgreementBlocStatus.loading:
                    return const Center(child: CustomLoading());
                  case AgreementBlocStatus.loaded:
                    return _buildBody(state.htmlText ?? '');
                  case AgreementBlocStatus.error:
                    return ErrorTryAgain(
                      message:
                          state.message ?? LocaleKeys.unknown_error.translate,
                      onTryAgain: () => onGetAgreement(
                        widget.agreementType.toAgreementType(),
                      ),
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(String htmlText) {
    return Column(
      children: [
        context.spacingLowHeight,
        Html(data: htmlText),
        context.spacingLowHeight,
        if (!widget.isRead) _buildButton(),
        context.spacingMediumHeight,
      ],
    );
  }

  Widget _buildButton() {
    final agreementType = widget.agreementType.toAgreementType();
    final shouldShowDecline = _shouldShowDeclineButton(agreementType);

    if (shouldShowDecline) {
      return Column(
        children: [
          PrimaryElevatedButton(
            onPressed: onAgreementAccept,
            text: LocaleKeys.accept.translate,
          ),
          context.spacingLowHeight,
          PrimaryElevatedButton(
            onPressed: onAgreementDecline,
            text: LocaleKeys.decline.translate,
            color: Colors.red,
          ),
        ],
      );
    } else {
      return PrimaryElevatedButton(
        onPressed: onAgreementAccept,
        text: LocaleKeys.accept.translate,
      );
    }
  }

  bool _shouldShowDeclineButton(AgreementType agreementType) {
    switch (agreementType) {
      case AgreementType.biyometrikVeriRizasi:
        return true;
      case AgreementType.hakemHeyeti:
      case AgreementType.guvenlikSozlesmesi:
      case AgreementType.bilgilendirmeMetni:
      case AgreementType.adresBilgisiSozlesmesi:
      case AgreementType.kullaniciCerceveSozlesmesi:
      case AgreementType.musteriEdinimiUzaktanKimlikTespitiAydinlatmaMetni:
      case AgreementType.odemeHizmetiKullanicilariAydinlatmaMetni:
        return false;
    }
  }
}
