import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/app_bank.dart';

abstract interface class AppBanksRepository {
  Future<Either<Failure, List<AppBank>>> getActives();
}
