import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/gift_check_brand.dart';
import 'package:payinall/domain/repositories/gift_checks_repository.dart';

final class GetGiftCheckBrandsUsecase
    implements BaseUsecase<List<GiftCheckBrand>, String> {
  GetGiftCheckBrandsUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, List<GiftCheckBrand>>> call(String categoryId) async {
    return repository.getBrands(categoryId);
  }
}
