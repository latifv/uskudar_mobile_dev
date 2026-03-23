class RegisterParams {
  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.gsmNumber,
    required this.email,
    required this.code,
    required this.identityNumber,
    required this.dateOfBirth,
    required this.password,
    required this.isContractConfirm,
    required this.rePassword,
    required this.userQuestionId,
    required this.secretQuestion,
    required this.seriNo,
  });

  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String password;
  final bool isContractConfirm;
  final String rePassword;
  final String gsmNumber;
  final String email;
  final String code;
  final String identityNumber;
  final int userQuestionId;
  final String secretQuestion;
  final String seriNo;
}
