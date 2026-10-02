// import 'package:fpdart/fpdart.dart';
// import 'package:uskudar_mobile/core/error/failures.dart';
// import 'package:uskudar_mobile/data/core/data_source_handler.dart';
// import 'package:uskudar_mobile/data/datasources/remote/banks_remote_data_source.dart';
// import 'package:uskudar_mobile/data/models/bank_model.dart';
// import 'package:uskudar_mobile/domain/entities/bank.dart';
// import 'package:uskudar_mobile/domain/repositories/banks_repository.dart';

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
