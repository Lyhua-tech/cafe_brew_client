import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreDetailView extends StatelessWidget {
  final Map<String, dynamic> store;

  const StoreDetailView({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final String name = store['name']?.toString() ?? 'Store Details';
    final String? headerImage = store['imageUrl'];
    final List<dynamic> imagesList = store['images'] ?? [];
    final List<String> specImages = [];
    for (var img in imagesList) {
      if (img != null && img.toString().isNotEmpty) {
        specImages.add(img.toString());
      }
    }

    // Add placeholder fallback images if spec images are empty to match mockup
    if (specImages.isEmpty) {
      specImages.addAll([
        'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&q=80&w=400',
        'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?auto=format&fit=crop&q=80&w=400',
        'https://images.unsplash.com/photo-1625341399622-dfad40da9556?auto=format&fit=crop&q=80&w=400',
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&q=80&w=400',
      ]);
    }

    final String address = store['address']?.toString() ??
        store['city']?.toString() ??
        'No address provided';
    final String phone =
        store['phone']?.toString() ?? '0964104282'; // Fallback to mockup phone
    final String hours = _getFormattedHours(store['openingHours']);
    final bool isOpenNow = store['isOpenNow'] == true;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Color(0xFF363A33)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          name,
          style: GoogleFonts.poppins(
            color: const Color(0xFF363A33),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF363A33)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Image
            Container(
              height: 280,
              width: double.infinity,
              color: const Color(0xFFF9FAF8),
              child: (headerImage != null && headerImage.isNotEmpty)
                  ? Image.network(
                      headerImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildFallbackHeaderImage(),
                    )
                  : _buildFallbackHeaderImage(),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spec Section
                  Text(
                    "Spec",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF363A33),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Spec Images Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: specImages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0, // Square images
                    ),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: const Color(0xFFF9FAF8),
                          child: (specImages[index].startsWith('http'))
                              ? Image.network(
                                  specImages[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image,
                                      color: Colors.grey),
                                )
                              : Image.asset(
                                  specImages[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image,
                                      color: Colors.grey),
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Google Map Section Title
                  Text(
                    "Google Map",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF363A33),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Map Placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F4),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://maps.googleapis.com/maps/api/staticmap?center=11.5564,104.9282&zoom=14&size=600x300&key=YOUR_API_KEY_HERE'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.map,
                              size: 60,
                              color: const Color(0xFFCDCED2)
                                  .withValues(alpha: 0.5)),
                          // Fallback map image if the network URL is invalid (it is invalid without API key)
                          // We'll just layer an image layout
                          Image.network(
                            'https://www.mapquestapi.com/staticmap/v5/map?key=1&center=11.5564,104.9282&zoom=13&size=600,300@2x',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                                child: Icon(Icons.location_on,
                                    size: 40, color: Color(0xFFCB8944))),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Store Info Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF363A33),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phone,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF91958E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _buildActionButton(Icons.chat_bubble_outline),
                          const SizedBox(width: 8),
                          _buildActionButton(Icons.phone_outlined),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Hours
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 18, color: Color(0xFF91958E)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          hours,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF70756B),
                          ),
                        ),
                      ),
                      Text(
                        isOpenNow ? "OPEN NOW" : "CLOSED NOW",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF363A33),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 18, color: Color(0xFF91958E)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          address,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF70756B),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // More Details Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(
                            color: Color(0xFFE8EBE6), width: 1.5),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'More details',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF363A33),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackHeaderImage() {
    return Image.asset(
      'assets/images/home_banner.png',
      fit: BoxFit.cover,
    );
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EBE6)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Icon(icon, size: 20, color: const Color(0xFF363A33)),
        ),
      ),
    );
  }

  String _getFormattedHours(dynamic openingHours) {
    if (openingHours == null) return '08:30 AM - 08:00 PM';

    if (openingHours is Map) {
      final now = DateTime.now();
      final days = [
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
        'sunday'
      ];
      final todayStr = days[now.weekday - 1];

      final todayHours = openingHours[todayStr];
      if (todayHours is Map) {
        final open = todayHours['open']?.toString() ?? '08:00';
        final close = todayHours['close']?.toString() ?? '20:00';
        return '$open - $close';
      }
      return '08:30 AM - 08:00 PM';
    }

    final str = openingHours.toString();
    if (str.contains('{') && str.contains('}')) {
      return '08:30 AM - 08:00 PM';
    }
    return str;
  }
}
