import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'onboarding_view.dart';
import 'profile_edit_view.dart';
import 'order_history_view.dart';
import 'favorites_view.dart';
import 'stores_view.dart';
import 'announcement_view.dart';

class MyAccountView extends StatelessWidget {
  const MyAccountView({super.key});

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 12, top: 24),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF70756B),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    bool isTop = false,
    bool isBottom = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTop ? 14 : 0),
          topRight: Radius.circular(isTop ? 14 : 0),
          bottomLeft: Radius.circular(isBottom ? 14 : 0),
          bottomRight: Radius.circular(isBottom ? 14 : 0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isTop ? 14 : 0),
            topRight: Radius.circular(isTop ? 14 : 0),
            bottomLeft: Radius.circular(isBottom ? 14 : 0),
            bottomRight: Radius.circular(isBottom ? 14 : 0),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Icon(icon, color: const Color(0xFF91958E), size: 22),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF363A33),
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Color(0xFFCDCED2)),
                  ],
                ),
              ),
              if (!isBottom)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE8EBE6),
                  indent: 54,
                  endIndent: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final authVm = context.watch<AuthViewModel>();
    final avatarUrl = vm.profile?.avatar ?? authVm.currentUser?.avatar;
    final name = vm.profile?.name ?? authVm.currentUser?.name ?? 'User';
    final email = vm.profile?.email ?? authVm.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF363A33)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFFE8EBE6),
                    backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : const AssetImage('assets/images/home_banner.png')
                            as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF363A33),
                          ),
                        ),
                        Text(
                          email,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF91958E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Personal Section
            _buildSectionHeader("Personal"),
            _buildMenuItem(
              title: "My Account",
              icon: Icons.person_outline,
              isTop: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileEditView()),
              ),
            ),
            _buildMenuItem(
              title: "History",
              icon: Icons.history,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderHistoryView()),
              ),
            ),
            _buildMenuItem(
              title: "Favorites",
              icon: Icons.favorite_border,
              isBottom: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesView()),
              ),
            ),

            // Shortcuts Section
            _buildSectionHeader("Shortcuts"),
            _buildMenuItem(
              title: "Stores",
              icon: Icons.storefront_outlined,
              isTop: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StoresView()),
              ),
            ),
            _buildMenuItem(
              title: "Announcements",
              icon: Icons.campaign_outlined,
              isBottom: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnnouncementView()),
              ),
            ),

            // Contact Section
            _buildSectionHeader("Contact"),
            _buildMenuItem(
              title: "Customer Service",
              icon: Icons.headset_mic_outlined,
              isTop: true,
              onTap: () {},
            ),
            _buildMenuItem(
              title: "Feedback",
              icon: Icons.chat_bubble_outline,
              isBottom: true,
              onTap: () {},
            ),

            const SizedBox(height: 32),

            // Sign Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
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
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(
                    'Sign Out',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE25839),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
