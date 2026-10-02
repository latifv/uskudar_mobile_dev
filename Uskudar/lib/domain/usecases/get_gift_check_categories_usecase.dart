import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/gift_check_category.dart';
import 'package:payinall/domain/repositories/gift_checks_repository.dart';

final class GetGiftCheckCategoriesUsecase
    implements BaseUsecaseWithoutParams<List<GiftCheckCategory>> {
  GetGiftCheckCategoriesUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, List<GiftCheckCategory>>> call() async {
    return repository.getCategories();
  }
}
