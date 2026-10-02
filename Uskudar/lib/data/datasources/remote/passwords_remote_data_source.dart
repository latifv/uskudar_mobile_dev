import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/change_password_request.dart';
import 'package:payinall/data/dtos/requests/forgot_change_password_request.dart';
import 'package:payinall/data/dtos/requests/forgot_password_request.dart';
import 'package:payinall/data/dtos/requests/merchant_user_forgot_change_password_request.dart';
import 'package:payinall/data/dtos/requests/merchant_user_forgot_password_request.dart';
import 'package:payinall/data/dtos/requests/question_name_request.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class PasswordsRemoteDataSource {
  Future<NetworkResponse<void>> changePassword(ChangePasswordRequest request);
  Future<NetworkResponse<String>> getQuestionName(QuestionNameRequest request);
  Future<NetworkResponse<String>> forgotPassword(ForgotPasswordRequest request);
  Future<NetworkResponse<void>> forgotChangePassword(
    ForgotChangePasswordRequest request,
  );
  Future<NetworkResponse<String>> merchantUserForgotPassword(
    MerchantUserForgotPasswordRequest request,
  );
  Future<NetworkResponse<void>> merchantUserForgotChangePassword(
    MerchantUserForgotChangePasswordRequest request,
  );
}

final class PasswordsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements PasswordsRemoteDataSource {
  PasswordsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<void>> changePassword(
    ChangePasswordRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.changePassword,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<String>> getQuestionName(
    QuestionNameRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getQuestionName(request.identityNumber),
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );
    return response;
  }

  @override
  Future<NetworkResponse<String>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.forgotPassword,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> forgotChangePassword(
    ForgotChangePasswordRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.forgotChangePassword,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<String>> merchantUserForgotPassword(
    MerchantUserForgotPasswordRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.merchantUserForgotPassword,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> merchantUserForgotChangePassword(
    MerchantUserForgotChangePasswordRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.merchantUserForgotChangePassword,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
