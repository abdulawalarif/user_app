import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/core/models/buy_product_model.dart';
 import 'package:user_app/main.dart';

class BuyScreen extends StatefulWidget {
  final List<BuyProductModel> products;
  final double totalPrice;
  const BuyScreen({
    super.key,
    required this.products,
    required this.totalPrice,
  });

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
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
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const Text('Order confirmation'),
      centerTitle: true,
    ),
    body: Column(
      children: [
        Expanded(
          child: isCompleted ? buildCompleted() : Stepper(
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
              return const SizedBox(); // Disable inline controls
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentStep != 0)
                Button(
                  onPressed: () {
                    setState(() => currentStep -= 1);
                  },
                  text: 'Back',
                ),
              Button(
                onPressed: () {
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
                text: currentStep == getStepps().length - 1 ? 'Confirm' : 'Next',
              ),
            ],
          ),
        ),
      ],
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
          title: const Text('Order Details'),
          content: ListView.builder(
            itemCount: widget.products.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10.h,
                      width: 20.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(widget.products[index].imageUrl),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 1.w,
                    ),

                    /// this is price and title section of the buy product
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 54.w,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              widget.products[index].title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              '\$${widget.products[index].price * widget.products[index].totalItemsOFSingleProduct}',
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// this is total item of same product section of the buy product
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Item',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Center(
                            child: Text(
                              '${widget.products[index].totalItemsOFSingleProduct}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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
    return SizedBox(
      height: 5.h,
      width: 20.w,
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}








// class BuyScreen extends StatefulWidget {
//   final List<BuyProductModel> products;
//   final double totalPrice;
//   BuyScreen({super.key, required this.products, required this.totalPrice});

//   @override
//   State<BuyScreen> createState() => _BuyScreenState();
// }

// class _BuyScreenState extends State<BuyScreen> {
//   int _selectedPayment = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         title: const Text(
//           'Order confirmation',
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           /// payment section
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               height: 20.h,
//               decoration: BoxDecoration(
//                 border: Border.all(),
//                 borderRadius: BorderRadius.circular(10),
//                 color: Theme.of(context).scaffoldBackgroundColor,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 5),
//                     child: Text(
//                       'Choose payment option',
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 4,
//                     ),
//                     child: Container(
//                       height: 7.h,
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(10),
//                         color: Theme.of(context).scaffoldBackgroundColor,
//                       ),
//                       child: Center(
//                         child: RadioListTile(
//                           title: const Text('Cash on Delivery'),
//                           value: 1,
//                           groupValue: _selectedPayment,
//                           onChanged: (value) {
//                             setState(() {
//                               _selectedPayment = value!;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     child: Container(
//                       height: 7.h,
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(10),
//                         color: Theme.of(context).scaffoldBackgroundColor,
//                       ),
//                       child: RadioListTile(
//                         title: const Text('Choose other paymebnt options'),
//                         value: 2,
//                         groupValue: _selectedPayment,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedPayment = value!;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(1.h),
//             child: Text(
//               'Product details and price',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//           ),
//           SizedBox(
//             height: 2.h,
//           ),
//           Flexible(
//             child: ListView.builder(
//                 itemCount: widget.products.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               image: DecorationImage(
//                                   image: NetworkImage(
//                                       widget.products[index].imageUrl),
//                                   fit: BoxFit.contain)),
//                         ),

//                         const SizedBox(
//                           width: 4,
//                         ),

//                         /// this is price and title section of the buy product
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                                 width: 200,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(4),

//                                   /// this data will be fetched from argument
//                                   child: Text(
//                                     widget.products[index].title,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style:
//                                         Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                 )),
//                             SizedBox(
//                                 width: 100,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(4),

//                                   /// this data will be fetched from argument
//                                   child: Text(
//                                     '\$${widget.products[index].price * widget.products[index].totalItemsOFSingleProduct}',
//                                     maxLines: 2,
//                                     style:
//                                         Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                 )),
//                           ],
//                         ),

//                         /// this is total item of same product section of the buy product
//                         Padding(
//                           padding: const EdgeInsets.only(top: 15),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Item',
//                                 style: Theme.of(context).textTheme.bodyLarge,
//                               ),
//                               Center(
//                                   child: Text(
//                                 '${widget.products[index].totalItemsOFSingleProduct}',
//                                 style: Theme.of(context).textTheme.bodyLarge,
//                               ))
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 }),
//           ),
//           SizedBox(
//             height: 10.h,
//           )
//         ],
//       ),
//       bottomSheet: Container(
//         color: Theme.of(context).cardColor,
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // SubTotal
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Flexible(
//                       child: Text(
//                         //TODO chanaged this logic of multiple product and a single product so ther can be error  here if i come back from a single product datails page
//                         'Total: \$${widget.totalPrice}',
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             /// Checkout Button
//             Expanded(
//               flex: 1,
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 child: Material(
//                   color: Theme.of(context).primaryColor,
//                   child: InkWell(
//                     onTap: () async {},
//                     child: Center(
//                       child: Text(
//                         "Open Gateway",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
