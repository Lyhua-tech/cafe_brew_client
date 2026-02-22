import '../models/coffee.dart';

class ApiService {
  Future<List<Coffee>> fetchCoffees() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return [
      Coffee(
        id: '1',
        name: 'Espresso',
        description: 'Strong, concentrated coffee.',
        price: 3.0,
      ),
      Coffee(
        id: '2',
        name: 'Latte',
        description: 'Espresso with steamed milk.',
        price: 4.5,
      ),
      Coffee(
        id: '3',
        name: 'Cappuccino',
        description: 'Espresso with steamed milk foam.',
        price: 4.0,
      ),
    ];
  }
}
