part of 'bill_payment_bloc.dart';

sealed class BillPaymentEvent {
  const BillPaymentEvent();
}

final class BillPaymentLoadProductTypes extends BillPaymentEvent {
  const BillPaymentLoadProductTypes();
}

final class BillPaymentSelectProductType extends BillPaymentEvent {
  const BillPaymentSelectProductType(this.productType);

  final BillProductType productType;
}

final class BillPaymentLoadProducts extends BillPaymentEvent {
  const BillPaymentLoadProducts(this.productTypeId);

  final String productTypeId;
}

final class BillPaymentSelectProduct extends BillPaymentEvent {
  const BillPaymentSelectProduct(this.product);

  final BillProduct product;
}

final class BillPaymentSelectProductById extends BillPaymentEvent {
  const BillPaymentSelectProductById(this.productId);

  final String productId;
}

final class BillPaymentLoadProductQueryDefinition extends BillPaymentEvent {
  const BillPaymentLoadProductQueryDefinition(this.productId);

  final String productId;
}

final class BillPaymentInquiry extends BillPaymentEvent {
  const BillPaymentInquiry({
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

final class BillPaymentPay extends BillPaymentEvent {
  const BillPaymentPay({
    required this.subscriberName,
    required this.transactionQueryId,
    required this.invoiceAmount,
  });

  final String subscriberName;
  final String transactionQueryId;
  final double invoiceAmount;
}

final class BillPaymentReset extends BillPaymentEvent {
  const BillPaymentReset();
}

final class BillPaymentGoBack extends BillPaymentEvent {
  const BillPaymentGoBack();
}
