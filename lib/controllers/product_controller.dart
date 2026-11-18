import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _filteredProducts.isNotEmpty ? _filteredProducts : _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await ApiService.getProducts();
      _products = data.map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item))).toList();
      _filteredProducts = List.from(_products);
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
    }
    notifyListeners();
  }

  void filterByCategory(String category) {
    if (category.isEmpty || category.toLowerCase() == 'all') {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((p) => p.category.toLowerCase().contains(category.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void searchProducts(String query) {
    if (query.trim().isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      final q = query.toLowerCase().trim();
      _filteredProducts = _products
          .where((p) => p.name.toLowerCase().contains(q) || p.category.toLowerCase().contains(q))
          .toList();
    }
    notifyListeners();
  }
}
