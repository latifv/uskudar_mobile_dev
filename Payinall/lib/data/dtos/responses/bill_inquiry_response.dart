import 'package:json_annotation/json_annotation.dart';

part 'bill_inquiry_response.g.dart';

@JsonSerializable(createToJson: false)
final class BillInquiryResponse {
  const BillInquiryResponse({
    this.subscriberName,
    this.transactionQueryId,
    this.invoiceAmount,
    this.billNo,
    this.billDueDate,
  });

  factory BillInquiryResponse.fromJson(Map<String, dynamic> json) =>
      _$BillInquiryResponseFromJson(json);

  final String? subscriberName;
  final String? transactionQueryId;
  final double? invoiceAmount;
  final String? billNo;
  final String?
  billDueDate; // API'den string olarak geliyor, model'de DateTime'a çevrilecek
}
