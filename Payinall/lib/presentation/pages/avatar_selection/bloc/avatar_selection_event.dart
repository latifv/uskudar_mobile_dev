part of 'avatar_selection_bloc.dart';

sealed class AvatarSelectionEvent {
  const AvatarSelectionEvent();
}

final class AvatarSelectionLoadImages extends AvatarSelectionEvent {
  const AvatarSelectionLoadImages();
}

final class AvatarSelectionSelect extends AvatarSelectionEvent {
  const AvatarSelectionSelect({required this.avatarImageId});

  final int avatarImageId;
}

final class AvatarSelectionDeleteAvatar extends AvatarSelectionEvent {
  const AvatarSelectionDeleteAvatar();
}
