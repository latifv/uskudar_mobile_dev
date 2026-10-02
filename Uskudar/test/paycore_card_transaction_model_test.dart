import 'package:flutter_test/flutter_test.dart';
import 'package:uskudar_mobile/core/models/paycore_mobile_models.dart';

void main() {
  test('maps PayCore ATM fee and tax fields', () {
    final item = PaycoreCardTransactionItem.fromJson(const {
      'transactionId': 42,
      'title': 'ATM Para Çekme Ücreti',
      'description': 'ATM Para Çekme Ücreti',
      'amount': 23.10,
      'tax1Amount': 1.10,
      'tax2Amount': 0,
      'isFinancial': true,
      'effect': 'D',
    });

    expect(item.title, 'ATM Para Çekme Ücreti');
    expect(item.amount, 23.10);
    expect(item.tax1Amount, 1.10);
    expect(item.tax2Amount, 0);
    expect(item.isFinancial, isTrue);
    expect(item.effect, 'D');
  });

  test('maps commission and ending balance aliases', () {
    final item = PaycoreCardTransactionItem.fromJson(const {
      'transactionId': 43,
      'title': 'ATM Para Çekme',
      'amount': 2000,
      'feeAmount': 23.10,
      'balanceAfterTransaction': 356.44,
      'effect': 'D',
    });

    expect(item.commissionAmount, 23.10);
    expect(item.endingBalance, 356.44);
  });
}
