class CurrentUserInfo {
  const CurrentUserInfo({
    required this.customerNumber,
    required this.gsmNumber,
    required this.firstName,
    required this.lastName,
    required this.statusId,
    required this.notificationTypeId,
    required this.customerType,
    required this.customerTypeName,
    required this.email,
    required this.addressType,
    required this.isExWallet,
    this.lastWrongPasswordDate,
    this.lastWrongIpAddress,
    this.image,
    this.isUserQuestionChange = false,
    this.isMailConfirmed,
  });

  final String customerNumber;
  final DateTime? lastWrongPasswordDate;
  final String? lastWrongIpAddress;
  final String gsmNumber;
  final String firstName;
  final String lastName;
  final int statusId;
  final int customerType;
  final String customerTypeName;
  final int addressType;
  final int notificationTypeId;
  final String email;
  final bool isExWallet;
  final String? image;
  final bool isUserQuestionChange;
  final bool? isMailConfirmed;
}
