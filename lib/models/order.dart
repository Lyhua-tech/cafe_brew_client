class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final Map<String, dynamic>? customization;
  final List<dynamic>? addOns;
  final String? notes;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.customization,
    this.addOns,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? 'Unknown Item',
      productImage: json['productImage'] ?? '',
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unitPrice'] ?? json['price'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? json['total'] ?? 0).toDouble(),
      customization: json['customization'] as Map<String, dynamic>?,
      addOns: json['addOns'] as List<dynamic>?,
      notes: json['notes'],
    );
  }
}

class Order {
  final String id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final List<OrderItem> items;
  final double subtotal;
  final double total;
  final double tax;
  final double deliveryFee;
  final double discount;
  final String? paymentMethod;
  final String? deliveryAddress;
  final DateTime? createdAt;
  final DateTime? estimatedReadyTime;
  final DateTime? pickedUpAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    this.items = const [],
    this.subtotal = 0,
    this.total = 0,
    this.tax = 0,
    this.deliveryFee = 0,
    this.discount = 0,
    this.paymentMethod,
    this.deliveryAddress,
    this.createdAt,
    this.estimatedReadyTime,
    this.pickedUpAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List?;
    final parsedItems = rawItems != null
        ? rawItems
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList()
        : <OrderItem>[];

    return Order(
      id: json['_id'] ?? json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      status: json['status'] ?? 'pending',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      items: parsedItems,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'],
      deliveryAddress: json['deliveryAddress'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      estimatedReadyTime: json['estimatedReadyTime'] != null
          ? DateTime.tryParse(json['estimatedReadyTime'])
          : null,
      pickedUpAt: json['pickedUpAt'] != null
          ? DateTime.tryParse(json['pickedUpAt'])
          : null,
    );
  }
}
