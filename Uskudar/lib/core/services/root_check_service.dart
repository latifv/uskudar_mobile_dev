import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';

abstract interface class RootCheckService {
  Future<bool> isDeviceRooted();
}

final class RootCheckServiceImpl implements RootCheckService {
  RootCheckServiceImpl() {
    _jailbreakDetection = JailbreakRootDetection();
  }
  late final JailbreakRootDetection _jailbreakDetection;

  @override
  Future<bool> isDeviceRooted() async {
    final isJailbroken = await _jailbreakDetection.isJailBroken;
    if (isJailbroken) {
      LogHelper.logCriticalError('Rootlu cihaz algılandı!');
    }
    return isJailbroken;
  }
}
