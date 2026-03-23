import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payinall/core/constants/app_constants.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/enums/agreement_type.dart';
import 'package:payinall/presentation/pages/face_scan/bloc/face_scan_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';

mixin FaceScanMixin<T extends StatefulWidget> on State<T> {
  late final FaceScanBloc bloc;
  static final methodChannel = MethodChannel(AppConstants.arkSignerLiveAuth);
  dynamic faceScanResult;
  late final String processId;
  late final String? image;

  @override
  void initState() {
    super.initState();
    bloc = getIt<FaceScanBloc>();
  }

  Future<void> showAgreements() async {
    final result = await context.router.push(
      AgreementRoute(
        agreementType: AgreementType
            .musteriEdinimiUzaktanKimlikTespitiAydinlatmaMetni
            .getValue,
        isRead: false,
      ),
    );
    if (result == true) {
      if (mounted) {
        final resultTwo = await context.router.push(
          AgreementRoute(
            agreementType: AgreementType.biyometrikVeriRizasi.getValue,
            isRead: false,
          ),
        );

        if (resultTwo == true) {
          bloc.add(const FaceScanAgreementsCompleted());
        } else {
          if (mounted) {
            context.router.pop();
          }
        }
      }
    } else {
      if (mounted) {
        context.router.pop();
      }
    }
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  Future<void> onFaceScanStart() async {
    try {
      bloc.add(const FaceScanStart());

      faceScanResult = await methodChannel.invokeMethod('selfie');

      final lists = <String>[];
      (faceScanResult as Map<dynamic, dynamic>).forEach((key, value) {
        for (final element in (value as List<dynamic>)) {
          lists.add(element as String);
        }
      });
      bloc.add(
        FaceScanEnd(faceImageList: lists, processId: processId, image: image),
      );
    } on PlatformException {
      bloc.add(
        FaceScanEnd(faceImageList: [], processId: processId, image: image),
      );
    } on Exception {
      bloc.add(
        FaceScanEnd(faceImageList: [], processId: processId, image: image),
      );
    }
  }
}
