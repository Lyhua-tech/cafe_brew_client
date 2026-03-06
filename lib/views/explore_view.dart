import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_detail_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().init();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox.shrink(),
        title: Text(
          'Explore',
          style: GoogleFonts.poppins(
            color: const Color(0xFF363A33),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) =>
                  context.read<ProductViewModel>().onSearchChanged(v),
              style: GoogleFonts.poppins(
                  fontSize: 14, color: const Color(0xFF363A33)),
              decoration: InputDecoration(
                hintText: 'Search drinks, food...',
                hintStyle: GoogleFonts.poppins(
                    color: const Color(0xFFA0A39D), fontSize: 14),
                prefixIcon: const Icon(Icons.search,
                    color: Color(0xFFA0A39D), size: 22),
                suffixIcon: vm.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close,
                            color: Color(0xFFA0A39D), size: 20),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ProductViewModel>().onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF9FAF8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE8EBE6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE8EBE6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFCB8944)),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // ── Category chips ───────────────────────────────────────────────
          if (vm.categories.isNotEmpty)
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: vm.categories.length + 1, // +1 for "All"
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final isAll = i == 0;
                  final category = isAll ? null : vm.categories[i - 1];
                  final isSelected = isAll
                      ? vm.selectedCategoryId == null
                      : vm.selectedCategoryId == category!.id;

                  return GestureDetector(
                    onTap: () => context
                        .read<ProductViewModel>()
                        .selectCategory(category?.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFCB8944)
                            : const Color(0xFFF5F0E8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isAll ? 'All' : category!.name,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF70756B),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 16),

          // ── Products grid ─────────────────────────────────────────────────
          Expanded(
            child: _buildProductsGrid(vm),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(ProductViewModel vm) {
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFCB8944)),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 56, color: Color(0xFFA0A39D)),
              const SizedBox(height: 16),
              Text(
                vm.errorMessage!,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: const Color(0xFF70756B)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.read<ProductViewModel>().refresh(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCB8944),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Retry',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.coffee_outlined,
                size: 56, color: Color(0xFFD4C4A8)),
            const SizedBox(height: 16),
            Text(
              vm.searchQuery.isNotEmpty
                  ? 'No results for "${vm.searchQuery}"'
                  : 'No products available',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF70756B)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFCB8944),
      onRefresh: () => context.read<ProductViewModel>().refresh(),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.78,
        ),
        itemCount: vm.products.length,
        itemBuilder: (_, i) => _ProductCard(product: vm.products[i]),
      ),
    );
  }
}

// ─── Product card ─────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailView(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EBE6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: product.primaryImage.isNotEmpty
                    ? Image.network(
                        product.primaryImage,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: const Color(0xFF363A33),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.formattedPrice,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: const Color(0xFFCB8944),
                        ),
                      ),
                      if (product.rating != null)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 14, color: Color(0xFFFFC107)),
                            const SizedBox(width: 2),
                            Text(
                              product.rating!.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                  fontSize: 11, color: const Color(0xFF70756B)),
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (product.preparationTime != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 12, color: Color(0xFFA0A39D)),
                        const SizedBox(width: 3),
                        Text(
                          '${product.preparationTime} min',
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: const Color(0xFFA0A39D)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF9FAF8),
      child: const Center(
        child: Icon(Icons.coffee, color: Color(0xFFD4C4A8), size: 40),
      ),
    );
  }
}
