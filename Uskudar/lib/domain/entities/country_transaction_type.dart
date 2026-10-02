import 'package:uskudar_mobile/domain/entities/transaction_type.dart';

class CountryTransactionType {
  const CountryTransactionType({
    required this.countryCode,
    required this.countryName,
    required this.marketingExpense,
    required this.reporterExpense,
    required this.mandatoryBICCode,
    required this.requestedAccountMatrix,
    required this.transactionTypes,
  });

  final String countryCode;
  final String countryName;
  final double marketingExpense;
  final double reporterExpense;
  final bool mandatoryBICCode;
  final List<AccountMatrix> requestedAccountMatrix;
  final List<TransactionType> transactionTypes;
}

class AccountMatrix {
  const AccountMatrix({
    required this.accountMatrixCode,
    required this.accountMatrix,
  });

  final String accountMatrixCode;
  final String accountMatrix;
}
