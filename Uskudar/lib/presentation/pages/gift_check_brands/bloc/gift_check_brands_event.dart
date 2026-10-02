part of 'gift_check_brands_bloc.dart';

sealed class GiftCheckBrandsEvent {
  const GiftCheckBrandsEvent();
}

final class GiftCheckBrandsLoad extends GiftCheckBrandsEvent {
  const GiftCheckBrandsLoad({required this.categoryId});
  final String categoryId;
}
