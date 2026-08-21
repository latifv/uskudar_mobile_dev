import 'package:flutter_test/flutter_test.dart';
import 'package:payinall/data/dtos/responses/transaction_receipt_response.dart';
import 'package:payinall/data/dtos/responses/transaction_response.dart';
import 'package:payinall/data/models/transaction_model.dart';
import 'package:payinall/data/models/transaction_receipt_model.dart';

void main() {
  test('maps wallet balances returned by the transaction API', () {
    final response = TransactionResponse.fromJson(const {
      'id': '9e21f394-c446-476a-a8dd-4d4b92cb618d',
      'amount': 500,
      'commissionAmount': 50,
      'commissionType': 'Tutar',
      'description': 'ATM Para Çekme',
      'transferType': 'Para Çek',
      'statusName': 'Başarılı',
      'fromFullName': 'Test Kullanıcı',
      'date': '2026-08-21T12:00:00',
      'transactionTypes': 2,
      'oldBalance': 1000,
      'newBalance': 450,
    });

    final transaction = TransactionModel.fromResponse(response);

    expect(transaction.amount, 500);
    expect(transaction.commissionAmount, 50);
    expect(transaction.oldBalance, 1000);
    expect(transaction.newBalance, 450);
  });

  test('maps ending balance returned by the receipt API', () {
    final response = TransactionReceiptResponse.fromJson(const {
      'transferOperationTypeName': 'Para Çek',
      'orderNumber': '000000001',
      'receiptNo': 'R-1',
      'fromCustomerFullName': 'Test Kullanıcı',
      'transferStatusTypeName': 'Başarılı',
      'commissionFromTypeName': 'Gönderen',
      'createdDate': '2026-08-21T12:00:00',
      'amount': 500,
      'commissionAmount': 50,
      'endingBalance': 450,
      'description': 'ATM Para Çekme',
      'institutionAddress': 'Adres',
      'institutionTaxOffice': 'Vergi Dairesi',
      'institutionTaxNo': '123',
      'institutionName': 'Payinall',
      'basisAmount': 42,
      'bsmvAmount': 8,
      'bsmvRate': 0.2,
    });

    final receipt = TransactionReceiptModel.fromResponse(response);

    expect(receipt.endingBalance, 450);
  });
}
