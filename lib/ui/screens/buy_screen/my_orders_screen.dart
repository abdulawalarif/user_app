import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final bool isDelivered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme
        final bool isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status', style: theme.textTheme.titleSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ORDER STATUS', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Divider(color: theme.dividerColor, thickness: 2),
            const SizedBox(height: 16),
            const OrderStatusStep(
              title: 'Order Received',
              time: '8:30 am, Jan 31, 2017',
              isCompleted: true,
            ),
            const OrderStatusStep(
              title: 'On The Way',
              time: '10:23 am, Jan 31, 2017',
              isCompleted: true,
              showTracking: true,
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
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
              SizedBox(
              height: 100,
              width: double.infinity,
              child: ColorFiltered(
                colorFilter: isDarkTheme
                    ? const ColorFilter.mode(
                        Colors.black54, BlendMode.darken)
                    : const ColorFilter.mode(
                        Colors.transparent, BlendMode.multiply),
                child: Image.asset(
                  'assets/order.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderStatusStep extends StatelessWidget {
  final String title;
  final String? time;
  final bool isCompleted;
  final bool showTracking;

  const OrderStatusStep({
    super.key,
    required this.title,
    this.time,
    required this.isCompleted,
    this.showTracking = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? theme.primaryColor : theme.unselectedWidgetColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isCompleted
                      ? theme.textTheme.bodyLarge!.color
                      : theme.unselectedWidgetColor,
                ),
              ),
              if (time != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      time!,
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: theme.colorScheme.tertiary),
                    ),
                    if (showTracking)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Tracking',
                          style: theme.textTheme.labelSmall!.copyWith(
                            color: theme.colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
