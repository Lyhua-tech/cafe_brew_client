import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService _service = OrderService();

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  Order? _currentOrder;
  Order? get currentOrder => _currentOrder;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrders({String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getOrders(status: status);
      // Response shape: { items: [...], pagination: {...} }
      final items = response['items'] as List?;
      if (items != null) {
        _orders = items
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();
        // Sort descending by created date
        _orders.sort((a, b) {
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return b.createdAt!.compareTo(a.createdAt!);
        });
      } else {
        _orders = [];
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrderById(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getOrder(orderId);
      _currentOrder = Order.fromJson(response);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }
}
