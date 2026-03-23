part of 'account_verification_bloc.dart';

enum AccountVerificationStatus {
  initial,
  loading,
  loaded,
  processing,
  success,
  error,
}

final class AccountVerificationState extends Equatable {
  const AccountVerificationState({
    this.status = AccountVerificationStatus.initial,
    this.message,
    this.userQuestions,
  });

  final AccountVerificationStatus status;
  final String? message;
  final List<UserQuestion>? userQuestions;

  AccountVerificationState copyWith({
    AccountVerificationStatus? status,
    String? message,
    List<UserQuestion>? userQuestions,
  }) {
    return AccountVerificationState(
      status: status ?? this.status,
      userQuestions: userQuestions ?? this.userQuestions,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, message, userQuestions];
}
