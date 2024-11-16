import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EmptyOrder extends StatelessWidget {
  const EmptyOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Icon(
            Icons.production_quantity_limits,
            size: 50,
            color: Theme.of(context).iconTheme.color,
          ),
          const Gap(20),
          Text(
            'NO ORDERS YET',
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}
