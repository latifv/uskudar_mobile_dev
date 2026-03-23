import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/campaign_merchant.dart';
import 'package:payinall/presentation/pages/campaigns/bloc/campaigns_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';

mixin CampaignsMixin<T extends StatefulWidget> on State<T> {
  late final CampaignsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<CampaignsBloc>();
    loadCampaigns();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadCampaigns() {
    bloc.add(const CampaignsLoadData());
  }

  void refreshCampaigns() {
    bloc.add(const CampaignsRefreshData());
  }

  void navigateToCampaignDetail(CampaignMerchant campaignMerchant) {
    unawaited(
      context.router.push(
        MerchantDetailRoute(campaignMerchant: campaignMerchant),
      ),
    );
  }
}
