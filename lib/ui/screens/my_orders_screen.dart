import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Timeline'),
      ),
      body: Stepper(
        
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() {
              _currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('Order Placed'),
            content: SingleChildScrollView(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 70,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Prevents independent scrolling
                itemBuilder: (context, index) {
                  return Text('Your order has been placed. ${index}');
                },
              ),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text('Order Processing'),
            content: Text('Your order is being processed.'),
            isActive: _currentStep >= 1,
            state: _currentStep >= 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text('Shipped'),
            content: Text('Your order has been shipped.'),
            isActive: _currentStep >= 2,
            state: _currentStep >= 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text('Delivered'),
            content: Text('Your order has been delivered.'),
            isActive: _currentStep >= 3,
            state: _currentStep >= 3 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
