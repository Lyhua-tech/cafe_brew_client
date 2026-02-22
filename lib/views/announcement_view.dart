import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementView extends StatelessWidget {
  const AnnouncementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Announcements",
          style: GoogleFonts.poppins(
            color: const Color(0xFF363A33),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return _buildAnnouncementCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(int index) {
    final titles = [
      "New Store Opening!",
      "Holiday Special Discounts",
      "Try out our new Cold Brew",
      "Maintenance Notice",
    ];
    final descs = [
      "We are opening a new branch downtown. Come visit us for a free coffee!",
      "Get up to 30% off on all espresso-based drinks this weekend only.",
      "The smoothest and most refreshing cold brew is now available.",
      "Our app will be down for maintenance from 12 AM to 2 AM.",
    ];
    final times = ["2 hours ago", "5 hours ago", "1 day ago", "3 days ago"];
    final colors = [
      const Color(0xFFF3E9D2),
      const Color(0xFFE8EBE6),
      const Color(0xFFF3E9D2),
      const Color(0xFFFFE0E0),
    ];
    final icons = [
      Icons.storefront,
      Icons.local_offer,
      Icons.local_cafe,
      Icons.build,
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: const Color(0xFFE8EBE6), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: colors[index],
            radius: 24,
            child: Icon(icons[index], color: const Color(0xFFCB8944)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        titles[index],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: const Color(0xFF363A33),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      times[index],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color: const Color(0xFF91958E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  descs[index],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: const Color(0xFF70756B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
