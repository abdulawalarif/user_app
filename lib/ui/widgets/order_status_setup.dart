import 'package:flutter/material.dart';

class OrderStatusStep extends StatelessWidget {
  final String title;
  final String? time;
  final bool isCompleted;
  final bool showTracking;
//  final bool isLast;

  const OrderStatusStep({
    super.key,
    required this.title,
    this.time,
    required this.isCompleted,
    this.showTracking = false,
    //required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted
                  ? theme.primaryColor
                  : theme.unselectedWidgetColor,
            ),
            if (title != 'Delivered')
              Container(
                width: 2,
                height: 30,
                color: theme.unselectedWidgetColor,
              ),
          ],
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
                        child: Text('Tracking',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: Colors.white)),
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
