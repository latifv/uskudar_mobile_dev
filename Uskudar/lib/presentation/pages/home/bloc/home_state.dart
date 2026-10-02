part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, error, requiredScoringQuestions }

enum UserInfoCardType {
  scoreQuestion,
  arkSigner,
  addressVerification,
  addressRejected,
  avatarSelection,
}

final class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.balance,
    this.blockBalance,
    this.walletAddress,
    this.firstName,
    this.image,
    this.transactions,
    this.frequentIbans = const [],
    this.frequentlySents = const [],
    this.key,
    this.message,
    this.customerType,
    this.addressType,
    this.lastWrongPasswordDate,
    this.lastWrongIpAddress,
    this.dismissedCards = const [],
  });

  final HomeStatus status;
  final double? balance;
  final double? blockBalance;
  final String? walletAddress;
  final String? firstName;
  final String? image;
  final List<Transaction>? transactions;
  final List<FrequentIban> frequentIbans;
  final List<FrequentlySent> frequentlySents;
  final Key? key;
  final String? message;
  final int? customerType;
  final int? addressType;
  final String? lastWrongPasswordDate;
  final String? lastWrongIpAddress;
  final List<UserInfoCardType> dismissedCards;
  HomeState copyWith({
    HomeStatus? status,
    double? balance,
    double? blockBalance,
    String? walletAddress,
    String? firstName,
    String? image,
    List<Transaction>? transactions,
    List<FrequentIban>? frequentIbans,
    List<FrequentlySent>? frequentlySents,
    Key? key,
    String? message,
    int? customerType,
    int? addressType,
    String? lastWrongPasswordDate,
    String? lastWrongIpAddress,
    List<UserInfoCardType>? dismissedCards,
  }) {
    return HomeState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      blockBalance: blockBalance ?? this.blockBalance,
      walletAddress: walletAddress ?? this.walletAddress,
      firstName: firstName ?? this.firstName,
      image: image ?? this.image,
      transactions: transactions ?? this.transactions,
      frequentIbans: frequentIbans ?? this.frequentIbans,
      frequentlySents: frequentlySents ?? this.frequentlySents,
      key: key ?? this.key,
      message: message,
      lastWrongPasswordDate: lastWrongPasswordDate,
      lastWrongIpAddress: lastWrongIpAddress,
      customerType: customerType ?? this.customerType,
      addressType: addressType ?? this.addressType,
      dismissedCards: dismissedCards ?? this.dismissedCards,
    );
  }

  @override
  List<Object?> get props => [
    status,
    balance,
    blockBalance,
    walletAddress,
    firstName,
    image,
    transactions,
    frequentIbans,
    frequentlySents,
    key,
    message,
    customerType,
    addressType,
    lastWrongPasswordDate,
    lastWrongIpAddress,
    dismissedCards,
  ];
}
