import 'dart:async';

import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';
import 'package:url_launcher/url_launcher.dart';

extension LaunchUrlStringExtension on String {
  Future<void> launchAsUrl({LaunchMode? mode}) async {
    mode ??= LaunchMode.platformDefault;
    final uri = Uri.parse(this);
    final canLaunch = await canLaunchUrl(uri);
    if (canLaunch) {
      unawaited(launchUrl(uri, mode: mode));
    } else {
      LogHelper.log(LogLevel.error, 'URL başlatılamadı: $this');
    }
  }
}
