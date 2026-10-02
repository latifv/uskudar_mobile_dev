import 'package:payinall/data/core/base_local_data_source.dart';
import 'package:payinall/data/local_storage/hive_boxes.dart';
import 'package:payinall/data/local_storage/preferences_keys.dart';

abstract interface class CustomersLocalDataSource {
  Future<void> logOut();
}

final class CustomersLocalDataSourceImpl extends BaseLocalDataSource
    implements CustomersLocalDataSource {
  CustomersLocalDataSourceImpl() : super(HiveBoxes.auth);

  @override
  Future<void> logOut() async {
    await removeKey(PreferencesKeys.loggedInKey);
  }
}
