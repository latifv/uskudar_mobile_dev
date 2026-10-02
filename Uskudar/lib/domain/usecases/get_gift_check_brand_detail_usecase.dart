import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/gift_check_brand_detail.dart';
import 'package:payinall/domain/repositories/gift_checks_repository.dart';

final class GetGiftCheckBrandDetailUsecase
    implements BaseUsecase<GiftCheckBrandDetail, String> {
  GetGiftCheckBrandDetailUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, GiftCheckBrandDetail>> call(String brandId) async {
    return repository.getBrandDetail(brandId);
  }
}
