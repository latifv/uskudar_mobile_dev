enum EmailVerificationType {
  emailUpdate,
  emailChange,
}

extension EmailVerificationTypeExtension on int {
  EmailVerificationType toEmailVerificationType() {
    return EmailVerificationType.values[this];
  }
}
