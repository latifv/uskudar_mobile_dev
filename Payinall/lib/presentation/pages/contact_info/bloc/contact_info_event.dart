part of 'contact_info_bloc.dart';

sealed class ContactInfoEvent {
  const ContactInfoEvent();
}

final class ContactInfoLoadData extends ContactInfoEvent {
  const ContactInfoLoadData();
}
