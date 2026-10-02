import 'package:json_annotation/json_annotation.dart';

part 'current_user_info_response.g.dart';

@JsonSerializable(createToJson: false)
final class CurrentUserInfoResponse {
  const CurrentUserInfoResponse({
    this.customerNumber,
    this.lastWrongPasswordDate,
    this.lastWrongIpAddress,
    this.gsmNumber,
    this.firstName,
    this.lastName,
    this.statusId,
    this.customerType,
    this.customerTypeName,
    this.notificationTypeId,
    this.email,
    this.addressType,
    this.isExWallet,
    this.image,
    this.isUserQuestionChange,
    this.isMailConfirmed,
    this.emailConfirmed,
  });

  factory CurrentUserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserInfoResponseFromJson(json);

  final String? customerNumber;
  final DateTime? lastWrongPasswordDate;
  final String? lastWrongIpAddress;
  final String? gsmNumber;
  final String? firstName;
  final String? lastName;
  final int? statusId;
  final int? notificationTypeId;
  final int? customerType;
  final String? customerTypeName;
  final String? email;
  final int? addressType;
  final bool? isExWallet;
  final String? image;
  final bool? isUserQuestionChange;
  @JsonKey(name: 'isMailConfirmed')
  final bool? isMailConfirmed;
  @JsonKey(name: 'emailConfirmed')
  final bool? emailConfirmed;
}
