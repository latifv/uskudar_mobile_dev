class AuthToken {
  const AuthToken({
    required this.token,
    required this.expiration,
    required this.endDateMinute,
  });

  final String token;
  final DateTime expiration;
  final int endDateMinute;
}
