part of 'contact_info_bloc.dart';

sealed class ContactInfoState extends Equatable {
  const ContactInfoState();

  @override
  List<Object?> get props => [];
}

final class ContactInfoInitial extends ContactInfoState {
  const ContactInfoInitial();
}

final class ContactInfoLoading extends ContactInfoState {
  const ContactInfoLoading();
}

final class ContactInfoLoaded extends ContactInfoState {
  const ContactInfoLoaded({
    required this.contactItems,
    required this.socialMedias,
  });

  final List<ContactInfoModel> contactItems;
  final List<SocialMediaModel> socialMedias;

  @override
  List<Object?> get props => [contactItems, socialMedias];
}

final class ContactInfoError extends ContactInfoState {
  const ContactInfoError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
