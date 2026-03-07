import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/order_viewmodel.dart';
import '../models/order.dart';
import 'order_detail_view.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().fetchOrders(); // Default fetches all
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAF8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 14),
              tabs: const [
                Tab(child: Text("Order")),
                Tab(child: Text("Transaction")),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<OrderViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFCB8944)),
            );
          }

          if (vm.errorMessage != null && vm.orders.isEmpty) {
            return Center(child: Text(vm.errorMessage!));
          }

          if (vm.orders.isEmpty) {
            return Center(
              child: Text(
                "No past orders found.",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(vm.orders),
              _buildOrderList(vm
                  .orders), // You can adapt this for transactions specifically later if needed
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderItem(order);
      },
    );
  }

  Widget _buildOrderItem(Order order) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final fallbackImage =
        'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=3537&auto=format&fit=crop';
    final imageUrl = firstItem?.productImage.isNotEmpty == true
        ? firstItem!.productImage
        : fallbackImage;

    final dateStr = order.createdAt != null
        ? DateFormat('d MMMM').format(order.createdAt!)
        : '';

    // E.g. "Cappuccino x1"
    final summaryText = firstItem != null
        ? "${firstItem.productName} x${firstItem.quantity}"
        : "Order ${order.orderNumber}";

    // Capitalize status
    final displayStatus =
        order.status == 'completed' || order.status == 'picked_up'
            ? "Order delivered"
            : "Order ${order.status}";

    final promptText =
        order.status == 'completed' || order.status == 'picked_up'
            ? "Your drink is Completed!"
            : "Your order is pending";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailView(order: order),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Order Highlights
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayStatus,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            promptText,
                            style: GoogleFonts.inter(
                                color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            dateStr,
                            style: GoogleFonts.inter(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order summary",
                            style: GoogleFonts.inter(
                                color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            summaryText,
                            style: GoogleFonts.inter(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total price paid",
                            style: GoogleFonts.inter(
                                color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            "\$${order.total.toStringAsFixed(2)}",
                            style: GoogleFonts.inter(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Logic to reorder
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Color(0xFFE8EBE6)),
                    ),
                    child: Text(
                      "Reorder",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF363A33)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(50, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Color(0xFFE8EBE6)),
                  ),
                  child: const Icon(Icons.more_vert, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
