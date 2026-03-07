import '../models/product.dart';
import 'api_client.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();

  /// GET /products — paginated list with optional filters
  Future<List<Product>> getProducts({
    String? categoryId,
    String? search,
    bool? isFeatured,
    bool? isBestSelling,
    bool? isAvailable,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (categoryId != null) query['categoryId'] = categoryId;
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (isFeatured != null) query['isFeatured'] = isFeatured.toString();
    if (isBestSelling != null) {
      query['isBestSelling'] = isBestSelling.toString();
    }
    if (isAvailable != null) query['isAvailable'] = isAvailable.toString();
    if (minPrice != null) query['minPrice'] = minPrice;
    if (maxPrice != null) query['maxPrice'] = maxPrice;

    final response = await _apiClient.get('/products', queryParameters: query);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _parseProductList(response.data);
  }

  /// GET /products/search?q=...
  Future<List<Product>> searchProducts(String query,
      {String? categoryId}) async {
    final params = <String, dynamic>{'q': query};
    if (categoryId != null) params['categoryId'] = categoryId;

    final response =
        await _apiClient.get('/products/search', queryParameters: params);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _parseProductList(response.data);
  }

  /// GET /products/:id
  Future<Product> getProduct(String id) async {
    final response = await _apiClient.get('/products/$id');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return Product.fromJson(_unwrapMap(response.data));
  }

  /// GET /categories
  Future<List<Category>> getCategories() async {
    final response = await _apiClient.get('/categories');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    final list = raw is List ? raw : (raw['categories'] ?? raw['items'] ?? []);
    return (list as List)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /categories/:id/products
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final response = await _apiClient.get('/categories/$categoryId/products');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _parseProductList(response.data);
  }

  /// GET /products/:id/customizations
  Future<Map<String, dynamic>> getProductCustomizations(String id) async {
    final response = await _apiClient.get('/products/$id/customizations');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /products/:id/addons
  Future<Map<String, dynamic>> getProductAddons(String id) async {
    final response = await _apiClient.get('/products/$id/addons');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /categories/slug/:slug
  Future<Category> getCategoryBySlug(String slug) async {
    final response = await _apiClient.get('/categories/slug/$slug');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return Category.fromJson(_unwrapMap(response.data));
  }

  /// GET /categories/:id
  Future<Category> getCategoryById(String id) async {
    final response = await _apiClient.get('/categories/$id');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return Category.fromJson(_unwrapMap(response.data));
  }

  /// GET /categories/:id/subcategories
  Future<List<Category>> getSubcategories(String id) async {
    final response = await _apiClient.get('/categories/$id/subcategories');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    final list = raw is List ? raw : (raw['categories'] ?? raw['items'] ?? []);
    return (list as List)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /addons
  Future<Map<String, dynamic>> getAddons() async {
    final response = await _apiClient.get('/addons');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  List<Product> _parseProductList(dynamic raw) {
    final unwrapped = _unwrap(raw);
    List<dynamic> list;
    if (unwrapped is List) {
      list = unwrapped;
    } else if (unwrapped is Map) {
      list = (unwrapped['data'] ?? unwrapped['products'] ?? unwrapped['items'])
              as List? ??
          [];
    } else {
      list = [];
    }
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  dynamic _unwrap(dynamic raw) {
    if (raw is Map<String, dynamic> && raw.containsKey('data')) {
      return raw['data'];
    }
    return raw;
  }

  Map<String, dynamic> _unwrapMap(dynamic raw) {
    final u = _unwrap(raw);
    return u is Map<String, dynamic> ? u : {};
  }

  String _parseError(dynamic data) {
    if (data is Map) {
      return (data['message'] as String?) ?? 'Unknown error occurred';
    }
    return 'Unknown error occurred';
  }
}
