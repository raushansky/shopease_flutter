import 'package:flutter/foundation.dart';

class CartController extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  final List<Map<String, dynamic>> _wishlistItems = [];

  List<Map<String, dynamic>> get cartItems => List.unmodifiable(_cartItems);
  List<Map<String, dynamic>> get wishlistItems => List.unmodifiable(_wishlistItems);

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));

  double get totalAmount {
    double total = 0;
    for (var item in _cartItems) {
      if (item['checked'] == true) {
        final price = (item['price'] as num).toDouble();
        final qty = (item['quantity'] as num).toInt();
        total += price * qty;
      }
    }
    return total;
  }

  // Add Item to Cart
  void addToCart(Map<String, dynamic> product, {int qty = 1}) {
    final String id = (product['id'] ?? product['name'] ?? '').toString();
    final int index = _cartItems.indexWhere((item) => (item['id'] ?? item['name'] ?? '').toString() == id);

    if (index >= 0) {
      _cartItems[index]['quantity'] = (_cartItems[index]['quantity'] as int) + qty;
    } else {
      _cartItems.add({
        'id': id,
        'name': (product['name'] ?? product['title'] ?? 'Product').toString(),
        'price': double.tryParse((product['price'] ?? 0).toString()) ?? 0.0,
        'oldPrice': double.tryParse((product['oldPrice'] ?? 0).toString()) ?? 0.0,
        'quantity': qty,
        'image': (product['image'] ?? product['image_url'] ?? '').toString(),
        'checked': true,
      });
    }
    notifyListeners();
  }

  // Remove Item from Cart
  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  // Increase/Decrease Quantity
  void updateQuantity(int index, int delta) {
    if (index >= 0 && index < _cartItems.length) {
      final currentQty = _cartItems[index]['quantity'] as int;
      final newQty = currentQty + delta;
      if (newQty > 0) {
        _cartItems[index]['quantity'] = newQty;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Toggle Checkbox Item in Cart
  void toggleCartCheck(int index, bool? checked) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index]['checked'] = checked ?? true;
      notifyListeners();
    }
  }

  // Clear Cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // --- WISHLIST METHODS ---

  bool isWishlisted(String id) {
    return _wishlistItems.any((item) => (item['id'] ?? item['name'] ?? '').toString() == id);
  }

  void toggleWishlist(Map<String, dynamic> product) {
    final String id = (product['id'] ?? product['name'] ?? '').toString();
    final int index = _wishlistItems.indexWhere((item) => (item['id'] ?? item['name'] ?? '').toString() == id);

    if (index >= 0) {
      _wishlistItems.removeAt(index);
    } else {
      _wishlistItems.add({
        'id': id,
        'name': (product['name'] ?? product['title'] ?? 'Product').toString(),
        'price': double.tryParse((product['price'] ?? 0).toString()) ?? 0.0,
        'oldPrice': double.tryParse((product['oldPrice'] ?? 0).toString()) ?? 0.0,
        'image': (product['image'] ?? product['image_url'] ?? '').toString(),
        'checked': true,
      });
    }
    notifyListeners();
  }

  void removeFromWishlist(int index) {
    if (index >= 0 && index < _wishlistItems.length) {
      _wishlistItems.removeAt(index);
      notifyListeners();
    }
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
