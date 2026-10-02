enum AppEnvironment {
  development,
  test,
  production;

  String get envFileName {
    switch (this) {
      case AppEnvironment.development:
        return '.env.development';
      case AppEnvironment.test:
        return '.env.test';
      case AppEnvironment.production:
        return '.env.production';
    }
  }
}
