import 'package:flutter/material.dart';

import 'product.dart';
import '../data/dummy_data.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  void addProducts(Product product) {
    _items.add(product);
    notifyListeners();
  }
}

  // bool _showFavoritesOnly = false;

  // List<Product> get items {
  //   if (_showFavoritesOnly) {
  //     return _items.where((prod) => prod.isFavorite).toList();
  //   }
  //   return [..._items];
  // }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }