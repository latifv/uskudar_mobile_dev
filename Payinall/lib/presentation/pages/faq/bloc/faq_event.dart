part of 'faq_bloc.dart';

sealed class FaqEvent {
  const FaqEvent();
}

final class FaqLoadData extends FaqEvent {
  const FaqLoadData();
}

final class FaqToggleExpanded extends FaqEvent {
  const FaqToggleExpanded({required this.index});
  final int index;
}
