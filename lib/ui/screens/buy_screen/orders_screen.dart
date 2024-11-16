import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/orders_model.dart';
import '../../../core/providers/orders_provider.dart';
import '../../constants/app_consntants.dart';
import '../../constants/route_name.dart';
import '../../widgets/empty_order.dart';
import 'package:intl/intl.dart';


class OrdersScreen extends StatefulWidget {
  final String userId;
  const OrdersScreen({
    super.key,
    required this.userId,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrdersProvider>(context, listen: false)
        .myOrders(customerId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final myOrdersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: myOrdersProvider.orderList.isEmpty
            ? const EmptyOrder()
            : ListView.builder(
                itemCount: myOrdersProvider.orderList.length,
                itemBuilder: (context, index) {
                  final order = myOrdersProvider.orderList[index];
                  print(order.updatedAt);
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(order.createdAt.formattedDate(),
                          style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 16, 0, 0),
                        child: Text(
                          'Status: ${order.status}',
                          style: Theme.of(context).textTheme.titleLarge,
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
                            'status': order.status,
                            'confirmedDate': order.updatedAt.formattedDate(),
                            'orderdDate': order.createdAt.formattedDate(),
                          },
                        );
                      },
                    ),
                  );
                },
              ),);
  
  
  
  }
}


extension  on String {

  String formattedDate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      return DateFormat('MMMM d, y').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }
}