import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_local_data_source.dart';
import 'package:uskudar_mobile/data/local_storage/hive_boxes.dart';
import 'package:uskudar_mobile/data/local_storage/preferences_keys.dart';

abstract interface class AppLocalDataSource {
  Future<bool> getIsFirstRun();
  Future<void> setIsFirstRun();
  Future<bool> getIsDarkMode();
  Future<void> setIsDarkMode(bool isDarkMode);
  Future<String?> getSelectedLanguage();
  Future<void> setSelectedLanguage(String languageCode);
}

final class AppLocalDataSourceImpl extends BaseLocalDataSource
    implements AppLocalDataSource {
  AppLocalDataSourceImpl() : super(HiveBoxes.app);

  @override
  Future<bool> getIsFirstRun() async {
    try {
      final result = read<bool>(PreferencesKeys.isFirstRun);
      return result;
    } on CacheException catch (_) {
      return true;
    }
  }

  @override
  Future<void> setIsFirstRun() async {
    await write<bool>(PreferencesKeys.isFirstRun, false);
  }

  @override
  Future<bool> getIsDarkMode() async {
    try {
      final result = read<bool>(PreferencesKeys.isDarkMode);
      return result;
    } on CacheException catch (_) {
      return false;
    }
  }

  @override
  Future<void> setIsDarkMode(bool isDarkMode) async {
    await write<bool>(PreferencesKeys.isDarkMode, isDarkMode);
  }

  @override
  Future<String?> getSelectedLanguage() async {
    try {
      final result = read<String>(PreferencesKeys.selectedLanguage);
      return result;
    } on CacheException catch (_) {
      return null;
    }
  }

  @override
  Future<void> setSelectedLanguage(String languageCode) async {
    await write<String>(PreferencesKeys.selectedLanguage, languageCode);
  }
}
