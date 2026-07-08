import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payinall/core/models/paycore_mobile_models.dart';
import 'package:payinall/core/services/paycore_mobile_service.dart';
import 'package:payinall/data/network/network_client.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/shared/widgets/paycore_card_visual.dart';

final class HomePaycoreCardsCarousel extends StatefulWidget {
  const HomePaycoreCardsCarousel({
    required this.onPressed,
    required this.onSendPressed,
    required this.onRequestPressed,
    required this.onWithdrawPressed,
    required this.refreshSeed,
    super.key,
  });

  final VoidCallback onPressed;
  final VoidCallback onSendPressed;
  final VoidCallback onRequestPressed;
  final VoidCallback onWithdrawPressed;
  final String refreshSeed;

  @override
  State<HomePaycoreCardsCarousel> createState() =>
      _HomePaycoreCardsCarouselState();
}

final class _HomePaycoreCardsCarouselState
    extends State<HomePaycoreCardsCarousel> {
  late final PaycoreMobileService _paycoreMobileService;
  late final PageController _pageController;

  List<PaycoreCardSummary> _cards = const [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _paycoreMobileService = PaycoreMobileService(getIt<NetworkClient>());
    _pageController = PageController(viewportFraction: 0.9);
    _pageController.addListener(_handlePageChange);
    unawaited(_loadCards());
  }

  @override
  void didUpdateWidget(covariant HomePaycoreCardsCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshSeed != widget.refreshSeed) {
      unawaited(_loadCards());
    }
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_handlePageChange)
      ..dispose();
    super.dispose();
  }

  void _handlePageChange() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentIndex && mounted) {
      setState(() {
        _currentIndex = page;
      });
    }
  }

  Future<void> _loadCards() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _paycoreMobileService.getMyCards();
      if (!mounted) {
        return;
      }

      setState(() {
        _cards = response.data ?? const [];
        _currentIndex = 0;
        _isLoading = false;
      });
    } on Object {
      if (!mounted) {
        return;
      }

      setState(() {
        _cards = const [];
        _currentIndex = 0;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionActionBar(
          onSendPressed: widget.onSendPressed,
          onRequestPressed: widget.onRequestPressed,
          onWithdrawPressed: widget.onWithdrawPressed,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Kartlarım',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: widget.onPressed,
              child: const Text('Tümünü Gör'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 156,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              final card = _cards[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == _cards.length - 1 ? 0 : 6,
                ),
                child: _HomePaycoreCard(
                  card: card,
                  onTap: widget.onPressed,
                ),
              );
            },
          ),
        ),
        if (_cards.length > 1) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _cards.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: index == _currentIndex ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: index == _currentIndex
                      ? context.colorScheme.primary
                      : context.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

final class _HomePaycoreCard extends StatelessWidget {
  const _HomePaycoreCard({
    required this.card,
    required this.onTap,
  });

  final PaycoreCardSummary card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PaycoreCardVisual(
      card: card,
      onTap: onTap,
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF1D2D87).withValues(alpha: 0.16),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
      frontChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildBadge(
                context,
                card.isPrimary ? 'Ana Kart' : card.statusName,
              ),
              const SizedBox(width: 4),
              _buildBadge(
                context,
                card.isActive ? 'Aktif' : 'Pasif',
              ),
            ],
          ),
          const Spacer(),
          Text(
            card.maskedCardNo,
            style: context.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              fontSize: 16,
              shadows: const [
                Shadow(
                  color: Color(0x6B000000),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${card.profileLabel} • ${card.cardTypeName}',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w600,
              fontSize: 11.5,
              shadows: const [
                Shadow(
                  color: Color(0x6B000000),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  card.embossName?.isNotEmpty ?? false
                      ? card.embossName!
                      : 'Kartını yönetmek için dokun',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    shadows: const [
                      Shadow(
                        color: Color(0x6B000000),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: context.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 9.5,
        ),
      ),
    );
  }
}

final class _SectionActionBar extends StatelessWidget {
  const _SectionActionBar({
    required this.onSendPressed,
    required this.onRequestPressed,
    required this.onWithdrawPressed,
  });

  final VoidCallback onSendPressed;
  final VoidCallback onRequestPressed;
  final VoidCallback onWithdrawPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF8FBFF),
            Color(0xFFF1F6FF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFDDE7FF),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22338B).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionBarButton(
              label: 'Para Gönder',
              icon: Icons.send_rounded,
              accentColor: const Color(0xFF2A43AE),
              onTap: onSendPressed,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: _ActionBarButton(
              label: 'Para İste',
              icon: Icons.request_page_rounded,
              accentColor: const Color(0xFF5A43C6),
              onTap: onRequestPressed,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: _ActionBarButton(
              label: 'Para Çek',
              icon: Icons.atm_rounded,
              accentColor: const Color(0xFF008D74),
              onTap: onWithdrawPressed,
            ),
          ),
        ],
      ),
    );
  }
}

final class _ActionBarButton extends StatelessWidget {
  const _ActionBarButton({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE3EAFE),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                icon,
                size: 11,
                color: accentColor,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
