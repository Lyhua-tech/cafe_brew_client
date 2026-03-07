import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order.dart';

class OrderDetailView extends StatelessWidget {
  final Order order;

  const OrderDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // E.g. "Order Completed" vs "Order Pending"
    final displayStatus =
        order.status == 'completed' || order.status == 'picked_up'
            ? "Order Completed"
            : "Order Pending";

    final promptText =
        order.status == 'completed' || order.status == 'picked_up'
            ? "Your order has been picked up"
            : "Your order is being processed";

    // Grab first image for the top banner if available
    final fallbackImage =
        'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=3537&auto=format&fit=crop';
    final topImageUrl =
        order.items.isNotEmpty && order.items.first.productImage.isNotEmpty
            ? order.items.first.productImage
            : fallbackImage;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Orders",
          style: GoogleFonts.poppins(
            color: const Color(0xFF363A33),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Top Image Header
            Container(
              width: 180,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(topImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayStatus,
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              promptText,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Items List
            ...order.items.map((item) => _buildItemCard(item)),

            const SizedBox(height: 24),
            _buildPriceRow("Subtotal", order.subtotal),
            const SizedBox(height: 12),
            _buildPriceRow("Total", order.total, isBold: true),

            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Payment",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentCard(order),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(OrderItem item) {
    final imageUrl = item.productImage.isNotEmpty
        ? item.productImage
        : 'https://images.unsplash.com/photo-1541167760496-1628856ab772';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF4F7F2), width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${item.unitPrice.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "x${item.quantity}",
                      style:
                          GoogleFonts.inter(fontSize: 14, color: Colors.grey),
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

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: isBold ? Colors.black : Colors.grey[700],
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(Order order) {
    final paymentMethod = order.paymentMethod ?? 'Cash';
    // Simplified icons for payment methods (could use assets if available)
    IconData iconData = Icons.money;
    Color iconBg = Colors.green;
    String methodName = paymentMethod;

    if (paymentMethod.toUpperCase() == 'ABA') {
      iconData = Icons.account_balance;
      iconBg = Colors.blue[900]!;
      methodName = 'ABA Bank';
    } else if (paymentMethod.toUpperCase() == 'ACLEDA') {
      iconData = Icons.qr_code_2;
      iconBg = Colors.blue[800]!;
      methodName = 'ACLEDA Bank';
    } else if (paymentMethod.toUpperCase() == 'WING') {
      iconData = Icons.monetization_on;
      iconBg = Colors.lightGreen;
      methodName = 'Wing';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  methodName,
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Order ${order.orderNumber}",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            "-\$${order.total.toStringAsFixed(2)}",
            style: GoogleFonts.inter(
                fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
