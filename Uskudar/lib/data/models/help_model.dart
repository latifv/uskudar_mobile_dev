import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/help_response.dart';
import 'package:uskudar_mobile/domain/entities/help.dart';

final class HelpModel extends Help {
  const HelpModel({
    required super.id,
    required super.title,
    required super.content,
  });

  factory HelpModel.fromResponse(HelpResponse response) {
    if (response.id == null ||
        response.title == null ||
        response.content == null) {
      throw const MappingException();
    }

    return HelpModel(
      id: response.id!,
      title: response.title!,
      content: response.content!,
    );
  }
}
