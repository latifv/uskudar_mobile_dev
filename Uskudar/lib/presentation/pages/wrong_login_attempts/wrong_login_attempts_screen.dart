import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/wrong_login_attempts/bloc/wrong_login_attempts_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/wrong_login_attempts/mixin/wrong_login_attempts_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/wrong_login_attempts/widgets/wrong_login_attempt_card.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_empty_list.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';

@RoutePage()
final class WrongLoginAttemptsScreen extends StatefulWidget {
  const WrongLoginAttemptsScreen({super.key});

  @override
  State<WrongLoginAttemptsScreen> createState() =>
      _WrongLoginAttemptsScreenState();
}

final class _WrongLoginAttemptsScreenState
    extends State<WrongLoginAttemptsScreen>
    with WrongLoginAttemptsMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.wrong_login_attempts_title.translate),
      ),
      body: BlocBuilder<WrongLoginAttemptsBloc, WrongLoginAttemptsState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.status == WrongLoginAttemptsStatus.loading) {
            return const Center(child: CustomLoading());
          } else if (state.status == WrongLoginAttemptsStatus.error) {
            return ErrorTryAgain(
              message: state.message,
              onTryAgain: loadWrongLoginAttemptsData,
            );
          } else if (state.status == WrongLoginAttemptsStatus.loaded) {
            if (state.wrongPasswordHistories?.isEmpty ?? true) {
              return CustomEmptyList(
                iconData: Icons.security_outlined,
                title: LocaleKeys.wrong_login_attempts_empty_title.translate,
                description:
                    LocaleKeys.wrong_login_attempts_empty_description.translate,
              );
            }
            return _buildContent(state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(WrongLoginAttemptsState state) {
    return ListView.builder(
      padding: context.paddingBaseLow,
      itemCount: state.wrongPasswordHistories!.length,
      itemBuilder: (context, index) {
        final wrongPasswordHistory = state.wrongPasswordHistories![index];
        return WrongLoginAttemptCard(
          wrongPasswordHistory: wrongPasswordHistory,
        );
      },
    );
  }
}
