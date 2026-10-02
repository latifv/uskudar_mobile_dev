import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/home/bloc/home_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/home/mixin/home_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/home/widgets/campaign_banner.dart';
import 'package:uskudar_mobile/presentation/pages/home/widgets/home_advantage_sections.dart';
import 'package:uskudar_mobile/presentation/pages/home/widgets/home_app_bar.dart';
import 'package:uskudar_mobile/presentation/pages/home/widgets/home_balance_section.dart';
import 'package:uskudar_mobile/presentation/pages/home/widgets/home_discount_points_preview.dart';
import 'package:uskudar_mobile/presentation/pages/home/widgets/home_paycore_cards_carousel.dart';
import 'package:uskudar_mobile/presentation/pages/home/widgets/home_tab_section.dart';
import 'package:uskudar_mobile/presentation/pages/home/widgets/user_info_card.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/app_drawer.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';

@RoutePage()
final class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends State<HomeScreen> with HomeMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        drawer: const AppDrawer(),
        body: SafeArea(
          child: BlocConsumer<HomeBloc, HomeState>(
            listener: blocListener,
            builder: (_, state) {
              if (state.status == HomeStatus.loading) {
                return const Center(child: CustomLoading());
              }
              if (state.status == HomeStatus.error) {
                return _buildErrorBody();
              }
              return RefreshIndicator(
                color: context.colorScheme.primary,
                onRefresh: onHomeRefreshData,
                child: SingleChildScrollView(
                  padding: context.paddingBase,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _buildBody(state),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeAppBar(
          firstName: state.firstName?.split(' ').first ?? '',
          onNotificationPressed: navigateToNotification,
          onSearchPressed: navigateToPageSearch,
          onAvatarPressed: userInfoManager.isMerchant
              ? navigateToPaycoreCards
              : navigateToProfile,
          avatarImage: state.image,
        ),
        context.spacingLowHeight,
        if (state.customerType == 1 &&
            !state.dismissedCards.contains(UserInfoCardType.scoreQuestion)) ...[
          _buildScoreQuestionInfo(),
          context.spacingLowHeight,
        ] else if (state.customerType == 2 &&
            state.addressType == 1 &&
            !state.dismissedCards.contains(UserInfoCardType.arkSigner)) ...[
          _buildInfoArkSigner(),
          context.spacingLowHeight,
        ] else if (state.customerType == 2 &&
            state.addressType == 2 &&
            !state.dismissedCards.contains(
              UserInfoCardType.addressVerification,
            )) ...[
          _buildInfoAddress(),
          context.spacingLowHeight,
        ] else if (state.customerType == 2 &&
            state.addressType == 4 &&
            !state.dismissedCards.contains(
              UserInfoCardType.addressRejected,
            )) ...[
          _buildRejectInfoAddress(),
          context.spacingLowHeight,
        ],
        HomeBalanceSection(
          balance: state.balance ?? 0,
          blockBalance: state.blockBalance ?? 0,
          walletAddress: state.walletAddress ?? '',
          onCopyUserNumberPressed: () =>
              copyUserNumberToClipboard(state.walletAddress ?? ''),
          onLoadMoneyPressed: navigateToLoadMoney,
          isMerchant: userInfoManager.isMerchant,
        ),
        if (!userInfoManager.isMerchant) ...[
          context.spacingLowHeight,
          HomePaycoreCardsCarousel(
            onPressed: navigateToPaycoreCards,
            onSendPressed: navigateToSendMoney,
            onRequestPressed: navigateToRequestMoney,
            onWithdrawPressed: navigateToWithdrawMoney,
            refreshSeed:
                '${state.walletAddress ?? ''}_${state.balance ?? 0}_${state.blockBalance ?? 0}_${state.transactions?.length ?? 0}',
          ),
        ] else ...[
          context.spacingLowHeight,
          HomePaycoreCardsCarousel(
            onPressed: navigateToPaycoreCards,
            onSendPressed: navigateToSendMoney,
            onRequestPressed: navigateToRequestMoney,
            onWithdrawPressed: navigateToWithdrawMoney,
            refreshSeed:
                '${state.walletAddress ?? ''}_${state.balance ?? 0}_${state.blockBalance ?? 0}_${state.transactions?.length ?? 0}',
          ),
        ],
        if (!userInfoManager.isMerchant) ...[
          context.spacingLowHeight,
          const HomeBrandsSection(),
          context.spacingNormalHeight,
          const CampaignBanner(),
          context.spacingNormalHeight,
          const HomeFuelDiscountsSection(),
          context.spacingNormalHeight,
          const HomeDiscountPointsPreview(),
        ],
        context.spacingLowHeight,
        HomeTabSection(
          transactions: state.transactions ?? [],
          frequentIbans: state.frequentIbans,
          frequentlySents: state.frequentlySents,
        ),
        context.spacingLowHeight,
      ],
    );
  }

  Widget _buildInfoArkSigner() {
    return UserInfoCard(
      title: LocaleKeys.user_info_form_verification_title.translate,
      description: LocaleKeys.user_verification_required_description.translate,
      primaryButtonText: LocaleKeys.verify_now.translate,
      onPrimaryButtonPressed: navigateToFrontIdScan,
      onSecondaryButtonPressed: dismissArkSignerCard,
    );
  }

  Widget _buildInfoAddress() {
    return UserInfoCard(
      title: LocaleKeys.user_info_form_address_title.translate,
      description:
          LocaleKeys.address_verification_pending_description.translate,
      primaryButtonText: LocaleKeys.ok.translate,
      onPrimaryButtonPressed: dismissAddressVerificationCard,
      showSecondaryButton: false,
    );
  }

  Widget _buildRejectInfoAddress() {
    return UserInfoCard(
      title: LocaleKeys.user_info_form_address_update_title.translate,
      description:
          LocaleKeys.address_verification_rejected_description.translate,
      primaryButtonText: LocaleKeys.update_now.translate,
      onPrimaryButtonPressed: navigateToAddressPreview,
      onSecondaryButtonPressed: dismissAddressRejectedCard,
    );
  }

  Widget _buildScoreQuestionInfo() {
    return UserInfoCard(
      title: LocaleKeys.user_info_form_title.translate,
      description: LocaleKeys.scoring_questions_required_description.translate,
      primaryButtonText: LocaleKeys.complete_now.translate,
      onPrimaryButtonPressed: navigateToScoreQuestion,
      onSecondaryButtonPressed: dismissScoreQuestionCard,
    );
  }

  Widget _buildErrorBody() {
    return ErrorTryAgain(
      message: LocaleKeys.unknown_error.translate,
      onTryAgain: onHomeLoadData,
    );
  }
}
