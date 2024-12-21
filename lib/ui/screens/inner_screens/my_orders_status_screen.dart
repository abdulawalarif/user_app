import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/providers/orders_provider.dart';
import '../../../core/models/orders_model.dart';
import '../../widgets/order_status_setup.dart';

class MyOrdersStatusScreen extends StatelessWidget {
  final OrdersModel ordersModel;

  const MyOrdersStatusScreen({
    super.key,
    required this.ordersModel,
  });

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);

    return StreamBuilder<OrdersModel>(
      stream: ordersProvider.streamOrderStatus(ordersModel.orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Order Status')),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Order Status')),
            body: const Center(
              child: Text('No order data available'),
            ),
          );
        } else {
          final order = snapshot.data!;
          return _buildOrderStatusScreen(context, order);
        }
      },
    );
  }

  Widget _buildOrderStatusScreen(BuildContext context, OrdersModel order) {
    final theme = Theme.of(context);
    final bool isDarkTheme = theme.brightness == Brightness.dark;

    final isPending = order.status == 'Pending';
    final isReceived = order.status == 'Received' ||
        order.status == 'Confirmed' ||
        order.status == 'Delivered';
    final isOnTheWay = order.status == 'Confirmed' || order.status == 'Delivered';
    final isDelivered = order.status == 'Delivered';

    return ModalProgressHUD(
      inAsyncCall: false,
      progressIndicator: Center(
        child: CircularProgressIndicator(
          color: theme.highlightColor,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Status', style: theme.textTheme.titleSmall),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: ColorFiltered(
                colorFilter: isDarkTheme
                    ? const ColorFilter.mode(Colors.black54, BlendMode.darken)
                    : const ColorFilter.mode(
                        Colors.transparent, BlendMode.multiply),
                child: Image.asset(
                  'assets/order.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        const SizedBox(height: 16),
                        OrderStatusStep(
                          title: 'Order Pending',
                          time: order.createdAt.formattedDate(),
                          isCompleted: !isPending&&isReceived ||isPending,
                        ),
                        OrderStatusStep(
                          title: 'Order Received',
                          time:isReceived? order.createdAt.formattedDate():'...',
                          isCompleted: isReceived,
                        ),
                        OrderStatusStep(
                          title: 'On The Way',
                          time: !isOnTheWay
                              ? '...'
                              : order.updatedAt.formattedDate(),
                          isCompleted: isOnTheWay,
                          showTracking: !isDelivered && isOnTheWay,
                        ),
                        OrderStatusStep(
                          title: 'Delivered',
                          isCompleted: isDelivered,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: Material(
                            color: theme.primaryColor,
                            child: InkWell(
                              onTap: isDelivered
                                  ? () async {
                                      try {
                                        await Provider.of<OrdersProvider>(
                                                context,
                                                listen: false)
                                            .confirmOrder(
                                                ordersModel: order);

                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      } catch (error) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Failed to confirm order: $error')),
                                          );
                                        }
                                      }
                                    }
                                  : null,
                              child: Center(
                                child: Text(
                                  'Confirm Delivery',
                                  style: theme.textTheme.titleSmall!.copyWith(
                                    color: isDelivered
                                        ? Colors.white
                                        : theme.unselectedWidgetColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          ],
        ),
      ),
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
