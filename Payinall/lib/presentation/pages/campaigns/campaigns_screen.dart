import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/campaigns/bloc/campaigns_bloc.dart';
import 'package:payinall/presentation/pages/campaigns/mixin/campaigns_mixin.dart';
import 'package:payinall/presentation/pages/campaigns/widgets/campaign_list_item.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';

@RoutePage()
final class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

final class _CampaignsScreenState extends State<CampaignsScreen>
    with CampaignsMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.campaigns.translate),
      ),
      body: BlocBuilder<CampaignsBloc, CampaignsState>(
        bloc: bloc,
        builder: (context, state) {
          return switch (state.status) {
            CampaignsStatus.initial || CampaignsStatus.loading => const Center(
              child: CustomLoading(),
            ),
            CampaignsStatus.error => _buildErrorWidget(state),
            CampaignsStatus.loaded => _buildCampaignsList(state),
          };
        },
      ),
    );
  }

  Widget _buildErrorWidget(CampaignsState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: IconSizeConstants.xl,
            color: Colors.grey,
          ),
          context.spacingNormalHeight,
          Text(
            state.message ?? LocaleKeys.general_error.translate,
            style: context.textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          context.spacingNormalHeight,
          ElevatedButton(
            onPressed: loadCampaigns,
            child: Text(LocaleKeys.try_again.translate),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignsList(CampaignsState state) {
    if (state.campaigns?.isEmpty ?? true) {
      return _buildEmptyState();
    }

    final allMerchants = state.campaigns!
        .expand((campaign) => campaign.campaignMerchants)
        .toList();

    if (allMerchants.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => refreshCampaigns(),
      child: ListView.separated(
        padding: context.paddingLowAll,
        itemCount: allMerchants.length,
        separatorBuilder: (context, index) => context.spacingLowHeight,
        itemBuilder: (context, index) {
          final campaignMerchant = allMerchants[index];
          return CampaignListItem(
            campaignMerchant: campaignMerchant,
            onTap: () => navigateToCampaignDetail(campaignMerchant),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
    );
  }
}
