part of 'gift_checks_bloc.dart';

enum GiftChecksStatus { initial, loading, loaded, error }

final class GiftChecksState extends Equatable {
  const GiftChecksState({
    this.status = GiftChecksStatus.initial,
    this.categories,
    this.message,
  });

  final GiftChecksStatus status;
  final List<GiftCheckCategory>? categories;
  final String? message;

  GiftChecksState copyWith({
    GiftChecksStatus? status,
    List<GiftCheckCategory>? categories,
    String? message,
  }) {
    return GiftChecksState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, categories, message];
}
