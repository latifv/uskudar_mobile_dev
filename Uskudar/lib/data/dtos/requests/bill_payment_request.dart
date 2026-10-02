import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/bill_payment_params.dart';

part 'bill_payment_request.g.dart';

@JsonSerializable(createFactory: false)
final class BillPaymentRequest extends BillPaymentParams {
  const BillPaymentRequest({
    required super.subscriberName,
    required super.transactionQueryId,
    required super.invoiceAmount,
  });

  factory BillPaymentRequest.fromParams(BillPaymentParams params) {
    return BillPaymentRequest(
      subscriberName: params.subscriberName,
      transactionQueryId: params.transactionQueryId,
      invoiceAmount: params.invoiceAmount,
    );
  }

  Map<String, dynamic> toJson() => _$BillPaymentRequestToJson(this);
}
