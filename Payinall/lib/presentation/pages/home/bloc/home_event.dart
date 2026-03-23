part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

final class HomeLoadData extends HomeEvent {
  const HomeLoadData();
}

final class HomeRefreshData extends HomeEvent {
  const HomeRefreshData();
}

final class HomeRefreshUserInfo extends HomeEvent {
  const HomeRefreshUserInfo();
}

final class HomeRefreshBalance extends HomeEvent {
  const HomeRefreshBalance();
}

final class HomeRefreshTransactions extends HomeEvent {
  const HomeRefreshTransactions();
}

final class HomeUpdateAvatarImage extends HomeEvent {
  const HomeUpdateAvatarImage(this.image);

  final String? image;
}

final class HomeDismissUserInfoCard extends HomeEvent {
  const HomeDismissUserInfoCard(this.cardType);

  final UserInfoCardType cardType;
}
