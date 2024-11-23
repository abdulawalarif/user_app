import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../../core/providers/orders_provider.dart';
import '../constants/app_consntants.dart';
import '../constants/route_name.dart';
import '../widgets/empty_order.dart';

class MyOrdersScreen extends StatelessWidget {
  final String userId;
  const MyOrdersScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrdersProvider>(context, listen: false)
          .myOrders(customerId: userId);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Consumer<OrdersProvider>(
        builder: (context, myOrdersProvider, child) {
          if (myOrdersProvider.isLoading) {
            return _buildShimmerEffect();
          } else if (myOrdersProvider.orderList.isEmpty) {
            return const EmptyOrder();
          } else {
            return ListView.builder(
              itemCount: myOrdersProvider.orderList.length,
              itemBuilder: (context, index) {
                final order = myOrdersProvider.orderList[index];
                final productNames = order.products
                    .asMap()
                    .entries
                    .map((entry) =>
                        '${entry.key + 1}. ${entry.value.productName}')
                    .join(', ');
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(order.createdAt.formattedDate(),
                        style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 1, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Products: $productNames',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                         const Gap(4),
                          Text(
                            'STATUS: ${order.status}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    trailing: Icon(
                      mTrailingIcon,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RouteName.ordersStatusScreen,
                        arguments: {
                          'OrdersModel': order,
                        },
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListTile(
              title: Container(
                width: double.infinity,
                height: 16.0,
                color: Colors.grey[300],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: double.infinity,
                  height: 12.0,
                  color: Colors.grey[300],
                ),
              ),
              trailing: Container(
                width: 40.0,
                height: 40.0,
                color: Colors.grey[300],
              ),
            ),
          ),
        );
      },
    );
  }
}

extension on String {
  String formattedDate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      return DateFormat('MMMM d, y').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }
}

extension on String {
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
}
