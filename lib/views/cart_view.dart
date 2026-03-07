import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../services/checkout_service.dart';
import '../services/address_service.dart';
import 'order_placed_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CheckoutService _checkoutService = CheckoutService();
  final AddressService _addressService = AddressService();

  bool _isProcessing = false;
  String _selectedPickupTime = 'Now';
  String _selectedPaymentMethod = 'ACLEDA Bank';

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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          "CAMKO",
          style: GoogleFonts.poppins(
            color: const Color(0xFF363A33),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox.shrink(),
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
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: _buildProgressBar(),
                  ),
                  const Spacer(),
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
                  const Spacer(),
                ],
              ),
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                color: const Color(0xFFCB8944),
                onRefresh: vm.loadCart,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // White Header Section for Progress Bar
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(bottom: 24, top: 16),
                        child: _buildProgressBar(),
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pickup Time
                            _sectionHeader('Pickup Time'),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildTimeChip('Now'),
                                const SizedBox(width: 12),
                                _buildTimeChip('5 min'),
                                const SizedBox(width: 12),
                                _buildTimeChip('30 min'),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Summary
                            _sectionHeader('Summary'),
                            const SizedBox(height: 16),

                            ...cart.items.map((item) =>
                                _buildCartItemCard(context, item, vm)),

                            const SizedBox(height: 24),

                            // Subtotal section
                            _sectionHeader('Subtotal'),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAF8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Apply Voucher",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: const Color(0xFF363A33),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      size: 16, color: Colors.grey),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Payment
                            _sectionHeader('Payment'),
                            const SizedBox(height: 16),
                            _buildPaymentMethodOption(
                                'ACLEDA Bank',
                                'Scan to pay',
                                'assets/images/acleda_logo.png' // Placeholders until real assets
                                ),
                            const SizedBox(height: 12),
                            _buildPaymentMethodOption(
                                'ABA Mobile',
                                'Scan to pay',
                                'assets/images/aba_logo.png' // Placeholders until real assets
                                ),

                            const SizedBox(height: 48),

                            // Totals
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "\$${cart.total.toStringAsFixed(2)}",
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Check Out Button
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _isProcessing
                                    ? null
                                    : () => _handleCheckout(context, vm),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFCB8944),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isProcessing
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2))
                                    : Text(
                                        "CHECK OUT",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
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
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF363A33),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProgressNode('MENU', true, true),
          Expanded(child: _buildProgressLine(true)),
          _buildProgressNode('CART', true, false),
          Expanded(child: _buildProgressLine(false)),
          _buildProgressNode('CHECKOUT', false, false),
        ],
      ),
    );
  }

  Widget _buildProgressNode(String label, bool isCompleted, bool isFirst) {
    Color nodeColor =
        isCompleted ? const Color(0xFFC78740) : const Color(0xFFB5B5B5);

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: nodeColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isCompleted) {
    return Container(
      height: 2,
      color: isCompleted ? const Color(0xFFC78740) : const Color(0xFFE0E0E0),
      margin: const EdgeInsets.only(bottom: 24),
    );
  }

  Widget _buildTimeChip(String label) {
    bool isSelected = _selectedPickupTime == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPickupTime = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFCB8944)
                  : const Color(0xFFEFEFEF),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFFCB8944)
                  : const Color(0xFF363A33),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItemCard(
      BuildContext context, CartItem item, CartViewModel vm) {
    final product = item.product;
    final name = product?.name ?? 'Unknown item';
    final imageUrl = product?.primaryImage ?? '';
    final isAvailable = product?.isAvailable ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
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
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: const Color(0xFF676767)),
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
                      const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${item.total.toStringAsFixed(2)}",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          "x${item.quantity}",
                          style: GoogleFonts.inter(
                              color: const Color(0xFF707070),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: -24,
            left: -24,
            child: GestureDetector(
              onTap: () {
                vm.removeItem(item.id);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEEEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(
      String title, String subtitle, String iconPath) {
    bool isSelected = _selectedPaymentMethod == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAF8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFCB8944) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF142959), // Example ABA / ACLEDA color
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(
                  title.contains('ABA')
                      ? Icons.account_balance_wallet
                      : Icons.account_balance,
                  color: Colors.white), // Placeholder for real image
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: const Color(0xFF8A8A8A)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCheckout(BuildContext context, CartViewModel vm) async {
    setState(() => _isProcessing = true);
    try {
      // 1. Ensure user has an address on file and patch it to the cart
      // Bypass the validation requirement since we support local pickup
      await _addressService.ensurePickupAddressForCart();

      // 2. Validate Cart
      bool isValid = await vm.validateCheckout();
      if (!isValid) {
        throw Exception(
            "Cart validation failed (Some items may be out of stock)");
      }

      // 3. Create the backend order
      final checkoutRes = await _checkoutService.createCheckout();
      final checkoutId = checkoutRes['_id'] ?? checkoutRes['id'];

      if (checkoutId != null) {
        // 4. Confirm payment to finalize the order
        await _checkoutService.confirmCheckout(checkoutId, 'Credit Card');
      } else {
        throw Exception("Failed to retrieve checkout session ID");
      }

      if (!context.mounted) return;
      await vm.clearCart();

      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderPlacedView(),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}
