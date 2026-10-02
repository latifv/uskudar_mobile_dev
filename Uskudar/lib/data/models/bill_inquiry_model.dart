import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/bill_inquiry_response.dart';
import 'package:uskudar_mobile/domain/entities/bill_inquiry.dart';

final class BillInquiryModel extends BillInquiry {
  const BillInquiryModel({
    required super.subscriberName,
    required super.transactionQueryId,
    required super.invoiceAmount,
    required super.billNo,
    required super.billDueDate,
  });

  factory BillInquiryModel.fromResponse(BillInquiryResponse response) {
    if (response.subscriberName == null ||
        response.transactionQueryId == null ||
        response.invoiceAmount == null ||
        response.billNo == null ||
        response.billDueDate == null) {
      throw const MappingException();
    }

    DateTime billDueDate;
    try {
      // API'den "10-07-2025" formatında geliyor, dd-MM-yyyy formatında parse ediyoruz
      final dateParts = response.billDueDate!.split('-');
      if (dateParts.length != 3) {
        throw const MappingException();
      }
      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);
      billDueDate = DateTime(year, month, day);
    } on Exception catch (e) {
      throw MappingException(e.toString());
    }

    return BillInquiryModel(
      subscriberName: response.subscriberName!,
      transactionQueryId: response.transactionQueryId!,
      invoiceAmount: response.invoiceAmount!,
      billNo: response.billNo!,
      billDueDate: billDueDate,
    );
  }
}
