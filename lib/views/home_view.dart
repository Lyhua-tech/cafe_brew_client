import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/announcement.dart';
import '../viewmodels/announcement_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'announcement_view.dart';
import 'my_account_view.dart';
import 'onboarding_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnnouncementViewModel>().loadAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const _ProfileDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Header Segment
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi ${context.watch<AuthViewModel>().currentUser?.name.isNotEmpty == true ? context.watch<AuthViewModel>().currentUser!.name : 'Guest'}",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF363A33),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "What are you craving?",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF363A33),
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            letterSpacing: -0.17,
                          ),
                        ),
                      ],
                    ),
                    Builder(
                      builder: (context) {
                        final user = context.watch<AuthViewModel>().currentUser;
                        return GestureDetector(
                          onTap: () async {
                            await context.read<AuthViewModel>().checkAuth();
                            if (!context.mounted) return;
                            Scaffold.of(context).openDrawer();
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                user?.avatar != null && user!.avatar!.isNotEmpty
                                    ? NetworkImage(user.avatar!)
                                    : const AssetImage(
                                            'assets/images/home_banner.png')
                                        as ImageProvider,
                            backgroundColor: const Color(0xFFE8EBE6),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE8EBE6),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.search,
                          color: Color(0xFF91958E),
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "search...",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF91958E),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Banners Carousel
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildPromoBanner(
                      title: "35% OFF\non Ice Latte",
                      bgColor: const Color(0xFFF3E9D2),
                      imagePath: 'assets/images/cold_brew.png',
                    ),
                    const SizedBox(width: 16),
                    _buildPromoBanner(
                      title: "25% OFF\non Coconut Cream",
                      bgColor: const Color(0xFFECF1E8),
                      imagePath: 'assets/images/home_banner.png',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Announcement Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Announcement",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF363A33),
                    letterSpacing: -0.17,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Announcements List
              _buildAnnouncementsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner({
    required String title,
    required Color bgColor,
    required String imagePath,
  }) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                imagePath,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF363A33),
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCB8944),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Buy now",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsSection(BuildContext context) {
    final vm = context.watch<AnnouncementViewModel>();

    if (vm.isLoading) {
      // Simple loading shimmer placeholder
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: List.generate(
            2,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (vm.announcements.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SizedBox.shrink(),
      );
    }

    // Show at most 3 announcements on the home screen
    final items = vm.announcements.take(3).toList();
    final headerColors = [
      const Color(0xFFE7D1A0),
      const Color(0xFFADC4A0),
      const Color(0xFFCB8944),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildAnnouncementCard(
              announcement: items[i],
              fallbackColor: headerColors[i % headerColors.length],
            ),
            if (i < items.length - 1) const SizedBox(height: 16),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard({
    required Announcement announcement,
    required Color fallbackColor,
  }) {
    final hasImage =
        announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        context.read<AnnouncementViewModel>().trackClick(announcement.id);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AnnouncementView()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: real image or colored block
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: hasImage
                  ? Image.network(
                      announcement.imageUrl!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 140,
                        color: fallbackColor,
                      ),
                    )
                  : Container(height: 140, color: fallbackColor),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: const Color(0xFF363A33),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (announcement.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            announcement.description!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: const Color(0xFF60655C),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E9D2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'View',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFCB8944),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
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

class _ProfileDrawer extends StatefulWidget {
  const _ProfileDrawer();

  @override
  State<_ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<_ProfileDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthViewModel>().refreshCurrentUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser;
    final displayName =
        (user?.name.isNotEmpty ?? false) ? user!.name : 'Guest User';
    final displayEmail =
        (user?.email.isNotEmpty ?? false) ? user!.email : 'guest@example.com';

    return Drawer(
      width: MediaQuery.of(context).size.width,
      backgroundColor: const Color(0xFFF5F5F5),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundImage:
                        user?.avatar != null && user!.avatar!.isNotEmpty
                            ? NetworkImage(user.avatar!)
                            : const AssetImage('assets/images/home_banner.png')
                                as ImageProvider,
                    backgroundColor: const Color(0xFFE8EBE6),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 34 / 1.7,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF363A33),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          displayEmail,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xFF70756B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _sectionTitle('Personal'),
              const SizedBox(height: 12),
              _menuTile(
                icon: Icons.person_outline,
                title: 'My Account',
                onTap: () {
                  Navigator.of(context).pop(); // close drawer
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const MyAccountView(),
                    ),
                  );
                },
              ),
              _menuTile(icon: Icons.history, title: 'History'),
              _menuTile(icon: Icons.favorite_border, title: 'Favorites'),
              const SizedBox(height: 18),
              _sectionTitle('Shortcuts'),
              const SizedBox(height: 12),
              _menuTile(icon: Icons.storefront_outlined, title: 'Stores'),
              _menuTile(
                icon: Icons.campaign_outlined,
                title: 'Announcements',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AnnouncementView(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              _sectionTitle('Contact'),
              const SizedBox(height: 12),
              _menuTile(
                icon: Icons.headset_mic_outlined,
                title: 'Customer Service',
              ),
              _menuTile(icon: Icons.chat_bubble_outline, title: 'Feedback'),
              _menuTile(icon: Icons.help_outline, title: 'FAQs'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await context.read<AuthViewModel>().logout();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const OnboardingView(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCB8944),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 30 / 2,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF70756B),
      ),
    );
  }

  Widget _menuTile(
      {required IconData icon, required String title, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF70756B)),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 31 / 1.7,
            color: const Color(0xFF363A33),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFA0A39D)),
        onTap: onTap ?? () {},
      ),
    );
  }
}
