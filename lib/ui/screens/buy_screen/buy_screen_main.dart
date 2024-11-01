import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/core/models/buy_product_model.dart';
import 'package:user_app/core/models/user_model.dart';
import 'package:user_app/core/providers/auth_provider.dart' as authProvider;
import 'package:user_app/core/providers/orders_provider.dart';
import 'package:user_app/core/providers/user_data_provider.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/ui/widgets/log_in_suggestion.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../utils/my_snackbar.dart';

class BuyScreen extends StatefulWidget {
  final List<BuyProductModel> products;
  final double totalPrice;
  BuyScreen({super.key, required this.products, required this.totalPrice});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  UserModel _userData = UserModel();
  int _selectedPayment = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    addDummyData();
  }

  void submitData() {}

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        Provider.of<authProvider.AuthProvider>(context).isLoggedIn;

    final userDataProvider = Provider.of<UserDataProvider>(context);
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      userDataProvider.fetchUserData();
    });
    _userData = userDataProvider.userData;

    if (isLoggedIn) {
      return ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        progressIndicator: SpinKitFadingCircle(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.white : Colors.green,
              ),
            );
          },
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text(
              'Order confirmation',
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              /// payment section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 20.h,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                      color:Theme.of(context).scaffoldBackgroundColor,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          'Choose payment option',
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
                              color:  Theme.of(context).scaffoldBackgroundColor,
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
                               color:  Theme.of(context).scaffoldBackgroundColor,),
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
              Padding(
                padding: EdgeInsets.all(1.h),
                child: Text(
                  'Items',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Flexible(
                child: ListView.builder(
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.products[index].imageUrl),
                                      fit: BoxFit.contain)),
                            ),

                            const SizedBox(
                              width: 4,
                            ),

                            /// this is price and title section of the buy product
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),

                                      /// this data will be fetched from argument
                                      child: Text(
                                        widget.products[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    )),
                                SizedBox(
                                    width: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),

                                      /// this data will be fetched from argument
                                      child: Text(
                                        '\$${widget.products[index].price * widget.products[index].totalItemsOFSingleProduct}',
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    )),
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
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Center(
                                      child: Text(
                                    '${widget.products[index].totalItemsOFSingleProduct}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
          bottomSheet: Container(
            color: Theme.of(context).cardColor,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SubTotal
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            //TODO chanaged this logic of multiple product and a single product so ther can be error  here if i come back from a single product datails page
                            'Total: \$${widget.totalPrice}',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Checkout Button
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                        onTap: _selectedPayment == 1
                            ? () async {
                                final ordersProvider =
                                    Provider.of<OrdersProvider>(context,
                                        listen: false);
                                await ordersProvider.addOrdersToDatabase();
                                if (_userData.address.isEmpty ||
                                    _userData.phoneNumber.isEmpty ||
                                    _userData.fullName.isEmpty) {
                                  MySnackBar().showSnackBar(
                                    'Please fill all the information',
                                    context,
                                  );
                                  Navigator.of(context).pushNamed(
                                    RouteName.updateUserInfo,
                                    arguments: _userData,
                                  );
                                } else {
                                  final ordersProvider =
                                      Provider.of<OrdersProvider>(context,
                                          listen: false);
                                  ordersProvider.addOrdersToDatabase();
                                  // ordersModel.customersId = _userData.id;

                                  // for (int i = 0;
                                  //     i < (widget.products.length);
                                  //     i++) {
                                  //   ordersModel.thumbnailImageUrl =
                                  //       widget.products[i].imageUrl;
                                  //   ordersModel.nameOfTheProduct =
                                  //       widget.products[i].title;
                                  //   ordersModel.totalItemsOrdered = widget
                                  //       .products[i].totalItemsOFSingleProduct;
                                  //   ordersModel.price =
                                  //       widget.products[i].price.toString();
                                  //   ordersProvider
                                  //       .addOrdersToDatabase(
                                  //           ordersModel: ordersModel)
                                  //       .then((value) {
                                  //     showDialog(
                                  //         context: context,
                                  //         builder: (BuildContext context) =>
                                  //             AlertDialog(
                                  //               title: Text(
                                  //                 'Remember'.toUpperCase(),
                                  //                 style: TextStyle(
                                  //                   color: Theme.of(context)
                                  //                       .primaryColor,
                                  //                   fontWeight: FontWeight.w500,
                                  //                   fontSize: 20,
                                  //                 ),
                                  //               ),
                                  //               content: const Text(
                                  //                   "On the delivery day arrange the amount of cash you orderd!"),
                                  //               actions: [
                                  //                 TextButton(
                                  //                   onPressed: () =>
                                  //                       Navigator.pop(context),
                                  //                   child: const Text('OK'),
                                  //                 ),
                                  //               ],
                                  //             ));
                                  //   });
                                  // }
                                }
                              }
                            : () {},
                        child: Center(
                          child: Text(
                            _selectedPayment == 1
                                ? "Place order"
                                : "Open Gateway",
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
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const Scaffold(body: LogInSuggestion());
  }
}
