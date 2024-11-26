import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/providers/orders_provider.dart';
import '../../../core/models/orders_model.dart';
import '../../widgets/order_status_setup.dart';


/*
Here with orders i will get three status from adim 
1. "Pending"
2. "Received"
3. "Delivered"
based on that i have rendered my widget for showing the status of orders

Now if the status is Delivered i have activated the button for user to confirm the delivery and sent a 
status that "confirmedByCustomer"
*/
class MyOrdersStatusScreen extends StatefulWidget {
  final OrdersModel ordersModel;

  const MyOrdersStatusScreen({
    super.key,
    required this.ordersModel,
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    String orderStatus = widget.ordersModel.status;
    isPending = orderStatus == 'Pending';
    isReceived = orderStatus == 'Received' ||
        orderStatus == 'Confirmed' ||
        orderStatus == 'Delivered';

    isOnTheWay = orderStatus == 'Confirmed' || orderStatus == 'Delivered';
    isDelivered = orderStatus == 'Delivered';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme
    final bool isDarkTheme = theme.brightness == Brightness.dark;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
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
                                ),
                              ),
                            ),
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
                          time: widget.ordersModel.createdAt.formattedDate(),
                          isCompleted: isReceived,
                        ),
                        OrderStatusStep(
                          title: 'On The Way',
                          time: widget.ordersModel.status == 'Received'
                              ? '...'
                              : widget.ordersModel.updatedAt.formattedDate(),
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
                                  ? () {
                                      // sending received status to database for this order
                                      setState(() {
                                        isLoading = true;
                                      });

                                      Provider.of<OrdersProvider>(context,
                                              listen: false)
                                          .confirmOrder(
                                              ordersModel: widget.ordersModel)
                                          .then((_) {
                                        Future.delayed(Duration(seconds: 3),
                                            () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.of(context).pop();
                                        });
                                      });
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