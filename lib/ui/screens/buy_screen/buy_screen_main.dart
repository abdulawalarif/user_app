import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/core/models/buy_product_model.dart';
import 'package:user_app/core/providers/orders_provider.dart';
import 'package:user_app/main.dart';
import '../../../core/models/orders_model.dart';
import '../../../core/providers/user_data_provider.dart';
import '../../utils/my_border.dart';

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
  final _formKey = GlobalKey<FormState>();

  //user address  TextEditingController
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController postalCodeController;
  late TextEditingController countryController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController formattedAddressController;
  final ValueNotifier<String> formattedAddressNotifier =
      ValueNotifier<String>("");

  //user address  FocusNode
  late FocusNode addressLine1FocusNode;
  late FocusNode addressLine2FocusNode;
  late FocusNode cityFocusNode;
  late FocusNode stateFocusNode;
  late FocusNode postalCodeFocusNode;
  late FocusNode countryFocusNode;
  late FocusNode latitudeFocusNode;
  late FocusNode longitudeFocusNode;
  late FocusNode formattedAddressFocusNode;

  @override
  void initState() {
    super.initState();
    Provider.of<UserDataProvider>(context, listen: false).fetchUserData();

    //user address for sending data to ordered list
    addressLine1Controller = TextEditingController();
    addressLine2Controller = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    postalCodeController = TextEditingController();
    countryController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
    formattedAddressController = TextEditingController();
    //user address  FocusNode
    addressLine1FocusNode = FocusNode();
    addressLine2FocusNode = FocusNode();
    cityFocusNode = FocusNode();
    stateFocusNode = FocusNode();
    postalCodeFocusNode = FocusNode();
    countryFocusNode = FocusNode();
    latitudeFocusNode = FocusNode();
    longitudeFocusNode = FocusNode();
    formattedAddressFocusNode = FocusNode();

    // Listen to each text field and update the formatted address in real time
    addressLine1Controller.addListener(updateFormattedAddress);
    addressLine2Controller.addListener(updateFormattedAddress);
    cityController.addListener(updateFormattedAddress);
    stateController.addListener(updateFormattedAddress);
    postalCodeController.addListener(updateFormattedAddress);
    countryController.addListener(updateFormattedAddress);
  }

  void updateFormattedAddress() {
    // Format the address based on current text in each field
    String formattedAddress = formatAddress();
    formattedAddressNotifier.value = formattedAddress;
  }

  String formatAddress() {
    String addressLine1 = addressLine1Controller.text;
    String addressLine2 = addressLine2Controller.text;
    String city = cityController.text;
    String state = stateController.text;
    String postalCode = postalCodeController.text;
    String country = countryController.text;

    return "$addressLine1, $addressLine2, $city, $state $postalCode, $country";
  }

  @override
  void dispose() {
    super.dispose();
    //user address for sending data to ordered list
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    formattedAddressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataProvider>(context).userData;
    final orderProcessing = Provider.of<OrdersProvider>(context, listen: false);
    userData.id.log();
    print('Something is here');

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
            child: isCompleted
                ? buildCompleted()
                : Stepper(
                    type: StepperType.horizontal,
                    steps: getStepps(),
                    currentStep: currentStep,
                    onStepTapped: (step) => setState(() => currentStep = step),
                    onStepContinue: () {
                      final isLastStep = currentStep == getStepps().length - 1;
                      if (isLastStep) {
                        setState(() {
                          isCompleted = true;
                        });
                      } else {
                        setState(() => currentStep += 1);
                      }
                    },
                    onStepCancel: () {
                      currentStep == 0
                          ? null
                          : setState(() => currentStep -= 1);
                    },
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return const SizedBox(); // Disable inline controls
                    },
                  ),
          ),

          /// TODO making the buttons not openning up or showing on top of the keybord when user is typing their addr/informations
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                    final isAddressStep = currentStep == getStepps().length - 2;

                    if (isLastStep) {
                      'Sending data to the server'.log();

                      var orderData = OrdersModel(
                        orderId: "ORD123457",
                        customerId: userData.id,
                        orderDate: DateTime.now(),
                        totalItemsOrdered: widget.products.length,
                        totalAmount: widget.totalPrice,
                        paymentStatus: "Paid",
                        status: "Shipped",
                        createdAt: DateTime.now().toIso8601String(),
                        updatedAt: DateTime.now().toIso8601String(),
                        products: widget.products.map((buyProduct) {
                          return Product(
                            productId: buyProduct.prodId,
                            productName: buyProduct.title,
                            quantity: buyProduct.totalItemsOFSingleProduct,
                            pricePerUnit: buyProduct.price,
                            totalPriceForThisItem: buyProduct.price *
                                buyProduct.totalItemsOFSingleProduct,
                          );
                        }).toList(),
                        shippingAddress: ShippingAddress(
                          addressLine1: addressLine1Controller.text.toString(),
                          addressLine2: addressLine2Controller.text.toString(),
                          city: cityController.text.toString(),
                          state: stateController.text.toString(),
                          postalCode: postalCodeController.text.toString(),
                          country: countryController.text.toString(),
                          latitude:
                              double.tryParse(latitudeController.text) ?? 0.0,
                          longitude:
                              double.tryParse(longitudeController.text) ?? 0.0,
                          formattedAddress:
                              formattedAddressController.text.toString(),
                        ),
                      );

                      orderProcessing.addOrder(orderData).then((data) {
                        setState(() {
                        isCompleted = true;
                      });
                      }).catchError((error) {
                        print("Error: $error");
                      });
                    } else if (isAddressStep) {
                      _formKey.currentState!.validate();

                      //if form is not validated will not show the tick mark here and will move to the next button though
                    } else {
                      setState(() => currentStep += 1);
                    }
                  },
                  text: currentStep == getStepps().length - 1
                      ? 'Confirm'
                      : 'Next',
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
        orderedItems(),
        shippingAddress(),
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

  Step shippingAddress() {
    return Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text('Address'),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: addressLine1Controller,
                  focusNode: addressLine1FocusNode,
                  key: const ValueKey('addressLine1'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please fill your AddressLine1' : null,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'AddressLine1',
                    hintText: '123 Elm Street',
                    contentPadding: const EdgeInsets.all(12),
                    border: const OutlineInputBorder(),
                    enabledBorder: MyBorder.outlineInputBorder(context),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onEditingComplete: () => FocusScope.of(context)
                      .requestFocus(addressLine2FocusNode),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: addressLine2Controller,
                  focusNode: addressLine2FocusNode,
                  key: const ValueKey('addressLine2'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please fill your AddressLine2' : null,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'AddressLine2',
                    hintText: 'Apt 4B',
                    contentPadding: const EdgeInsets.all(12),
                    border: const OutlineInputBorder(),
                    enabledBorder: MyBorder.outlineInputBorder(context),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(cityFocusNode),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: cityController,
                  focusNode: cityFocusNode,
                  key: const ValueKey('City'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your City' : null,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'City',
                    hintText: 'Los Angeles',
                    contentPadding: const EdgeInsets.all(12),
                    border: const OutlineInputBorder(),
                    enabledBorder: MyBorder.outlineInputBorder(context),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(stateFocusNode),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: stateController,
                  focusNode: stateFocusNode,
                  key: const ValueKey('State'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your State' : null,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'State',
                    hintText: 'CA',
                    contentPadding: const EdgeInsets.all(12),
                    border: const OutlineInputBorder(),
                    enabledBorder: MyBorder.outlineInputBorder(context),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(postalCodeFocusNode),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: postalCodeController,
                  focusNode: postalCodeFocusNode,
                  key: const ValueKey('postalCode'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your postal code' : null,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Postal Code',
                    hintText: '90001',
                    contentPadding: const EdgeInsets.all(12),
                    border: const OutlineInputBorder(),
                    enabledBorder: MyBorder.outlineInputBorder(context),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(countryFocusNode),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: countryController,
                  focusNode: countryFocusNode,
                  key: const ValueKey('country'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your country' : null,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'country',
                    hintText: 'USA',
                    contentPadding: const EdgeInsets.all(12),
                    border: const OutlineInputBorder(),
                    enabledBorder: MyBorder.outlineInputBorder(context),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(latitudeFocusNode),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: latitudeController,
                  focusNode: latitudeFocusNode,
                  key: const ValueKey('latitude'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your latitude' : null,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'latitude',
                    hintText: '-118.2437',
                    contentPadding: const EdgeInsets.all(12),
                    border: const OutlineInputBorder(),
                    enabledBorder: MyBorder.outlineInputBorder(context),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(longitudeFocusNode),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: longitudeController,
                  focusNode: longitudeFocusNode,
                  key: const ValueKey('longitude'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your longitude' : null,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'longitude',
                    hintText: '-118.2437',
                    contentPadding: const EdgeInsets.all(12),
                    border: const OutlineInputBorder(),
                    enabledBorder: MyBorder.outlineInputBorder(context),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onEditingComplete: () => FocusScope.of(context)
                      .requestFocus(formattedAddressFocusNode),
                ),
              ),

              //TODO will have to attach the whole address and automatically put the address of user have give on the respective places
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ValueListenableBuilder<String>(
                  valueListenable: formattedAddressNotifier,
                  builder: (context, formattedAddress, child) {
                    if (formattedAddressController.text != formattedAddress) {
                      formattedAddressController.text = formattedAddress;
                    }

                    return TextFormField(
                      controller: formattedAddressController,
                      focusNode: formattedAddressFocusNode,
                      key: const ValueKey('formattedAddress'),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your formattedAddress'
                          : null,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Formatted Address',
                        hintText:
                            '123 Elm Street, Apt 4B, Los Angeles, CA 90001, USA',
                        contentPadding: const EdgeInsets.all(12),
                        border: const OutlineInputBorder(),
                        enabledBorder: MyBorder.outlineInputBorder(context),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Step orderedItems() {
    return Step(
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
                      width: 45.w,
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
                        'Quantity',
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
    );
  }
}

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const Button({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      width: 24.w,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
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
