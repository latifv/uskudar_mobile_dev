part of 'page_search_bloc.dart';

sealed class PageSearchEvent {
  const PageSearchEvent();
}

final class PageSearchLoadData extends PageSearchEvent {
  const PageSearchLoadData();
}

final class PageSearchQueryChanged extends PageSearchEvent {
  const PageSearchQueryChanged({required this.query});
  final String query;
}

final class PageSearchClearQuery extends PageSearchEvent {
  const PageSearchClearQuery();
}
