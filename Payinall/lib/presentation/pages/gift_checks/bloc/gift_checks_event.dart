part of 'gift_checks_bloc.dart';

sealed class GiftChecksEvent {
  const GiftChecksEvent();
}

final class GiftChecksLoadCategories extends GiftChecksEvent {
  const GiftChecksLoadCategories();
}
