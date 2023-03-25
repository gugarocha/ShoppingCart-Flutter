import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/app_drawer.dart';
import '../components/order.dart';
import '../models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: provider.loadOrders,
        child: FutureBuilder(
          future: provider.loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ocorreu um erro ao buscar os pedidos'),
                    TextButton(
                      child: const Text('Tentar novamente'),
                      onPressed: () async => await provider.loadOrders(),
                    )
                  ],
                ),
              );
            }

            return Consumer<OrderList>(
              builder: (ctx, orders, child) {
                return ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
