part of 'registered_users_bloc.dart';

sealed class RegisteredUsersEvent {
  const RegisteredUsersEvent();
}

final class RegisteredUsersLoad extends RegisteredUsersEvent {
  const RegisteredUsersLoad();
}

final class RegisteredUsersAddUser extends RegisteredUsersEvent {
  const RegisteredUsersAddUser({required this.customerNumber});

  final String customerNumber;
}

final class RegisteredUsersDeleteUser extends RegisteredUsersEvent {
  const RegisteredUsersDeleteUser({required this.id});

  final int id;
}

final class RegisteredUsersAddIban extends RegisteredUsersEvent {
  const RegisteredUsersAddIban({
    required this.ibanNo,
    required this.firstName,
    required this.lastName,
  });

  final String ibanNo;
  final String firstName;
  final String lastName;
}

final class RegisteredUsersDeleteIban extends RegisteredUsersEvent {
  const RegisteredUsersDeleteIban({required this.id});

  final String id;
}

final class RegisteredUsersTabChanged extends RegisteredUsersEvent {
  const RegisteredUsersTabChanged({required this.tabIndex});

  final int tabIndex;
}
