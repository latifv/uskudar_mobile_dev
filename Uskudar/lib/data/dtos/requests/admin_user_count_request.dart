import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/enums/time_type.dart';
import 'package:uskudar_mobile/domain/params/admin_user_count_params.dart';

part 'admin_user_count_request.g.dart';

@JsonSerializable(createFactory: false)
final class AdminUserCountRequest extends AdminUserCountParams {
  const AdminUserCountRequest({
    required super.timeType,
  });

  factory AdminUserCountRequest.fromParams(AdminUserCountParams params) {
    return AdminUserCountRequest(
      timeType: params.timeType,
    );
  }

  Map<String, dynamic> toJson() => _$AdminUserCountRequestToJson(this);

  @JsonKey(name: 'timeTypes')
  int get timeTypes => timeType.value;
}
