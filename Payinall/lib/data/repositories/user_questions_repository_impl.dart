import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/user_questions_remote_data_source.dart';
import 'package:payinall/data/models/user_question_model.dart';
import 'package:payinall/domain/entities/user_question.dart';
import 'package:payinall/domain/repositories/user_questions_repository.dart';

final class UserQuestionsRepositoryImpl implements UserQuestionsRepository {
  UserQuestionsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final UserQuestionsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<UserQuestion>>> getUserQuestions() async {
    return _dataSourceHandler
        .handle<List<UserQuestion>, List<UserQuestionModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getUserQuestions();
            return result;
          },
          onlyData: true,
        );
  }
}
