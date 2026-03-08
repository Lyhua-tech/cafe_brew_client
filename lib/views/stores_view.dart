import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/store_service.dart';
import 'store_detail_view.dart';

class StoresView extends StatefulWidget {
  const StoresView({super.key});

  @override
  State<StoresView> createState() => _StoresViewState();
}

class _StoresViewState extends State<StoresView> {
  final StoreService _storeService = StoreService();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _allStores = [];
  List<dynamic> _filteredStores = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _storeService.getStores();
      // The backend returns { "data": [...stores], "pagination": {...} }
      final items = res['data'] as List<dynamic>? ?? [];
      setState(() {
        _allStores = items;
        _filteredStores = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() => _filteredStores = _allStores);
      return;
    }
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredStores = _allStores.where((s) {
        final name = (s['name'] ?? '').toString().toLowerCase();
        final addr = (s['address'] ?? '').toString().toLowerCase();
        final city = (s['city'] ?? '').toString().toLowerCase();
        return name.contains(lowerQuery) ||
            addr.contains(lowerQuery) ||
            city.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
          "Stores",
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
      body: Column(
        children: [
          // Search Bar container
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: const Color(0xFF363A33)),
                    decoration: InputDecoration(
                      hintText: 'Search store...',
                      hintStyle: GoogleFonts.poppins(
                          color: const Color(0xFFA0A39D), fontSize: 14),
                      prefixIcon: const Icon(Icons.search,
                          color: Color(0xFFA0A39D), size: 20),
                      filled: true,
                      fillColor: Colors.white,
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8EBE6)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Color(0xFF363A33)),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),

          // Content body
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFCB8944)))
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      )
                    : _filteredStores.isEmpty
                        ? Center(
                            child: Text(
                              "No stores found",
                              style: GoogleFonts.poppins(color: Colors.black54),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: _filteredStores.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final store = _filteredStores[index];
                              final name =
                                  store['name']?.toString() ?? 'Unknown Store';
                              final address = store['address']?.toString() ??
                                  store['city']?.toString() ??
                                  'No address provided';
                              // Use imageUrl or fallback if unavailable.
                              final String? image = store['imageUrl'];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StoreDetailView(
                                        store: store as Map<String, dynamic>,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: const Color(0xFFE8EBE6)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.02),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                        ),
                                        child: Container(
                                          width: 100,
                                          height: 110,
                                          color: const Color(0xFFF9FAF8),
                                          child: (image != null &&
                                                  image.isNotEmpty)
                                              ? Image.network(
                                                  image,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Icon(
                                                          Icons.storefront,
                                                          color: Colors.grey,
                                                          size: 40),
                                                )
                                              : const Icon(Icons.storefront,
                                                  color: Colors.grey, size: 40),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      name,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                            0xFF363A33),
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 14,
                                                      color: Color(0xFFCDCED2)),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                address,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color:
                                                      const Color(0xFF70756B),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
