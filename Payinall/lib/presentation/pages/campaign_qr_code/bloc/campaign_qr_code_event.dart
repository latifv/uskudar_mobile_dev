part of 'campaign_qr_code_bloc.dart';

sealed class CampaignQrCodeEvent {
  const CampaignQrCodeEvent();
}

final class CampaignQrCodeStarted extends CampaignQrCodeEvent {
  const CampaignQrCodeStarted({required this.qrCode});

  final String qrCode;
}

final class CampaignQrCodeTimerTicked extends CampaignQrCodeEvent {
  const CampaignQrCodeTimerTicked({required this.remainingSeconds});

  final int remainingSeconds;
}

final class CampaignQrCodeExpired extends CampaignQrCodeEvent {
  const CampaignQrCodeExpired();
}

final class CampaignQrCodeRegenerateRequested extends CampaignQrCodeEvent {
  const CampaignQrCodeRegenerateRequested();
}
