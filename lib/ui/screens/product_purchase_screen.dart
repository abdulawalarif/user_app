import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/core/models/buy_product_model.dart';
import 'package:user_app/core/models/user_model.dart';
import 'package:user_app/core/providers/orders_provider.dart';
import 'package:user_app/ui/widgets/log_in_suggestion.dart';
import '../../core/models/orders_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/user_data_provider.dart';
import '../constants/route_name.dart';
import '../utils/my_snackbar.dart';
import 'package:uuid/uuid.dart';
import '../widgets/reusable_text_field.dart';

class ProductPurchaseScreen extends StatefulWidget {
  final List<BuyProductModel> products;
  final double totalPrice;
  final bool fromCart;
  const ProductPurchaseScreen({
    super.key,
    required this.products,
    required this.totalPrice,
    required this.fromCart,
  });

  @override
  State<ProductPurchaseScreen> createState() => _ProductPurchaseScreenState();
}

class _ProductPurchaseScreenState extends State<ProductPurchaseScreen> {
  int currentStep = 0;
  bool isCompleted = false;
  final _formKey = GlobalKey<FormState>();
  int _selectedPayment = 1;

  //user address  TextEditingController
  late TextEditingController phoneNumberController;
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController postalCodeController;
  late TextEditingController countryController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  //user address  FocusNode
  late FocusNode phoneNumberFocusNode;
  late FocusNode addressLine1FocusNode;

  late FocusNode addressLine2FocusNode;
  late FocusNode cityFocusNode;
  late FocusNode stateFocusNode;
  late FocusNode postalCodeFocusNode;
  late FocusNode countryFocusNode;
  late FocusNode latitudeFocusNode;
  late FocusNode longitudeFocusNode;

  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    //   'FromCart? ${widget.fromCart}'.log();
    //user address for sending data to ordered list
    phoneNumberController = TextEditingController();
    addressLine1Controller = TextEditingController();
    addressLine2Controller = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    postalCodeController = TextEditingController();
    countryController = TextEditingController();
    //Fetching lat and lon from google api
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();

    //user address  FocusNode
    phoneNumberFocusNode = FocusNode();
    addressLine1FocusNode = FocusNode();
    addressLine2FocusNode = FocusNode();
    cityFocusNode = FocusNode();
    stateFocusNode = FocusNode();
    postalCodeFocusNode = FocusNode();
    countryFocusNode = FocusNode();
    latitudeFocusNode = FocusNode();
    longitudeFocusNode = FocusNode();

    Provider.of<UserDataProvider>(context, listen: false)
        .fetchUserData()
        .then((userAddressData) {
      phoneNumberController.text = userAddressData.phoneNumber;
      addressLine1Controller.text = userAddressData.addressLine1;
      addressLine2Controller.text = userAddressData.addressLine2;
      cityController.text = userAddressData.city;
      stateController.text = userAddressData.state;
      postalCodeController.text = userAddressData.postalCode;
      countryController.text = userAddressData.country;
      latitudeController.text = userAddressData.latitude;
      longitudeController.text = userAddressData.longitude;
    });
  }

  @override
  void dispose() {
    super.dispose();
    //user address for sending data to ordered list
    phoneNumberController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();

    phoneNumberFocusNode.dispose();
    addressLine1FocusNode.dispose();
    addressLine2FocusNode.dispose();
    cityFocusNode.dispose();
    stateFocusNode.dispose();
    postalCodeFocusNode.dispose();
    countryFocusNode.dispose();
    latitudeFocusNode.dispose();
    longitudeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userData;
    Provider.of<UserDataProvider>(context, listen: false)
        .fetchUserData()
        .then((_) {
      userData = Provider.of<UserDataProvider>(context, listen: false).userData;
    });

    final orderProcessing = Provider.of<OrdersProvider>(context);

    final isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;
    if (isLoggedIn) {
      return !isCompleted
          ? Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: const Text('Order confirmation'),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Stepper(
                      type: StepperType.horizontal,
                      steps: getStepps(),
                      currentStep: currentStep,
                      //If you want user to be capable fo navigating between steps by clicking on the steps click then uncomment this lines..
                      // onStepTapped: (step) =>
                      //     setState(() => currentStep = step),
                      onStepContinue: () {
                        final isLastStep =
                            currentStep == getStepps().length - 1;
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
                        return const SizedBox();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
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
                          onPressed: () async {
                            final isLastStep =
                                currentStep == getStepps().length - 1;
                            final isAddressStep =
                                currentStep == getStepps().length - 2;

                            if (isLastStep) {
                              //checking for null address data.. to be 100% confirm that user didn't missed any data point for delivery
                              if (_selectedPayment == 1) {
                                //fixing order id

                                var orderId = uuid.v6();
                                var orderData = OrdersModel(
                                  orderId: orderId,
                                  customerId: userData.id,
                                  orderDate: DateTime.now(),
                                  totalItemsOrdered: widget.products.length,
                                  totalAmount: widget.totalPrice,
                                  paymentStatus: 'Pending',
                                  status: 'Pending',
                                  createdAt: DateTime.now().toIso8601String(),
                                  updatedAt: DateTime.now().toIso8601String(),
                                  products: widget.products.map((buyProduct) {
                                    return Product(
                                      productId: buyProduct.prodId,
                                      productName: buyProduct.title,
                                      quantity:
                                          buyProduct.totalItemsOFSingleProduct,
                                      pricePerUnit: buyProduct.price,
                                      totalPriceForThisItem: buyProduct.price *
                                          buyProduct.totalItemsOFSingleProduct,
                                    );
                                  }).toList(),
                                );

                                var shippingAddress = UserModel(
                                    createdAt: userData.createdAt,
                                    email: userData.email,
                                    fullName: userData.fullName,
                                    id: userData.id,
                                    imageUrl: userData.imageUrl,
                                    joinedAt: userData.joinedAt,
                                    phoneNumber:
                                        phoneNumberController.text.toString(),
                                    addressLine1:
                                        addressLine1Controller.text.toString(),
                                    addressLine2:
                                        addressLine2Controller.text.toString(),
                                    city: cityController.text.toString(),
                                    state: stateController.text.toString(),
                                    postalCode:
                                        postalCodeController.text.toString(),
                                    country: countryController.text.toString(),
                                    latitude:
                                        latitudeController.text.toString(),
                                    longitude:
                                        longitudeController.text.toString(),
                                    address:
                                        '${addressLine1Controller.text.toString()}, ${addressLine2Controller.text.toString()}, ${cityController.text.toString()}, ${stateController.text.toString()} ${postalCodeController.text.toString()}, ${countryController.text.toString()}');
                                if (!orderProcessing.isLoading) {
                                  await orderProcessing
                                      .addOrder(
                                    order: orderData,
                                    shippingAddress: shippingAddress,
                                  )
                                      .then((data) {
                                    if (widget.fromCart) {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .removeAll();
                                    }
                                    setState(() {
                                      isCompleted = true;
                                    });
                                  }).catchError((error) {
                                    print("Error: $error");
                                  });
                                }
                              } else {
                                MySnackBar().showSnackBar(
                                    'Payment method is not integrated yet',
                                    context);
                              }
                            } else if (isAddressStep) {
                              navigateToNextIfEverythingIsOkay();
                            } else {
                              setState(() => currentStep += 1);
                            }
                          },
                          text: currentStep == getStepps().length - 1
                              ? orderProcessing.isLoading
                                  ? '...'
                                  : 'Confirm'
                              : 'Next',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : orderPlaced();
    }
    return const Scaffold(body: LogInSuggestion());
  }

  void navigateToNextIfEverythingIsOkay() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      FocusScope.of(context).unfocus();
      _formKey.currentState!.save();
      setState(() => currentStep += 1);
    }
  }

  Widget orderPlaced() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 150,
                      maxWidth: 150,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/cargo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    'Your Order Has Been Placed! You Will Receive an Email Shortly',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 25.0),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isCompleted = false;
                        currentStep = 0;
                      });
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteName.bottomBarScreen,
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text(
                      'Continue shopping',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Step> getStepps() => [
        orderedItems(),
        shippingAddress(),
        lastStep(),
      ];

  Step lastStep() {
    return Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: const Text('Pay'),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            // payment section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 20.h,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        'Choose a payment option',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Container(
                        height: 7.h,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Center(
                          child: RadioListTile(
                            title: const Text('Cash on Delivery'),
                            value: 1,
                            groupValue: _selectedPayment,
                            onChanged: (value) {
                              setState(() {
                                _selectedPayment = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Container(
                        height: 7.h,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: RadioListTile(
                          title: const Text('Choose other paymebnt options'),
                          value: 2,
                          groupValue: _selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              _selectedPayment = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Step shippingAddress() {
    return Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text('Address'),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: formForUserInput(),
      ),
    );
  }

  Form formForUserInput() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ReusableTextField(
            controller: phoneNumberController,
            focusNode: phoneNumberFocusNode,
            valueKey: 'Mobile Number',
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value!.isEmpty ? 'Please Provider your phone number' : null,
            labelText: 'Mobile Number',
            hintText: '+880001122020',
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(addressLine1FocusNode),
          ),
          ReusableTextField(
            controller: addressLine1Controller,
            focusNode: addressLine1FocusNode,
            valueKey: 'addressLine1',
            textCapitalization: TextCapitalization.words,
            validator: (value) =>
                value!.isEmpty ? 'Please fill your AddressLine1' : null,
            labelText: 'AddressLine1',
            hintText: '23 Elm Street',
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(addressLine2FocusNode),
          ),
          ReusableTextField(
            controller: addressLine2Controller,
            focusNode: addressLine2FocusNode,
            valueKey: 'addressLine2',
            validator: (value) =>
                value!.isEmpty ? 'Please fill your AddressLine2' : null,
            labelText: 'AddressLine2',
            hintText: 'Apt 4B',
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(cityFocusNode),
          ),
          ReusableTextField(
            controller: cityController,
            focusNode: cityFocusNode,
            valueKey: 'City',
            validator: (value) =>
                value!.isEmpty ? 'Please enter your City' : null,
            labelText: 'City',
            hintText: 'Los Angeles',
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(stateFocusNode),
          ),
          ReusableTextField(
            controller: stateController,
            focusNode: stateFocusNode,
            valueKey: 'State',
            validator: (value) =>
                value!.isEmpty ? 'Please enter your State' : null,
            labelText: 'State',
            hintText: 'CA',
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(postalCodeFocusNode),
          ),
          ReusableTextField(
            controller: postalCodeController,
            focusNode: postalCodeFocusNode,
            valueKey: 'postalCode',
            validator: (value) =>
                value!.isEmpty ? 'Please enter your postal code' : null,
            keyboardType: TextInputType.number,
            labelText: 'Postal Code',
            hintText: '90001',
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(countryFocusNode),
          ),
          ReusableTextField(
            controller: countryController,
            focusNode: countryFocusNode,
            valueKey: 'country',
            validator: (value) =>
                value!.isEmpty ? 'Please enter your country' : null,
            labelText: 'country',
            hintText: 'USA',
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(latitudeFocusNode),
          ),
          ReusableTextField(
            controller: latitudeController,
            focusNode: latitudeFocusNode,
            keyboardType: TextInputType.number,
            valueKey: 'latitude',
            labelText: 'latitude',
            hintText: '33.97365',
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(longitudeFocusNode),
          ),
          ReusableTextField(
              controller: longitudeController,
              focusNode: longitudeFocusNode,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              valueKey: 'longitude',
              labelText: 'longitude',
              hintText: '-118.24904',
              onEditingComplete: () {
                navigateToNextIfEverythingIsOkay();
              }),
        ],
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
