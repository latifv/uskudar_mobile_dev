part of 'merchant_detail_bloc.dart';

sealed class MerchantDetailEvent {
  const MerchantDetailEvent();
}

final class MerchantDetailCreateCard extends MerchantDetailEvent {
  const MerchantDetailCreateCard();
}

final class MerchantDetailCreateQrCode extends MerchantDetailEvent {
  const MerchantDetailCreateQrCode();
}
