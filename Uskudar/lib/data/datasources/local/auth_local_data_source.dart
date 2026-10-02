import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_local_data_source.dart';
import 'package:payinall/data/local_storage/hive_boxes.dart';
import 'package:payinall/data/local_storage/preferences_keys.dart';
import 'package:payinall/data/models/logged_in_model.dart';

abstract interface class AuthLocalDataSource {
  Future<void> logOut();
  Future<LoggedInModel?> getLoggedIn();
  Future<void> saveLoggedIn(LoggedInModel loggedIn);
  Future<void> removeKey(String key);
}

final class AuthLocalDataSourceImpl extends BaseLocalDataSource
    implements AuthLocalDataSource {
  AuthLocalDataSourceImpl() : super(HiveBoxes.auth);

  @override
  Future<void> logOut() async {
    await removeKey(PreferencesKeys.loggedInKey);
  }

  @override
  Future<LoggedInModel?> getLoggedIn() async {
    try {
      return read<LoggedInModel?>(PreferencesKeys.loggedInKey);
    } on CacheException {
      return null;
    }
  }

  @override
  Future<void> saveLoggedIn(LoggedInModel loggedIn) async {
    await write<LoggedInModel>(PreferencesKeys.loggedInKey, loggedIn);
  }
}
