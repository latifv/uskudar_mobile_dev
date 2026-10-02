import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/responses/user_question_response.dart';
import 'package:uskudar_mobile/data/models/user_question_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class UserQuestionsRemoteDataSource {
  Future<NetworkResponse<List<UserQuestionModel>>> getUserQuestions();
}

final class UserQuestionsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements UserQuestionsRemoteDataSource {
  UserQuestionsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<UserQuestionModel>>> getUserQuestions() async {
    final responseJson = await get(endpoint: Endpoints.userQuestions);
    final response = NetworkResponse.fromJson<List<UserQuestionResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    UserQuestionResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(UserQuestionModel.fromResponse).toList(),
    );
  }
}
