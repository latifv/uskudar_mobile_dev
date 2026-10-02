import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/iwallet_agreements/bloc/iwallet_agreements_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/iwallet_agreements/mixin/iwallet_agreements_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class IWalletAgreementsScreen extends StatefulWidget {
  const IWalletAgreementsScreen({super.key});

  @override
  State<IWalletAgreementsScreen> createState() =>
      _IWalletAgreementsScreenState();
}

final class _IWalletAgreementsScreenState extends State<IWalletAgreementsScreen>
    with IWalletAgreementsMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(LocaleKeys.agreement.translate),
        ),
        body: SafeArea(
          bottom: false,
          child: BlocConsumer<IWalletAgreementsBloc, IWalletAgreementsState>(
            bloc: bloc,
            listener: blocListener,
            builder: (_, state) {
              switch (state.status) {
                case IWalletAgreementsStatus.initial:
                case IWalletAgreementsStatus.loading:
                  return const Center(child: CustomLoading());
                case IWalletAgreementsStatus.loaded:
                  return _buildBody(state);
                case IWalletAgreementsStatus.error:
                  return ErrorTryAgain(
                    message:
                        state.message ?? LocaleKeys.unknown_error.translate,
                    onTryAgain: () => bloc.add(const GetIWalletAgreements()),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(IWalletAgreementsState state) {
    if (state.agreements.isEmpty) {
      return Center(
        child: Text(LocaleKeys.no_data.translate),
      );
    }

    final currentAgreement = state.currentAgreement;
    if (currentAgreement == null) {
      return Center(
        child: Text(LocaleKeys.no_data.translate),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: context.paddingMediumHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                context.spacingNormalHeight,
                _buildAgreementTitle(currentAgreement.name),
                context.spacingNormalHeight,
                _buildHtmlContent(
                  currentAgreement.shortName,
                  state,
                ),
              ],
            ),
          ),
        ),
        _buildAcceptButton(state),
        context.spacingNormalHeight,
      ],
    );
  }

  Widget _buildAgreementTitle(String title) {
    return Text(
      title,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHtmlContent(
    String shortName,
    IWalletAgreementsState state,
  ) {
    final isLoading = state.loadingHtml[shortName] ?? false;
    final htmlContent = state.htmlContents[shortName];

    if (isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: const Center(child: CustomLoading()),
      );
    }

    if (htmlContent == null || htmlContent.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Html(data: htmlContent),
      ),
    );
  }

  Widget _buildAcceptButton(IWalletAgreementsState state) {
    return Padding(
      padding: context.paddingNormalHorizontal,
      child: PrimaryElevatedButton(
        onPressed: onAgreementAccept,
        text: LocaleKeys.accept.translate,
      ),
    );
  }
}
