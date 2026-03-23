part of 'avatar_selection_bloc.dart';

enum AvatarSelectionStatus {
  initial,
  loading,
  loaded,
  selecting,
  deleting,
  success,
  error,
}

final class AvatarSelectionState extends Equatable {
  const AvatarSelectionState({
    this.status = AvatarSelectionStatus.initial,
    this.avatarImages = const [],
    this.message,
    this.hasCurrentAvatar = false,
  });

  final AvatarSelectionStatus status;
  final List<AvatarImage> avatarImages;
  final String? message;
  final bool hasCurrentAvatar;

  AvatarSelectionState copyWith({
    AvatarSelectionStatus? status,
    List<AvatarImage>? avatarImages,
    String? message,
    bool? hasCurrentAvatar,
  }) {
    return AvatarSelectionState(
      status: status ?? this.status,
      avatarImages: avatarImages ?? this.avatarImages,
      message: message,
      hasCurrentAvatar: hasCurrentAvatar ?? this.hasCurrentAvatar,
    );
  }

  @override
  List<Object?> get props => [status, avatarImages, message, hasCurrentAvatar];
}
