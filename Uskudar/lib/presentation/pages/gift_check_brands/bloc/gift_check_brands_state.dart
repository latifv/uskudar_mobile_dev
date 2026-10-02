part of 'gift_check_brands_bloc.dart';

enum GiftCheckBrandsStatus { initial, loading, loaded, error }

final class GiftCheckBrandsState extends Equatable {
  const GiftCheckBrandsState({
    this.status = GiftCheckBrandsStatus.initial,
    this.brands,
    this.message,
  });

  final GiftCheckBrandsStatus status;
  final List<GiftCheckBrand>? brands;
  final String? message;

  GiftCheckBrandsState copyWith({
    GiftCheckBrandsStatus? status,
    List<GiftCheckBrand>? brands,
    String? message,
  }) {
    return GiftCheckBrandsState(
      status: status ?? this.status,
      brands: brands ?? this.brands,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, brands, message];
}
