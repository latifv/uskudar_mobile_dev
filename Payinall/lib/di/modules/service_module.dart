import 'package:get_it/get_it.dart';
import 'package:payinall/core/services/contact_service.dart';
import 'package:payinall/core/services/device_info_service.dart';
import 'package:payinall/core/services/image_picker_service.dart';
import 'package:payinall/core/services/permission_service.dart';
import 'package:payinall/core/services/qr_code_service/qr_code_service.dart';
import 'package:payinall/core/services/root_check_service.dart';
import 'package:payinall/core/services/signalr_service.dart';
import 'package:payinall/di/di_module.dart';

final class ServiceModule extends DIModule {
  @override
  Future<void> setup(GetIt getIt) async {
    getIt
      ..registerSingleton<DeviceInfoService>(DeviceInfoServiceImpl())
      ..registerSingleton<PermissionService>(
        PermissionServiceImpl(deviceInfoService: getIt()),
      )
      ..registerLazySingleton<ContactService>(
        () => ContactService(permissionService: getIt()),
      )
      ..registerLazySingleton<ImagePickerService>(ImagePickerServiceImpl.new)
      ..registerSingleton<RootCheckService>(RootCheckServiceImpl())
      ..registerLazySingleton<QRCodeService>(QRCodeServiceImpl.new)
      ..registerLazySingleton<SignalRService>(SignalRServiceImpl.new);
  }
}
