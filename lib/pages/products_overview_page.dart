import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/product_grid.dart';
import '../components/cart_badge.dart';
import '../components/app_drawer.dart';
import '../models/cart.dart';
import '../models/product_list.dart';
import '../utils/app_routes.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoritesOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => CartBadge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
          PopupMenuButton(
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOptions.Favorites,
                      child: Text('Somente favoritos'),
                    ),
                    const PopupMenuItem(
                      value: FilterOptions.All,
                      child: Text('Todos'),
                    ),
                  ],
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showFavoritesOnly = true;
                  } else {
                    _showFavoritesOnly = false;
                  }
                });
              }),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavoritesOnly),
      drawer: const AppDrawer(),
    );
  }
}
