import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/current_user_info_response.dart';
import 'package:uskudar_mobile/domain/entities/current_user_info.dart';

final class CurrentUserInfoModel extends CurrentUserInfo {
  const CurrentUserInfoModel({
    required super.customerNumber,
    required super.gsmNumber,
    required super.firstName,
    required super.lastName,
    required super.statusId,
    required super.notificationTypeId,
    required super.customerType,
    required super.customerTypeName,
    required super.email,
    required super.addressType,
    required super.isExWallet,
    super.lastWrongPasswordDate,
    super.lastWrongIpAddress,
    super.image,
    super.isUserQuestionChange,
    super.isMailConfirmed,
  });

  factory CurrentUserInfoModel.fromResponse(CurrentUserInfoResponse response) {
    if (response.customerNumber == null ||
        response.gsmNumber == null ||
        response.firstName == null ||
        response.lastName == null ||
        response.statusId == null ||
        response.notificationTypeId == null ||
        response.customerType == null ||
        response.customerTypeName == null ||
        response.addressType == null ||
        response.email == null ||
        response.isExWallet == null) {
      throw const MappingException();
    }

    return CurrentUserInfoModel(
      customerNumber: response.customerNumber!,
      lastWrongPasswordDate: response.lastWrongPasswordDate,
      lastWrongIpAddress: response.lastWrongIpAddress,
      gsmNumber: response.gsmNumber!,
      addressType: response.addressType!,
      firstName: response.firstName!,
      lastName: response.lastName!,
      statusId: response.statusId!,
      notificationTypeId: response.notificationTypeId!,
      customerType: response.customerType!,
      customerTypeName: response.customerTypeName!,
      email: response.email!,
      isExWallet: response.isExWallet!,
      image: response.image,
      isUserQuestionChange: response.isUserQuestionChange ?? false,
      isMailConfirmed: response.isMailConfirmed ?? response.emailConfirmed,
    );
  }
}
