import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/avatar_selection/bloc/avatar_selection_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin AvatarSelectionMixin<T extends StatefulWidget> on State<T> {
  late final AvatarSelectionBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<AvatarSelectionBloc>();
    loadAvatarImages();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadAvatarImages() {
    bloc.add(const AvatarSelectionLoadImages());
  }

  void onAvatarSelected(int avatarImageId) {
    bloc.add(AvatarSelectionSelect(avatarImageId: avatarImageId));
  }

  void onDeleteAvatarPressed() {
    bloc.add(const AvatarSelectionDeleteAvatar());
  }

  void blocListener(BuildContext context, AvatarSelectionState state) {
    if (state.status == AvatarSelectionStatus.success) {
      ToastComponent.showSuccessToast(
        context: context,
        message: LocaleKeys.success.translate,
      );
      unawaited(context.router.maybePop(true));
    } else if (state.status == AvatarSelectionStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message,
      );
    }
  }
}
