import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_brand_detail.dart';
import 'package:uskudar_mobile/domain/repositories/gift_checks_repository.dart';

final class GetGiftCheckBrandDetailUsecase
    implements BaseUsecase<GiftCheckBrandDetail, String> {
  GetGiftCheckBrandDetailUsecase(this.repository);

  final GiftChecksRepository repository;

  @override
  Future<Either<Failure, GiftCheckBrandDetail>> call(String brandId) async {
    return repository.getBrandDetail(brandId);
  }
}
