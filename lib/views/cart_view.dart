import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../viewmodels/cart_viewmodel.dart';
import 'payment_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartViewModel>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox.shrink(),
        title: Text(
          "Cart",
          style: GoogleFonts.poppins(
            color: const Color(0xFF363A33),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<CartViewModel>(
            builder: (context, vm, _) {
              if (vm.cart?.items.isNotEmpty == true) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Clear Cart'),
                        content: const Text(
                            'Are you sure you want to clear your cart?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              vm.clearCart();
                            },
                            child: const Text('Clear',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<CartViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFCB8944)));
          }

          if (vm.errorMessage != null && vm.cart == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      vm.errorMessage!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: vm.loadCart,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCB8944)),
                      child: const Text('Retry',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final cart = vm.cart;

          if (cart == null || cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    "Your cart is empty",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Explore our menu to add items.",
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                color: const Color(0xFFCB8944),
                onRefresh: vm.loadCart,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  children: [
                    const SizedBox(height: 16),
                    ...cart.items
                        .map((item) => _buildCartItem(context, item, vm)),
                    const SizedBox(height: 24),

                    // Voucher Placeholder
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAF8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer_outlined,
                              color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Apply Voucher",
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Payment Placeholders
                    _buildPaymentOption("Apple Pay", Icons.apple),
                    const SizedBox(height: 12),
                    _buildPaymentOption("Visa **** 1234", Icons.credit_card),

                    const SizedBox(height: 48),
                    _buildPriceRow("Subtotal", cart.subtotal),
                    _buildPriceRow("Tax", cart.tax),
                    _buildPriceRow("Delivery Fee", cart.deliveryFee),
                    if (cart.discount > 0)
                      _buildPriceRow("Discount", -cart.discount,
                          isDiscount: true),

                    const SizedBox(height: 120), // Padding for checkout bar
                  ],
                ),
              ),
              if (vm.isActionLoading)
                Container(
                  color: Colors.white.withValues(alpha: 0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFFCB8944)),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<CartViewModel>(
        builder: (context, vm, _) {
          final cart = vm.cart;
          if (cart == null || cart.items.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${cart.total.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentView(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCB8944),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    "CHECK OUT",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount,
      {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: Colors.black54)),
          Text(
            isDiscount
                ? "-\$${amount.abs().toStringAsFixed(2)}"
                : "\$${amount.toStringAsFixed(2)}",
            style: GoogleFonts.inter(
              color: isDiscount ? Colors.green : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, CartViewModel vm) {
    final product = item.product;
    final name = product?.name ?? 'Unknown item';
    final imageUrl = product?.primaryImage ?? '';
    final isAvailable = product?.isAvailable ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF4F7F2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.fastfood, color: Colors.grey),
                    )
                  : const Icon(Icons.fastfood, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isAvailable)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Text(
                      'Unavailable',
                      style: GoogleFonts.inter(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${item.total.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Row(
                      children: [
                        // Minus button
                        GestureDetector(
                          onTap: () {
                            if (item.quantity == 1) {
                              vm.removeItem(item.id);
                            } else {
                              vm.updateQuantity(item.id, item.quantity - 1);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.remove, size: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "${item.quantity}",
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Add button
                        GestureDetector(
                          onTap: isAvailable
                              ? () =>
                                  vm.updateQuantity(item.id, item.quantity + 1)
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? const Color(0xFFCB8944)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
