import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/customer_mobiles_params.dart';

part 'customer_mobiles_request.g.dart';

@JsonSerializable(createFactory: false)
final class CustomerMobilesRequest extends CustomerMobilesParams {
  const CustomerMobilesRequest({
    required super.deviceId,
    required super.notificationToken,
  });

  factory CustomerMobilesRequest.fromParams(CustomerMobilesParams params) {
    return CustomerMobilesRequest(
      deviceId: params.deviceId,
      notificationToken: params.notificationToken,
    );
  }

  Map<String, dynamic> toJson() => _$CustomerMobilesRequestToJson(this);
}
