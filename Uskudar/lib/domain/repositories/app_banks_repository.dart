import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/app_bank.dart';

abstract interface class AppBanksRepository {
  Future<Either<Failure, List<AppBank>>> getActives();
}
