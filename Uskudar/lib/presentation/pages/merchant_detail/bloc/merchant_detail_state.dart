part of 'merchant_detail_bloc.dart';

enum MerchantDetailStatus {
  initial,
  processing,
  cardSuccess,
  qrCodeSuccess,
  error,
}

final class MerchantDetailState extends Equatable {
  const MerchantDetailState({
    this.status = MerchantDetailStatus.initial,
    this.qrCode,
    this.message,
  });

  final MerchantDetailStatus status;
  final String? qrCode;
  final String? message;
  MerchantDetailState copyWith({
    MerchantDetailStatus? status,
    String? qrCode,
    String? message,
  }) {
    return MerchantDetailState(
      status: status ?? this.status,
      qrCode: qrCode,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, qrCode, message];
}
