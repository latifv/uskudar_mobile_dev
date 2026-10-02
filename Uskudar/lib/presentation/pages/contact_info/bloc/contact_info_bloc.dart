import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payinall/core/constants/app_constants.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/contact_info.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

part 'contact_info_event.dart';
part 'contact_info_state.dart';

final class ContactInfoBloc extends Bloc<ContactInfoEvent, ContactInfoState> {
  ContactInfoBloc() : super(const ContactInfoInitial()) {
    on<ContactInfoLoadData>(_loadData);
  }

  void _loadData(ContactInfoLoadData event, Emitter<ContactInfoState> emit) {
    emit(const ContactInfoLoading());

    final contactItems = <ContactInfoModel>[
      ContactInfoModel(
        title: LocaleKeys.customer_service_company.translate,
        content: AppConstants.customerServicePhoneNumber,
        iconData: FontAwesomeIcons.phone,
      ),
      ContactInfoModel(
        title: LocaleKeys.email_address.translate,
        content: AppConstants.customerServiceEmail,
        iconData: FontAwesomeIcons.envelope,
      ),
    ];

    final socialMedias = <SocialMediaModel>[
      SocialMediaModel(
        iconData: FontAwesomeIcons.facebook,
        url: AppConstants.socialMediaFacebookUrl,
      ),
      SocialMediaModel(
        iconData: FontAwesomeIcons.twitter,
        url: AppConstants.socialMediaTwitterUrl,
      ),
      SocialMediaModel(
        iconData: FontAwesomeIcons.instagram,
        url: AppConstants.socialMediaInstagramUrl,
      ),
      SocialMediaModel(
        iconData: FontAwesomeIcons.linkedin,
        url: AppConstants.socialMediaLinkedinUrl,
      ),
    ].where((socialMedia) => socialMedia.url.isNotEmpty).toList();

    emit(
      ContactInfoLoaded(contactItems: contactItems, socialMedias: socialMedias),
    );
  }
}
