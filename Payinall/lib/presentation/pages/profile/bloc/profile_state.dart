part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
  loggedOut,
  balanceChecked,
  emailUpdateCodeSent,
}

final class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.key,
    this.message,
    this.name,
    this.surname,
    this.walletAddress,
    this.image,
    this.balance,
    this.hasBalance = false,
    this.emailProcessCode,
    this.newEmail,
  });
  final ProfileStatus status;
  final Key? key;
  final String? message;
  final String? name;
  final String? surname;
  final String? walletAddress;
  final String? image;
  final double? balance;
  final bool hasBalance;
  final String? emailProcessCode;
  final String? newEmail;

  ProfileState copyWith({
    ProfileStatus? status,
    Key? key,
    String? message,
    String? name,
    String? surname,
    String? walletAddress,
    String? image,
    double? balance,
    bool? hasBalance,
    String? emailProcessCode,
    String? newEmail,
  }) {
    return ProfileState(
      status: status ?? this.status,
      key: key ?? this.key,
      message: message,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      walletAddress: walletAddress ?? this.walletAddress,
      image: image ?? this.image,
      balance: balance ?? this.balance,
      hasBalance: hasBalance ?? this.hasBalance,
      emailProcessCode: emailProcessCode ?? this.emailProcessCode,
      newEmail: newEmail ?? this.newEmail,
    );
  }

  @override
  List<Object?> get props => [
    status,
    key,
    message,
    name,
    surname,
    walletAddress,
    image,
    balance,
    hasBalance,
    emailProcessCode,
    newEmail,
  ];
}
