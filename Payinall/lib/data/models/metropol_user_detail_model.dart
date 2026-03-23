import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/metropol_user_detail_response.dart';
import 'package:payinall/domain/entities/metropol_user_detail.dart';

final class MetropolUserDetailModel extends MetropolUserDetail {
  const MetropolUserDetailModel({
    required super.userNo,
    required super.cardNo,
    required super.userAccountToken,
  });

  factory MetropolUserDetailModel.fromResponse(
    MetropolUserDetailResponse response,
  ) {
    if (response.userNo == null ||
        response.cardNo == null ||
        response.userAccountToken == null) {
      throw const MappingException();
    }

    return MetropolUserDetailModel(
      userNo: response.userNo!,
      cardNo: response.cardNo!,
      userAccountToken: response.userAccountToken!,
    );
  }
}
