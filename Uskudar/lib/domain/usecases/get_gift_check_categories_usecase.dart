import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_category.dart';
import 'package:uskudar_mobile/domain/repositories/gift_checks_repository.dart';

final class GetGiftCheckCategoriesUsecase
    implements BaseUsecaseWithoutParams<List<GiftCheckCategory>> {
  GetGiftCheckCategoriesUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, List<GiftCheckCategory>>> call() async {
    return repository.getCategories();
  }
}
