import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/email_verification_confirm_request.dart';
import 'package:payinall/data/dtos/requests/register_request.dart';
import 'package:payinall/data/dtos/requests/update_email_confirm_request.dart';
import 'package:payinall/data/dtos/requests/update_email_send_code_request.dart';
import 'package:payinall/data/dtos/requests/update_secret_question_request.dart';
import 'package:payinall/data/dtos/responses/current_user_info_response.dart';
import 'package:payinall/data/models/current_user_info_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class UsersRemoteDataSource {
  Future<NetworkResponse<String>> register(RegisterRequest request);
  Future<NetworkResponse<CurrentUserInfoModel>> getCurrentUserInfo();
  Future<NetworkResponse<void>> changeNotification(int notificationTypeId);
  Future<NetworkResponse<void>> remove();
  Future<NetworkResponse<void>> updateSecretQuestion(
    UpdateSecretQuestionRequest request,
  );
  Future<NetworkResponse<String>> emailVerificationSendCode();
  Future<NetworkResponse<void>> emailVerificationConfirm(
    EmailVerificationConfirmRequest request,
  );
  Future<NetworkResponse<String>> updateEmailSendCode(
    UpdateEmailSendCodeRequest request,
  );
  Future<NetworkResponse<void>> updateEmailConfirm(
    UpdateEmailConfirmRequest request,
  );
}

final class UsersRemoteDataSourceImpl extends BaseRemoteDataSource
    implements UsersRemoteDataSource {
  UsersRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<String>> register(RegisterRequest request) async {
    final responseJson = await post(
      endpoint: Endpoints.register,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> remove() async {
    final responseJson = await post(endpoint: Endpoints.remove);

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<CurrentUserInfoModel>> getCurrentUserInfo() async {
    final responseJson = await get(endpoint: Endpoints.currentUserInfo);
    final response = NetworkResponse.fromJson<CurrentUserInfoResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return CurrentUserInfoResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(CurrentUserInfoModel.fromResponse);
  }

  @override
  Future<NetworkResponse<void>> changeNotification(
    int notificationTypeId,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.changeNotification(notificationTypeId),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> updateSecretQuestion(
    UpdateSecretQuestionRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.updateSecretQuestion,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<String>> emailVerificationSendCode() async {
    final responseJson = await post(
      endpoint: Endpoints.emailVerificationSendCode,
      data: <String, dynamic>{},
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> emailVerificationConfirm(
    EmailVerificationConfirmRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.emailVerificationConfirm,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<String>> updateEmailSendCode(
    UpdateEmailSendCodeRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.updateEmailSendCode,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> updateEmailConfirm(
    UpdateEmailConfirmRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.updateEmailConfirm,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
