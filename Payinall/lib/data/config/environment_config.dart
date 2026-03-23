import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:payinall/data/dtos/environment.dart';
import 'package:payinall/domain/enums/app_environment.dart';

final class EnvironmentConfig {
  EnvironmentConfig._();

  static late final Environment _environment;

  static Future<void> initialize(AppEnvironment appEnvironment) async {
    final targetFileName = 'assets/env/${appEnvironment.envFileName}';
    await dotenv.load(fileName: targetFileName);

    _environment = Environment.fromJson(dotenv.env);
  }

  static Environment get values => _environment;
}
