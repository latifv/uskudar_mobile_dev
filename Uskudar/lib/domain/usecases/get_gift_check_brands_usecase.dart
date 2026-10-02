import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_brand.dart';
import 'package:uskudar_mobile/domain/repositories/gift_checks_repository.dart';

final class GetGiftCheckBrandsUsecase
    implements BaseUsecase<List<GiftCheckBrand>, String> {
  GetGiftCheckBrandsUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, List<GiftCheckBrand>>> call(String categoryId) async {
    return repository.getBrands(categoryId);
  }
}
