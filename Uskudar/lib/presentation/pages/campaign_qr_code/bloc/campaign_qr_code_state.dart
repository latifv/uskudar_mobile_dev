part of 'campaign_qr_code_bloc.dart';

sealed class CampaignQrCodeState extends Equatable {
  const CampaignQrCodeState();

  @override
  List<Object?> get props => [];
}

final class CampaignQrCodeInitial extends CampaignQrCodeState {
  const CampaignQrCodeInitial();
}

final class CampaignQrCodeLoaded extends CampaignQrCodeState {
  const CampaignQrCodeLoaded({
    required this.qrCode,
    required this.remainingSeconds,
  });

  final String qrCode;
  final int remainingSeconds;

  @override
  List<Object?> get props => [qrCode, remainingSeconds];
}

final class CampaignQrCodeExpiredState extends CampaignQrCodeState {
  const CampaignQrCodeExpiredState();
}

final class CampaignQrCodeRegenerating extends CampaignQrCodeState {
  const CampaignQrCodeRegenerating();
}

final class CampaignQrCodeRegenerationFailed extends CampaignQrCodeState {
  const CampaignQrCodeRegenerationFailed({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
