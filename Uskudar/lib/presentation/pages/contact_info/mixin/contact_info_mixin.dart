import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/entities/contact_info.dart';
import 'package:uskudar_mobile/presentation/pages/contact_info/bloc/contact_info_bloc.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/launch_url_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:url_launcher/url_launcher.dart';

mixin ContactInfoMixin<T extends StatefulWidget> on State<T> {
  late final ContactInfoBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<ContactInfoBloc>();
    loadData();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadData() {
    bloc.add(const ContactInfoLoadData());
  }

  Future<void> openUrl(
    String url, {
    bool isPhone = false,
    bool isEmail = false,
  }) async {
    var launchableUrl = url;

    if (isPhone) {
      launchableUrl = 'tel:${url.replaceAll(' ', '')}';
    } else if (isEmail) {
      launchableUrl = 'mailto:$url';
    }

    await launchableUrl.launchAsUrl(mode: LaunchMode.externalApplication);
  }

  void handleItemTap(ContactInfoModel info) {
    if (info.title.contains(LocaleKeys.customer_service.translate)) {
      unawaited(openUrl(info.content, isPhone: true));
    } else if (info.title.contains(LocaleKeys.email_address.translate)) {
      unawaited(openUrl(info.content, isEmail: true));
    }
  }
}
