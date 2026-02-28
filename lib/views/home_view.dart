import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          "Hi L.Hua",
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
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        'assets/images/home_banner.png',
                      ), // Placeholder
                      backgroundColor: Color(0xFFE8EBE6),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildAnnouncementCard(
                      title: "🎉 Order Out for Delivery!",
                      description:
                          "Your food is on the move! Track your order for real-time updates.",
                      buttonText: "View",
                      headerColor: const Color(0xFFE7D1A0),
                    ),
                    const SizedBox(height: 16),
                    _buildAnnouncementCard(
                      title: "🎉 Order Out for Delivery!",
                      description:
                          "Your food is on the move! Track your order for real-time updates.",
                      buttonText: "Order",
                      headerColor: const Color(0xFFADC4A0),
                    ),
                    const SizedBox(height: 16),
                    _buildAnnouncementCard(
                      title: "🎉 Order Out for Delivery!",
                      description:
                          "Your food is on the move! Track your order for real-time updates.",
                      buttonText: "View",
                      headerColor: const Color(0xFFCB8944),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
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
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF363A33),
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
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
                            fontSize: 15,
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

  Widget _buildAnnouncementCard({
    required String title,
    required String description,
    required String buttonText,
    required Color headerColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 140, // Simulated image height
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            // Optional: you can put an Image here if there's an actual image for the announcement.
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: const Color(0xFF363A33),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: const Color(0xFF60655C),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E9D2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    buttonText,
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
    );
  }
}
