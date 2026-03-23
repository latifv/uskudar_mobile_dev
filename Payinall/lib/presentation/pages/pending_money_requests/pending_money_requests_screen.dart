import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/request_money.dart';
import 'package:payinall/presentation/pages/pending_money_requests/bloc/pending_money_requests_bloc.dart';
import 'package:payinall/presentation/pages/pending_money_requests/mixin/pending_money_requests_mixin.dart';
import 'package:payinall/presentation/pages/pending_money_requests/widgets/money_request_card.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_empty_list.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class PendingMoneyRequestsScreen extends StatefulWidget {
  const PendingMoneyRequestsScreen({super.key});

  @override
  State<PendingMoneyRequestsScreen> createState() =>
      _PendingMoneyRequestsScreenState();
}

final class _PendingMoneyRequestsScreenState
    extends State<PendingMoneyRequestsScreen>
    with TickerProviderStateMixin, PendingMoneyRequestsMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<PendingMoneyRequestsBloc, PendingMoneyRequestsState>(
        listener: blocListener,
        builder: (_, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Text(LocaleKeys.pending_money_requests.translate),
            ),
            body: Padding(
              padding: context.paddingBaseLow,
              child: _buildBody(state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(PendingMoneyRequestsState state) {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [_buildTabContent(state, 0), _buildTabContent(state, 1)],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: tabController,
      unselectedLabelColor: context.colorScheme.onSurface.withAlpha(120),
      tabs: [
        Tab(
          text: LocaleKeys.incoming_requests.translate,
          icon: const Icon(Icons.call_received_rounded),
        ),
        Tab(
          text: LocaleKeys.outgoing_requests.translate,
          icon: const Icon(Icons.call_made_rounded),
        ),
      ],
    );
  }

  Widget _buildTabContent(PendingMoneyRequestsState state, int tabIndex) {
    if (state is PendingMoneyRequestsLoading) {
      return const Center(child: CustomLoading());
    }

    if (state is PendingMoneyRequestsError) {
      return ErrorTryAgain(message: state.message, onTryAgain: loadRequests);
    }

    if (state is PendingMoneyRequestsLoaded) {
      final requests = tabIndex == 0
          ? state.incomingRequests
          : state.outgoingRequests;

      if (requests.isEmpty) {
        return CustomEmptyList(
          iconData: tabIndex == 0
              ? Icons.call_received_rounded
              : Icons.call_made_rounded,
          title: tabIndex == 0
              ? LocaleKeys.incoming_requests.translate
              : LocaleKeys.outgoing_requests.translate,
          description: tabIndex == 0
              ? LocaleKeys.incoming_requests_empty_state.translate
              : LocaleKeys.outgoing_requests_empty_state.translate,
        );
      }

      return _buildRequestsList(requests, tabIndex == 0);
    }

    return const SizedBox.shrink();
  }

  Widget _buildRequestsList(List<RequestMoney> requests, bool isIncoming) {
    return RefreshIndicator(
      onRefresh: () async => loadRequests(),
      child: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return MoneyRequestCard(
            request: request,
            isIncoming: isIncoming,
            onApprove: onApproveRequest,
            onReject: onRejectRequest,
            onDelete: onDeleteRequest,
          );
        },
      ),
    );
  }
}
