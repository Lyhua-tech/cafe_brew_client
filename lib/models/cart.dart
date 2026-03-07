import 'product.dart';

class CartItem {
  final String id;
  final String productId;
  final Product? product;
  final int quantity;
  final double price;
  final double total;

  CartItem({
    required this.id,
    required this.productId,
    this.product,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    Product? parsedProduct;
    String pId = '';

    if (json['product'] != null && json['product'] is Map) {
      parsedProduct = Product.fromJson(json['product'] as Map<String, dynamic>);
      pId = parsedProduct.id;
    } else if (json['productId'] != null && json['productId'] is Map) {
      parsedProduct =
          Product.fromJson(json['productId'] as Map<String, dynamic>);
      pId = parsedProduct.id;
    }

    if (pId.isEmpty && json['productId'] is String) {
      pId = json['productId'];
    }

    return CartItem(
      id: json['_id'] ?? json['id'] ?? '',
      productId: pId,
      product: parsedProduct,
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? json['unitPrice'] ?? 0).toDouble(),
      total: (json['total'] ?? json['totalPrice'] ?? 0).toDouble(),
    );
  }
}

class Cart {
  final String id;
  final List<CartItem> items;
  final String? addressId;
  final String? notes;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double discount;
  final double total;

  Cart({
    required this.id,
    this.items = const [],
    this.addressId,
    this.notes,
    this.subtotal = 0,
    this.tax = 0,
    this.deliveryFee = 0,
    this.discount = 0,
    this.total = 0,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List?;
    final items = rawItems != null
        ? rawItems
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList()
        : <CartItem>[];

    double jsonSubtotal = (json['subtotal'] ?? 0).toDouble();
    if (jsonSubtotal == 0 && items.isNotEmpty) {
      jsonSubtotal = items.fold(0.0, (sum, item) => sum + item.total);
    }

    double jsonTax = (json['tax'] ?? 0).toDouble();
    double jsonDeliveryFee = (json['deliveryFee'] ?? 0).toDouble();
    double jsonDiscount = (json['discount'] ?? 0).toDouble();

    double jsonTotal = (json['total'] ?? json['totalPrice'] ?? 0).toDouble();
    if (jsonTotal == 0 && jsonSubtotal > 0) {
      jsonTotal = jsonSubtotal + jsonTax + jsonDeliveryFee - jsonDiscount;
    }

    return Cart(
      id: json['_id'] ?? json['id'] ?? '',
      items: items,
      addressId: json['addressId'],
      notes: json['notes'],
      subtotal: jsonSubtotal,
      tax: jsonTax,
      deliveryFee: jsonDeliveryFee,
      discount: jsonDiscount,
      total: jsonTotal,
    );
  }
}

class CartSummary {
  final int itemCount;
  final double subtotal;
  final double discount;
  final double tax;
  final double deliveryFee;
  final double total;

  CartSummary({
    this.itemCount = 0,
    this.subtotal = 0,
    this.discount = 0,
    this.tax = 0,
    this.deliveryFee = 0,
    this.total = 0,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) {
    return CartSummary(
      itemCount: json['itemCount'] ?? 0,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}

class CartValidation {
  final bool isValid;
  final List<dynamic> issues;

  CartValidation({
    required this.isValid,
    this.issues = const [],
  });

  factory CartValidation.fromJson(Map<String, dynamic> json) {
    return CartValidation(
      isValid: json['isValid'] ?? false,
      issues: json['issues'] ?? [],
    );
  }
}
