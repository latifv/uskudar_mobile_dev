import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/entities/avatar_image.dart';

part 'avatar_image_response.g.dart';

@JsonSerializable(createToJson: false)
final class AvatarImageResponse {
  const AvatarImageResponse({this.id, this.genderTypes, this.image});

  factory AvatarImageResponse.fromJson(Map<String, dynamic> json) =>
      _$AvatarImageResponseFromJson(json);

  final int? id;
  final int? genderTypes;
  final String? image;

  AvatarImage toEntity() => AvatarImage(
    id: id,
    genderTypes: genderTypes,
    image: image,
  );
}
