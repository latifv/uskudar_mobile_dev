part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileLoadData extends ProfileEvent {
  const ProfileLoadData({this.refresh = false});

  final bool refresh;
}

final class ProfileLogout extends ProfileEvent {
  const ProfileLogout();
}

final class ProfileDeleteAccount extends ProfileEvent {
  const ProfileDeleteAccount();
}

final class ProfileCheckBalance extends ProfileEvent {
  const ProfileCheckBalance();
}

final class ProfileSendEmailUpdateCode extends ProfileEvent {
  const ProfileSendEmailUpdateCode();
}
