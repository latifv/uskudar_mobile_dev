import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/wallet_transfer_params.dart';

part 'wallet_transfer_request.g.dart';

@JsonSerializable(createFactory: false)
final class WalletTransferRequest extends WalletTransferParams {
  const WalletTransferRequest({
    required super.userQuery,
    required super.amount,
  });

  factory WalletTransferRequest.fromParams(WalletTransferParams params) {
    return WalletTransferRequest(
      userQuery: params.userQuery,
      amount: params.amount,
    );
  }

  Map<String, dynamic> toJson() => _$WalletTransferRequestToJson(this);
}
