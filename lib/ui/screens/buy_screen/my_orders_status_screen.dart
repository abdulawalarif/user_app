import 'package:flutter/material.dart';
import '../../widgets/order_status_setup.dart';

class MyOrdersStatusScreen extends StatefulWidget {
  final String status;
  final String orderdDate;
  final String confirmedDate;

  const MyOrdersStatusScreen({
    super.key,
    required this.status,
    required this.orderdDate,
    required this.confirmedDate,
  });

  @override
  State<MyOrdersStatusScreen> createState() => _MyOrdersStatusScreenState();
}

class _MyOrdersStatusScreenState extends State<MyOrdersStatusScreen> {
  //Here I have implemented 4 conditions for that will be comming from the backend and based on this i have configured my widgets
  bool isPending = true;
  bool isReceived = false;
  bool isOnTheWay = false;
  bool isDelivered = false;

  @override
  void initState() {
    super.initState();
    isPending = widget.status == 'Pending';
    isReceived = widget.status == 'Received' ||
        widget.status == 'Confirmed' ||
        widget.status == 'Delivered';
    ;
    isOnTheWay = widget.status == 'Confirmed' || widget.status == 'Delivered';
    isDelivered = widget.status == 'Delivered';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme
    final bool isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
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
          isPending
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: SizedBox(
                              width: 350,
                              child: Center(
                                  child: Text(
                                'YOUR ORDER IS PENDING! PLEASE WAIT FOR THE CONFIRMATION...',
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ))),
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                            'assets/orderPending.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      const SizedBox(height: 16),
                      OrderStatusStep(
                        title: 'Order Received',
                        time: widget.orderdDate,
                        isCompleted: isReceived,
                      ),
                      OrderStatusStep(
                        title: 'On The Way',
                        time: widget.status == 'Received'
                            ? ''
                            : widget.confirmedDate,
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
                                ? () {}
                                : () {
                                    // sending received status to database for this order
                                  },
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
    );
  }
}
