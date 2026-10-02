part of 'page_search_bloc.dart';

sealed class PageSearchState extends Equatable {
  const PageSearchState();

  @override
  List<Object?> get props => [];
}

final class PageSearchInitial extends PageSearchState {
  const PageSearchInitial();
}

final class PageSearchLoading extends PageSearchState {
  const PageSearchLoading();
}

final class PageSearchLoaded extends PageSearchState {
  const PageSearchLoaded({
    required this.allPages,
    required this.filteredPages,
    required this.query,
  });

  final List<AppPageItem> allPages;
  final List<AppPageItem> filteredPages;
  final String query;

  @override
  List<Object?> get props => [allPages, filteredPages, query];

  bool get hasResults => filteredPages.isNotEmpty;
  bool get isSearching => query.isNotEmpty;
  bool get isEmpty => query.isEmpty;
}

final class PageSearchError extends PageSearchState {
  const PageSearchError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
