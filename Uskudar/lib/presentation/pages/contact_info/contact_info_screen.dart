import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/contact_info.dart';
import 'package:uskudar_mobile/presentation/pages/contact_info/bloc/contact_info_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/contact_info/mixin/contact_info_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/contact_info/widgets/contact_info_item.dart';
import 'package:uskudar_mobile/presentation/pages/contact_info/widgets/social_media_icon.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';

@RoutePage()
final class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

final class _ContactInfoScreenState extends State<ContactInfoScreen>
    with ContactInfoMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.contact_info_title.translate),
      ),
      body: BlocBuilder<ContactInfoBloc, ContactInfoState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is ContactInfoInitial || state is ContactInfoLoading) {
            return const Center(child: CustomLoading());
          }

          if (state is ContactInfoError) {
            return ErrorTryAgain(message: state.message, onTryAgain: loadData);
          }

          if (state is ContactInfoLoaded) {
            return SingleChildScrollView(
              padding: context.paddingBase,
              child: _buildContent(state),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(ContactInfoLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.spacingNormalHeight,
        _buildHeaderTitle(LocaleKeys.contact_us.translate),
        context.spacingLowHeight,
        _buildHeaderText(LocaleKeys.contact_info_description.translate),
        context.spacingNormalHeight,
        _buildContactCard(state.contactItems),
        context.spacingMediumHeight,
        _buildSocialMediaIcons(state.socialMedias),
      ],
    );
  }

  Widget _buildHeaderTitle(String text) {
    return Text(
      text,
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurface.withAlpha(200),
      ),
    );
  }

  Widget _buildContactCard(List<ContactInfoModel> contactItems) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusHighAll,
        side: BorderSide(
          color: context.colorScheme.onSurface.withAlpha(50),
        ),
      ),
      child: Padding(
        padding: context.paddingLowAll + context.paddingMediumHorizontal,
        child: Column(
          children: [
            for (int i = 0; i < contactItems.length; i++) ...[
              ContactInfoItem(
                info: contactItems[i],
                onTap: () => handleItemTap(contactItems[i]),
              ),
              if (i < contactItems.length - 1)
                Padding(
                  padding: context.paddingLowVertical,
                  child: Divider(
                    color: context.colorScheme.onSurface.withAlpha(50),
                    thickness: 0.5,
                    height: 1,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaIcons(List<SocialMediaModel> socialMedias) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: socialMedias
            .map(
              (socialMedia) => SocialMediaIcon(
                socialMedia: socialMedia,
                onTap: () => openUrl(socialMedia.url),
              ),
            )
            .toList(),
      ),
    );
  }
}
