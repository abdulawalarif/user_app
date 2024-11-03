import 'package:flutter/material.dart';
import 'package:user_app/main.dart';
 
class StepperForEcom extends StatefulWidget {
  const StepperForEcom({super.key});

  @override
  State<StepperForEcom> createState() => _StepperForEcomState();
}

class _StepperForEcomState extends State<StepperForEcom> {
  int currentStep = 0;
  bool isCompleted = false;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController addressController;
  late TextEditingController postCodeController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    postCodeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    postCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stepper'),
      ),
      body: isCompleted
          ? buildCompleted()
          : Stepper(
              //If you want a vertical Stepper change this StepperType.horizontal to StepperType.horizontal
              type: StepperType.horizontal,
              steps: getStepps(),
              currentStep: currentStep,
              onStepTapped: (step) => setState(() => currentStep = step),
              onStepContinue: () {
                final isLastStep = currentStep == getStepps().length - 1;
                if (isLastStep) {
                  'Sending data to the server'.log();
                  firstNameController.clear();
                  lastNameController.clear();
                  addressController.clear();
                  postCodeController.clear();
                  setState(() {
                    isCompleted = true;
                  });
                } else {
                  setState(() => currentStep += 1);
                }
              },
              onStepCancel: () {
                currentStep == 0 ? null : setState(() => currentStep -= 1);
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final isLastStep = currentStep == getStepps().length - 1;
                return Row(
                  children: [
                    if (currentStep != 0)
                      Button(
                        onPressed: details.onStepCancel!,
                        text: 'Back',
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    Button(
                      onPressed: details.onStepContinue!,
                      text: isLastStep ? 'Confirm' : 'Next',
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget buildCompleted() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_done,
            size: 150,
            color: Colors.blue,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isCompleted = false;
                currentStep = 0;
              });
            },
            child: const Text('Re-start'),
          ),
        ],
      ),
    );
  }

  List<Step> getStepps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('Account'),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                TextField(
                  controller: firstNameController,
                ),
                TextField(
                  controller: lastNameController,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('Address'),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                TextField(
                  controller: postCodeController,
                ),
                TextField(
                  controller: addressController,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text('Complete'),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'First Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      firstNameController.text.toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    const Text(
                      'Last Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      lastNameController.text.toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    const Text(
                      'Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      addressController.text.toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    const Text(
                      'Postcode',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      postCodeController.text.toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
              ],
            ),
          ),
        ),
      ];
}

class Button extends StatelessWidget {
   final VoidCallback onPressed;  
  final String text;
  const Button({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      child: Text(text),  
    );
  }
}