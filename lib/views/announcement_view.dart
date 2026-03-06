import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/announcement.dart';
import '../viewmodels/announcement_viewmodel.dart';

class AnnouncementView extends StatefulWidget {
  const AnnouncementView({super.key});

  @override
  State<AnnouncementView> createState() => _AnnouncementViewState();
}

class _AnnouncementViewState extends State<AnnouncementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnnouncementViewModel>().loadAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AnnouncementViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Announcements',
          style: GoogleFonts.poppins(
            color: const Color(0xFF363A33),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF363A33), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: _buildBody(vm),
      ),
    );
  }

  Widget _buildBody(AnnouncementViewModel vm) {
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFCB8944)),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 56, color: Color(0xFFA0A39D)),
              const SizedBox(height: 16),
              Text(
                vm.errorMessage!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF70756B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    context.read<AnnouncementViewModel>().loadAnnouncements(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCB8944),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Retry',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.announcements.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.campaign_outlined,
                size: 64, color: Color(0xFFD4C4A8)),
            const SizedBox(height: 16),
            Text(
              'No announcements yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF70756B),
              ),
            ),
            Text(
              'Check back later for updates.',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFFA0A39D)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFCB8944),
      onRefresh: () =>
          context.read<AnnouncementViewModel>().loadAnnouncements(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: vm.announcements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, i) {
          final a = vm.announcements[i];
          return _AnnouncementCard(
            announcement: a,
            onViewed: () =>
                context.read<AnnouncementViewModel>().trackView(a.id),
            onClicked: () =>
                context.read<AnnouncementViewModel>().trackClick(a.id),
          );
        },
      ),
    );
  }
}

// ─── Card widget ─────────────────────────────────────────────────────────────

class _AnnouncementCard extends StatefulWidget {
  const _AnnouncementCard({
    required this.announcement,
    required this.onViewed,
    required this.onClicked,
  });

  final Announcement announcement;
  final VoidCallback onViewed;
  final VoidCallback onClicked;

  @override
  State<_AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<_AnnouncementCard> {
  @override
  void initState() {
    super.initState();
    // Fire-and-forget view tracking
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onViewed());
  }

  IconData get _typeIcon {
    switch (widget.announcement.type) {
      case 'promotion':
        return Icons.local_offer_outlined;
      case 'maintenance':
        return Icons.build_outlined;
      case 'event':
        return Icons.event_outlined;
      default:
        return Icons.campaign_outlined;
    }
  }

  Color get _typeColor {
    switch (widget.announcement.type) {
      case 'promotion':
        return const Color(0xFFFFF3E0);
      case 'maintenance':
        return const Color(0xFFFFE0E0);
      case 'event':
        return const Color(0xFFE8F5E9);
      default:
        return const Color(0xFFF3E9D2);
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.announcement;
    final hasImage = a.imageUrl != null && a.imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        widget.onClicked();
        // TODO: navigate to detail or open actionUrl
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFE8EBE6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner image (if available)
            if (hasImage)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  a.imageUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _typeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_typeIcon,
                        color: const Color(0xFFCB8944), size: 22),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                a.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF363A33),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(a.startDate),
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: const Color(0xFFA0A39D),
                              ),
                            ),
                          ],
                        ),
                        if (a.description != null &&
                            a.description!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            a.description!,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF70756B),
                              height: 1.5,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (a.actionUrl != null && a.actionUrl!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            'Learn more →',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFCB8944),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
