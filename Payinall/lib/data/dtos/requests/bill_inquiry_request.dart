import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/bill_inquiry_params.dart';

part 'bill_inquiry_request.g.dart';

@JsonSerializable(createFactory: false)
final class BillInquiryRequest extends BillInquiryParams {
  const BillInquiryRequest({
    required super.productId,
    required super.subscriberNo,
    super.subscriberNo2,
    super.subscriberNo3,
  });

  factory BillInquiryRequest.fromParams(BillInquiryParams params) {
    return BillInquiryRequest(
      productId: params.productId,
      subscriberNo: params.subscriberNo,
      subscriberNo2: params.subscriberNo2,
      subscriberNo3: params.subscriberNo3,
    );
  }

  Map<String, dynamic> toJson() => _$BillInquiryRequestToJson(this);
}
