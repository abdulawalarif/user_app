import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/core/models/buy_product_model.dart';
import 'package:user_app/core/models/orders_model.dart';
import 'package:user_app/core/models/user_model.dart';
import 'package:user_app/core/providers/auth_provider.dart' as authProvider;
import 'package:user_app/core/providers/orders_provider.dart';
import 'package:user_app/core/providers/user_data_provider.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/ui/widgets/log_in_suggestion.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

/// TODO adding aniamation on page transitioning
///
class BuyScreen extends StatefulWidget {
  List<BuyProductModel>? products;
  double totalPrice;
  BuyScreen({super.key, this.products, this.totalPrice = 0});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

///  details calculation with specifics
class _BuyScreenState extends State<BuyScreen> {
  /// userr info
  UserModel _userData = UserModel();
  double priceOfSingleProduct = 0;
  int _selectedPayment = 1;
  bool _isLoading = false;
  OrdersModel ordersModel = OrdersModel();

  @override
  void initState() {
    super.initState();
    priceOfSingleProduct = widget.products?.first.price ?? 0;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    //TODO this prefix is changed and working may occur problem in future
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'Order confirmation',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
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
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          'Choose payment option',
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
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
                              color: Colors.white),
                          child: Center(
                            child: RadioListTile(
                              title: Image(
                                image: const AssetImage(
                                    'assets/images/cash_on_delivery.jpg'),
                                alignment: Alignment.center,
                                height: 6.h,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
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
                              color: const Color(0xFFF4F4F4)),
                          child: RadioListTile(
                            title: Image(
                              image:
                                  const AssetImage('assets/images/pay_now.jpg'),
                              alignment: Alignment.center,
                              height: 6.h,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
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
                child: const Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Flexible(
                child: ListView.builder(
                    itemCount: widget.products?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// this is image section of the buy product
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.products?[index].imageUrl ??
                                              ''),
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
                                        widget.products?[index].title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                    width: 100,
                                    child: Padding(
                                      padding: EdgeInsets.all(4),

                                      /// this data will be fetched from argument
                                      child: Text(
                                        '\$${widget.products?[index].price}',
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.red[200],
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[300],
                                        fontSize: 10),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.red[300],
                                        borderRadius:
                                            BorderRadius.circular(30)),

                                    /// this data will be fetched from argument
                                    child: Center(
                                        child: Text(
                                      '${widget.products?[index].totalItemsOFSingleProduct}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    )),
                                  ),
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
                            'Total: \$${widget.totalPrice == 0 ? priceOfSingleProduct : widget.totalPrice}',
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
                        onTap: () async {
                          if (_userData.address.isEmpty ||
                              _userData.phoneNumber.isEmpty ||
                              _userData.fullName.isEmpty) {
                            Fluttertoast.showToast(
                              msg:
                                  'Please provide your valid information before placing the order',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.of(context)
                                .pushNamed(RouteName.updateUserInfo,
                              arguments: _userData,
                            );
                          } else {
                            // setState(() {
                            //   _isLoading = true;
                            // });

                            final ordersProvider = Provider.of<OrdersProvider>(
                                context,
                                listen: false);

                            ///  String id;
                            //   String customersId;
                            //   String thumbnailImageUrl;
                            //   String nameOfTheProduct;
                            //   String totalItemsOrdered;
                            //   String orderDate;
                            //   String? price;

                            ordersModel.customersId = _userData.id;

                            /// this data is processing inside provider

                            /// looping through length of data for uploading in database
                            for (int i = 0;
                                i < (widget.products?.length ?? 0);
                                i++) {
                              ordersModel.thumbnailImageUrl =
                                  widget.products?[i].imageUrl ?? "";
                              ordersModel.nameOfTheProduct =
                                  widget.products?[i].title ?? "";
                              ordersModel.totalItemsOrdered = widget
                                      .products?[i].totalItemsOFSingleProduct ??
                                  1;
                              ordersModel.price =
                                  widget.products?[i].price.toString();
                              ordersProvider
                                  .addOrdersToDatabase(ordersModel: ordersModel)
                                  .then((value) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text(
                                            'Remember'.toUpperCase(),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ),
                                          content: const Text(
                                              "On the delivery day arrange the amount of cash you orderd!"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ));
                              });
                            }

                            // setState(() {
                            //   _isLoading = false;
                            // });
                          }
                        },
                        child: Center(
                          child: Text(
                            _selectedPayment == 1 ? "Place order" : "Pay",
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
