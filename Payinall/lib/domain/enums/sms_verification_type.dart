enum SmsVerificationType {
  login(0),
  register(1),
  forgotPassword(2),
  changePhoneNumber(3),
  merchantLogin(4);

  const SmsVerificationType(this._value);
  final int _value;

  int get getValue => _value;
}

extension SmsVerificationTypeExtension on int {
  SmsVerificationType toSmsVerificationType() {
    return SmsVerificationType.values.firstWhere(
      (type) => type.getValue == this,
    );
  }
}
