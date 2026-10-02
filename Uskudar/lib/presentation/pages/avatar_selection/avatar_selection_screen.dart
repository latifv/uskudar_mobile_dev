import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/avatar_selection/bloc/avatar_selection_bloc.dart';
import 'package:payinall/presentation/pages/avatar_selection/mixin/avatar_selection_mixin.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

final class _AvatarSelectionScreenState extends State<AvatarSelectionScreen>
    with AvatarSelectionMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<AvatarSelectionBloc, AvatarSelectionState>(
        listener: blocListener,
        builder: (_, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: CustomAppBar(
                  title: Text(LocaleKeys.select_your_avatar.translate),
                  // actions: [
                  // if (state.status == AvatarSelectionStatus.deleting)
                  //   Padding(
                  //     padding: context.paddingLowAll,
                  //     child: const CustomLoading(dynamicSize: 0.06),
                  //   )
                  // else if (state.hasCurrentAvatar)
                  //   IconButton(
                  //     onPressed: onDeleteAvatarPressed,
                  //     icon: Icon(
                  //       Icons.delete_outline_rounded,
                  //       color: context.colorScheme.error,
                  //     ),
                  //   ),
                  // ],
                ),
                body: SafeArea(child: _buildBody(state)),
              ),
              if (state.status == AvatarSelectionStatus.selecting)
                ColoredBox(
                  color: Colors.black.withAlpha(128),
                  child: const Center(child: CustomLoading()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(AvatarSelectionState state) {
    if (state.status == AvatarSelectionStatus.loading) {
      return const Center(child: CustomLoading());
    }

    if (state.status == AvatarSelectionStatus.error &&
        state.avatarImages.isEmpty) {
      return ErrorTryAgain(
        message: state.message ?? LocaleKeys.unknown_error.translate,
        onTryAgain: loadAvatarImages,
      );
    }

    return _buildContent(state);
  }

  Widget _buildContent(AvatarSelectionState state) {
    return Column(
      children: [
        context.spacingNormalHeight,
        Text(
          LocaleKeys.select_avatar_description.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(150),
          ),
          textAlign: TextAlign.center,
        ),
        context.spacingNormalHeight,
        Expanded(
          child: GridView.builder(
            padding: context.paddingNormalAll,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.avatarImages.length,
            itemBuilder: (context, index) {
              final avatar = state.avatarImages[index];
              return _buildAvatarItem(avatar.id ?? 0, avatar.image ?? '');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarItem(int id, String imageData) {
    return InkWell(
      onTap: () => onAvatarSelected(id),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: context.colorScheme.outline.withAlpha(50),
            width: 2,
          ),
        ),
        child: ClipOval(child: ImageNetworkComponent(imageUrl: imageData)),
      ),
    );
  }
}
