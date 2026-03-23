class BillInquiryParams {
  const BillInquiryParams({
    required this.productId,
    required this.subscriberNo,
    this.subscriberNo2,
    this.subscriberNo3,
  });

  final String productId;
  final String subscriberNo;
  final String? subscriberNo2;
  final String? subscriberNo3;
}
