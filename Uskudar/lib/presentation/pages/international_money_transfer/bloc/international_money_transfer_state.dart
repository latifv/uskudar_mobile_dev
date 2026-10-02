part of 'international_money_transfer_bloc.dart';

enum InternationalMoneyTransferStatus {
  initial,
  loadingAttributes,
  attributesLoaded,
  loadingTransactionTypeData,
  transactionTypeDataLoaded,
  submitting,
  submitted,
  confirming,
  confirmed,
  error,
}

final class InternationalMoneyTransferState extends Equatable {
  const InternationalMoneyTransferState({
    this.status = InternationalMoneyTransferStatus.initial,
    this.corporationAttributes,
    this.selectedCorporation,
    this.transferResult,
    this.message,
    this.bicBankList,
    this.officeList,
    this.cardBinList,
    this.walletOperatorList,
    this.selectedBicBank,
    this.selectedOffice,
  });

  final InternationalMoneyTransferStatus status;
  final List<CorporationAttribute>? corporationAttributes;
  final CorporationAttribute? selectedCorporation;
  final InternationalTransferResult? transferResult;
  final String? message;
  final List<BicBank>? bicBankList;
  final List<Office>? officeList;
  final List<CardBin>? cardBinList;
  final List<WalletOperator>? walletOperatorList;
  final BicBank? selectedBicBank;
  final Office? selectedOffice;

  InternationalMoneyTransferState copyWith({
    InternationalMoneyTransferStatus? status,
    List<CorporationAttribute>? corporationAttributes,
    CorporationAttribute? selectedCorporation,
    InternationalTransferResult? transferResult,
    String? message,
    List<BicBank>? bicBankList,
    List<Office>? officeList,
    List<CardBin>? cardBinList,
    List<WalletOperator>? walletOperatorList,
    BicBank? selectedBicBank,
    Office? selectedOffice,
  }) {
    return InternationalMoneyTransferState(
      status: status ?? this.status,
      corporationAttributes:
          corporationAttributes ?? this.corporationAttributes,
      selectedCorporation: selectedCorporation ?? this.selectedCorporation,
      transferResult: transferResult ?? this.transferResult,
      message: message,
      bicBankList: bicBankList ?? this.bicBankList,
      officeList: officeList ?? this.officeList,
      cardBinList: cardBinList ?? this.cardBinList,
      walletOperatorList: walletOperatorList ?? this.walletOperatorList,
      selectedBicBank: selectedBicBank ?? this.selectedBicBank,
      selectedOffice: selectedOffice ?? this.selectedOffice,
    );
  }

  @override
  List<Object?> get props => [
    status,
    corporationAttributes,
    selectedCorporation,
    transferResult,
    message,
    bicBankList,
    officeList,
    cardBinList,
    walletOperatorList,
    selectedBicBank,
    selectedOffice,
  ];
}
