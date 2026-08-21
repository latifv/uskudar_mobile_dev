import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/transaction_receipt_response.dart';
import 'package:payinall/domain/entities/transaction_receipt.dart';

final class TransactionReceiptModel extends TransactionReceipt {
  const TransactionReceiptModel({
    required super.transferOperationTypeName,
    required super.orderNumber,
    required super.receiptNo,
    required super.fromCustomerFullName,
    required super.transferStatusTypeName,
    required super.commissionFromTypeName,
    required super.createdDate,
    required super.amount,
    required super.commissionAmount,
    required super.description,
    required super.institutionAddress,
    required super.institutionTaxOffice,
    required super.institutionTaxNo,
    required super.institutionName,
    required super.basisAmount,
    required super.bsmvAmount,
    required super.bsmvRate,
    super.fromCustomerNumber,
    super.toCustomerFullName,
    super.toCustomerNumber,
    super.endingBalance,
  });

  factory TransactionReceiptModel.fromResponse(
    TransactionReceiptResponse response,
  ) {
    if (response.transferOperationTypeName == null ||
        response.orderNumber == null ||
        response.receiptNo == null ||
        response.fromCustomerFullName == null ||
        response.transferStatusTypeName == null ||
        response.commissionFromTypeName == null ||
        response.createdDate == null ||
        response.amount == null ||
        response.commissionAmount == null ||
        response.description == null ||
        response.institutionAddress == null ||
        response.institutionTaxOffice == null ||
        response.institutionTaxNo == null ||
        response.institutionName == null ||
        response.basisAmount == null ||
        response.bsmvAmount == null ||
        response.bsmvRate == null) {
      throw const MappingException();
    }
    return TransactionReceiptModel(
      transferOperationTypeName: response.transferOperationTypeName!,
      orderNumber: response.orderNumber!,
      receiptNo: response.receiptNo!,
      fromCustomerFullName: response.fromCustomerFullName!,
      fromCustomerNumber: response.fromCustomerNumber,
      transferStatusTypeName: response.transferStatusTypeName!,
      commissionFromTypeName: response.commissionFromTypeName!,
      toCustomerFullName: response.toCustomerFullName,
      toCustomerNumber: response.toCustomerNumber,
      createdDate: response.createdDate!,
      amount: response.amount!,
      commissionAmount: response.commissionAmount!,
      description: response.description!,
      institutionAddress: response.institutionAddress!,
      institutionTaxOffice: response.institutionTaxOffice!,
      institutionTaxNo: response.institutionTaxNo!,
      institutionName: response.institutionName!,
      basisAmount: response.basisAmount!,
      bsmvAmount: response.bsmvAmount!,
      bsmvRate: response.bsmvRate!,
      endingBalance: response.endingBalance,
    );
  }
}
