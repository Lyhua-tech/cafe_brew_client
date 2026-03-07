import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_layout_view.dart';
import 'order_history_view.dart';

class OrderPlacedView extends StatelessWidget {
  const OrderPlacedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: GoogleFonts.poppins(
            color: const Color(0xFF363A33),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainLayoutView()),
              (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // White Header Section for Progress Bar and Top Image
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 32, top: 16),
              child: Column(
                children: [
                  _buildProgressBar(),
                  const SizedBox(height: 32),
                  // Order graphic
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/home_banner.png', // Fallback or mock image
                      width: 160,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderHistoryView(),
                        ),
                      );
                    },
                    child: Text(
                      "Track your order >",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Your order has picked up",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildOrderItemsMock(context),

                  const SizedBox(height: 32),

                  _buildInfoCard(
                    icon: Icons.location_on_outlined,
                    title: "Come to pickup here",
                    subtitle: "CAMKO - 123 Main St, Apt 4B",
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                      icon: Icons.credit_card, // Placeholder for icon
                      title: "Payment from",
                      subtitle: "Mastercard - Daniel J...",
                      imagePath:
                          'assets/images/cb_logo.png' // Placeholders until real assets
                      ),

                  const SizedBox(height: 32),

                  _buildPriceRow("Subtotal", 56.27),
                  _buildPriceRow("Coupon", -17.4, isDiscount: true),
                  _buildPriceRow("Delivery Charges", 3.99, isAddition: true),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF363A33),
                        ),
                      ),
                      Text(
                        "\$32.12", // Mock value mapping
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF363A33),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60), // Bottom padding
                ],
              ),
            ),
          ],
        ),
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
          Expanded(child: _buildProgressLine(true)),
          _buildProgressNode('CHECKOUT', true, false), // All complete!
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

  Widget _buildOrderItemsMock(BuildContext context) {
    return Container(
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
      child: Row(
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
              child: Image.asset(
                'assets/images/cold_brew.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pepperoni Cheese Pizza", // Mock
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: const Color(0xFF676767)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$12.99",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "x2",
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
    );
  }

  Widget _buildInfoCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      String? imagePath}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: imagePath == null
                  ? Colors.transparent
                  : const Color(0xFF142959),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: imagePath != null
                ? const Icon(Icons.account_balance,
                    color: Colors.white, size: 20)
                : Icon(icon, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: const Color(0xFF8A8A8A)),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF363A33)),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount,
      {bool isDiscount = false, bool isAddition = false}) {
    String prefix = isDiscount ? "-" : (isAddition ? "+" : "");
    String suffix = amount.abs().toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.inter(color: Colors.black87, fontSize: 14)),
          Text(
            "$prefix$suffix",
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
