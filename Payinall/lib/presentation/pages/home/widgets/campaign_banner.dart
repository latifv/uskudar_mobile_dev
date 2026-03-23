import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/campaign_merchant.dart';
import 'package:payinall/presentation/pages/campaigns/bloc/campaigns_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class CampaignBanner extends StatefulWidget {
  const CampaignBanner({super.key});

  @override
  State<CampaignBanner> createState() => _CampaignBannerState();
}

final class _CampaignBannerState extends State<CampaignBanner> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  late final CampaignsBloc _campaignsBloc;
  late final UserInfoManager _userInfoManager;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
    );
    _userInfoManager = getIt<UserInfoManager>();
    _campaignsBloc = getIt<CampaignsBloc>();
    if (!_userInfoManager.isMerchant) {
      _campaignsBloc.add(const CampaignsLoadData());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    unawaited(_campaignsBloc.close());
    super.dispose();
  }

  void _startAutoSlide(int length) {
    _timer?.cancel();
    if (length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (mounted && _pageController.hasClients) {
          final nextPage = (_currentPage + 1) % length;
          unawaited(
            _pageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            ),
          );
        }
      });
    }
  }

  void _navigateToCampaigns() {
    unawaited(context.router.push(const CampaignsRoute()));
  }

  void _navigateToCampaignDetail(CampaignMerchant campaignMerchant) {
    unawaited(
      context.router.push(
        MerchantDetailRoute(campaignMerchant: campaignMerchant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CampaignsBloc, CampaignsState>(
      bloc: _campaignsBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.spacingLowHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.campaigns.translate,
                  style: context.textTheme.titleSmall?.copyWith(),
                ),
                if (state.status == CampaignsStatus.loaded &&
                    (state.campaigns?.isNotEmpty ?? false))
                  TextButton(
                    onPressed: _navigateToCampaigns,
                    child: Text(
                      LocaleKeys.view_all.translate,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            context.spacingLowHeight,
            _buildCampaignContent(state),
          ],
        );
      },
    );
  }

  Widget _buildCampaignContent(CampaignsState state) {
    switch (state.status) {
      case CampaignsStatus.initial:
      case CampaignsStatus.loading:
        return _buildLoadingState();
      case CampaignsStatus.error:
        return _buildErrorState();
      case CampaignsStatus.loaded:
        final campaigns = state.campaigns ?? [];
        if (campaigns.isEmpty) {
          return _buildEmptyState(context);
        }

        final allMerchants = campaigns
            .expand((campaign) => campaign.campaignMerchants)
            .toList();

        if (allMerchants.isEmpty) {
          return _buildEmptyState(context);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startAutoSlide(allMerchants.length);
        });

        return Column(
          children: [
            SizedBox(
              height: context.dynamicHeight(0.3),
              child: PageView.builder(
                controller: _pageController,
                padEnds: false,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: allMerchants.length,
                itemBuilder: (context, index) {
                  return _buildCampaignCard(
                    context,
                    allMerchants[index],
                    index,
                    allMerchants.length,
                  );
                },
              ),
            ),
            context.spacingLowHeight,
            _buildPageIndicator(allMerchants.length),
          ],
        );
    }
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: context.dynamicHeight(0.3),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState() {
    return SizedBox(
      height: context.dynamicHeight(0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: IconSizeConstants.xl,
              color: Colors.grey,
            ),
            context.spacingLowHeight,
            Text(
              LocaleKeys.general_error.translate,
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignCard(
    BuildContext context,
    CampaignMerchant campaignMerchant,
    int index,
    int totalLength,
  ) {
    final margin = EdgeInsets.only(
      left: index == 0 ? 0 : 8,
      right: index == totalLength - 1 ? 24 : 8,
    );

    return GestureDetector(
      onTap: () => _navigateToCampaignDetail(campaignMerchant),
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: context.borderRadiusNormalAll,
          border: Border.all(
            color: Colors.grey.shade400,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: context.paddingLowAll + context.paddingLowHorizontal,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: context.borderRadiusNormalAll,
                  child: ImageNetworkComponent(
                    imageUrl: campaignMerchant.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: context.paddingBaseLow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      campaignMerchant.merchant.name,
                      style: context.textTheme.titleSmall?.copyWith(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    context.spacingLowHeight,
                    Text(
                      _getSubtitle(campaignMerchant.content),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSubtitle(String content) {
    if (content.length <= 80) {
      return content;
    }
    return '${content.substring(0, 80)}...';
  }

  Widget _buildPageIndicator(int length) {
    if (length > 5) {
      return _buildCompactIndicator(length);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? context.colorScheme.primary
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            '${_currentPage + 1} / $length',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (_currentPage + 1) / length,
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.campaign_outlined,
              size: IconSizeConstants.xl,
              color: Colors.grey,
            ),
            context.spacingNormalHeight,
            Text(
              LocaleKeys.no_active_campaigns.translate,
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
