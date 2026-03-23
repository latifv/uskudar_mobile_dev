part of 'account_verification_bloc.dart';

sealed class AccountVerificationEvent {
  const AccountVerificationEvent();
}

final class GetUserQuestions extends AccountVerificationEvent {}

final class AccountVerificationSubmit extends AccountVerificationEvent {
  const AccountVerificationSubmit({
    required this.firstName,
    required this.lastName,
    required this.tcNo,
    required this.birthDate,
    required this.email,
    required this.phoneNumber,
    required this.secretQuestion,
    this.userQuestionId,
  });

  final String firstName;
  final String lastName;
  final String tcNo;
  final String birthDate;
  final String email;
  final String phoneNumber;
  final int? userQuestionId;
  final String secretQuestion;
}
