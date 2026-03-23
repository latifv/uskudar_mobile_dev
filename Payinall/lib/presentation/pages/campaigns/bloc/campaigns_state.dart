part of 'campaigns_bloc.dart';

enum CampaignsStatus { initial, loading, loaded, error }

final class CampaignsState extends Equatable {
  const CampaignsState({
    this.status = CampaignsStatus.initial,
    this.campaigns,
    this.message,
  });

  final CampaignsStatus status;
  final List<Campaign>? campaigns;
  final String? message;

  CampaignsState copyWith({
    CampaignsStatus? status,
    List<Campaign>? campaigns,
    String? message,
  }) {
    return CampaignsState(
      status: status ?? this.status,
      campaigns: campaigns ?? this.campaigns,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, campaigns, message];
}
