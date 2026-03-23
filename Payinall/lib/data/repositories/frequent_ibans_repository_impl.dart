import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/frequent_ibans_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/add_frequent_iban_request.dart';
import 'package:payinall/data/models/frequent_iban_model.dart';
import 'package:payinall/domain/entities/frequent_iban.dart';
import 'package:payinall/domain/params/add_frequent_iban_params.dart';
import 'package:payinall/domain/repositories/frequent_ibans_repository.dart';

final class FrequentIbansRepositoryImpl implements FrequentIbansRepository {
  FrequentIbansRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final FrequentIbansRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<FrequentIban>>> getFrequentIbans() async {
    return _dataSourceHandler
        .handle<List<FrequentIban>, List<FrequentIbanModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getFrequentIbans();
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, String>> addFrequentIban(
    AddFrequentIbanParams params,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final request = AddFrequentIbanRequest.fromParams(params);
        final result = await remoteDataSource.addFrequentIban(request);
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, String>> deleteFrequentIban(String id) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.deleteFrequentIban(id);
        return result;
      },
      onlyMessage: true,
    );
  }
}
