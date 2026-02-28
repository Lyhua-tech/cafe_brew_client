import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/favorites_viewmodel.dart';
import 'cart_view.dart';

class ProductDetailView extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<FavoritesViewModel>(
            builder: (context, favoritesVm, child) {
              final isFav = favoritesVm.isFavorite(product['id']);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav
                      ? const Color(0xFFE25839)
                      : Colors.black, // Red if liked
                ),
                onPressed: () {
                  favoritesVm.toggleFavorite(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav ? "Removed from Favorites" : "Added to Favorites",
                      ),
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
            // Product Image Placeholder
            Container(
              height: 250,
              width: double.infinity,
              color: const Color(0xFFF9FAF8),
              child: const Icon(Icons.fastfood, size: 80, color: Colors.grey),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product['name'] ?? "Product Name",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF363A33),
                          ),
                        ),
                      ),
                      Text(
                        product['price'] ?? "\$0.00",
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFCB8944),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Rating Placeholder
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "4.8 (120 reviews)",
                        style: GoogleFonts.inter(color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Description",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF363A33),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "A delicious treat perfect for any time of the day. Enjoy the rich flavors and high-quality ingredients made just for you.",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartView()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCB8944),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Add to Cart",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
