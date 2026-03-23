import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/frequently_sents_remote_data_source.dart';
import 'package:payinall/data/models/frequently_sent_model.dart';
import 'package:payinall/domain/entities/frequently_sent.dart';
import 'package:payinall/domain/repositories/frequently_sents_repository.dart';

final class FrequentlySentsRepositoryImpl implements FrequentlySentsRepository {
  FrequentlySentsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final FrequentlySentsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<FrequentlySent>>> getFrequentlySents() async {
    return _dataSourceHandler
        .handle<List<FrequentlySent>, List<FrequentlySentModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getFrequentlySents();
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, String>> addFrequentlySent(
    String customerNumber,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.addFrequentlySent(customerNumber);
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, String>> deleteFrequentlySent(
    int id,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.deleteFrequentlySent(id);
        return result;
      },
      onlyMessage: true,
    );
  }
}
