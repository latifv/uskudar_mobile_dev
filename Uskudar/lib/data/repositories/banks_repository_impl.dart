// import 'package:fpdart/fpdart.dart';
// import 'package:payinall/core/error/failures.dart';
// import 'package:payinall/data/core/data_source_handler.dart';
// import 'package:payinall/data/datasources/remote/banks_remote_data_source.dart';
// import 'package:payinall/data/models/bank_model.dart';
// import 'package:payinall/domain/entities/bank.dart';
// import 'package:payinall/domain/repositories/banks_repository.dart';

// final class BanksRepositoryImpl implements BanksRepository {
//   BanksRepositoryImpl({required this.remoteDataSource})
//     : _dataSourceHandler = DataSourceHandler();

//   final BanksRemoteDataSource remoteDataSource;
//   final DataSourceHandler _dataSourceHandler;

//   @override
//   Future<Either<Failure, List<Bank>>> getList() async {
//     return _dataSourceHandler.handle<List<Bank>, List<BankModel>>(
//       remoteFunction: () async {
//         final result = await remoteDataSource.getList();
//         return result;
//       },
//       onlyData: true,
//     );
//   }

//   @override
//   Future<Either<Failure, Bank>> getById(String id) async {
//     return _dataSourceHandler.handle<Bank, BankModel>(
//       remoteFunction: () async {
//         final result = await remoteDataSource.getById(id);
//         return result;
//       },
//       onlyData: true,
//     );
//   }
// }
