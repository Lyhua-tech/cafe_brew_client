import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';

class ProductDetailView extends StatelessWidget {
  final Product product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<FavoritesViewModel>(
            builder: (context, favVm, _) {
              final isFav = favVm.isFavorite(product.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? const Color(0xFFE25839) : Colors.black,
                ),
                onPressed: () {
                  favVm.toggleFavorite(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFav
                          ? 'Removed from Favorites'
                          : 'Added to Favorites'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product image ─────────────────────────────────────────────
            SizedBox(
              height: 260,
              width: double.infinity,
              child: product.primaryImage.isNotEmpty
                  ? Image.network(
                      product.primaryImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagePlaceholder(),
                    )
                  : _imagePlaceholder(),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Name & Price ────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF363A33),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        product.formattedPrice,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFCB8944),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ── Rating, prep time & category ───────────────────────
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      if (product.rating != null)
                        _chip(
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFFFFC107),
                          label:
                              '${product.rating!.toStringAsFixed(1)} (${product.reviewCount ?? 0})',
                        ),
                      if (product.preparationTime != null)
                        _chip(
                          icon: Icons.access_time_rounded,
                          label: '${product.preparationTime} min',
                        ),
                      if (product.categoryName != null)
                        _chip(
                          icon: Icons.category_outlined,
                          label: product.categoryName!,
                        ),
                    ],
                  ),

                  // ── Tags ───────────────────────────────────────────────
                  if (product.tags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: product.tags
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F0E8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '#$t',
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: const Color(0xFF9A7240)),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  // ── Description ────────────────────────────────────────
                  if (product.description != null &&
                      product.description!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF363A33),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF70756B),
                        height: 1.6,
                      ),
                    ),
                  ],

                  // ── Availability badge ─────────────────────────────────
                  if (!product.isAvailable) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBE8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Currently unavailable',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFFD32F2F),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],

                  const SizedBox(height: 100), // space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          height: 54,
          child: Consumer<CartViewModel>(
            builder: (context, cartVm, _) {
              final isLoading = cartVm.isActionLoading;

              return ElevatedButton(
                onPressed: product.isAvailable && !isLoading
                    ? () async {
                        try {
                          await cartVm.addToCart(product, 1);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to cart'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          // Optionally, navigate to Cart automatically
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => const CartView()));
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to add to cart: $e'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCB8944),
                  disabledBackgroundColor: const Color(0xFFD4C4A8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        product.isAvailable ? 'Add to Cart' : 'Unavailable',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFF9FAF8),
      child: const Center(
        child: Icon(Icons.coffee, size: 80, color: Color(0xFFD4C4A8)),
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    Color iconColor = const Color(0xFF91958E),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: const Color(0xFF70756B)),
          ),
        ],
      ),
    );
  }
}
