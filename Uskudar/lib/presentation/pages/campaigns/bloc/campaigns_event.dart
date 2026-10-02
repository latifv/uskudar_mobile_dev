part of 'campaigns_bloc.dart';

sealed class CampaignsEvent {
  const CampaignsEvent();
}

final class CampaignsLoadData extends CampaignsEvent {
  const CampaignsLoadData();
}

final class CampaignsRefreshData extends CampaignsEvent {
  const CampaignsRefreshData();
}
