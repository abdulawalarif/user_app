import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/buy_product_model.dart';
import 'package:user_app/core/models/cart_model.dart';
import 'package:user_app/core/providers/cart_provider.dart';
import 'package:user_app/core/services/db_helper_cart.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/ui/screens/buy_screen/buy_screen_main.dart';
import 'package:user_app/ui/utils/my_alert_dialog.dart';
import 'package:user_app/ui/widgets/authenticate.dart';
import 'package:user_app/ui/widgets/empty_cart.dart';
import 'package:user_app/ui/widgets/my_button.dart';


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelperCart? dbHelper = DBHelperCart();
@override
  void initState() {
  dbHelper?.initDatabase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cart  = Provider.of<CartProvider>(context);
    return Authenticate(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Cart', style: TextStyle(color: Colors.black),),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,

          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                FutureBuilder(
                    future:cart.getData() ,
                    builder: (context , AsyncSnapshot<List<Cart>> snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data!.isEmpty){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 100,),
                              Center(child: EmptyCart()),
                            ],
                          );
                        }else {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index){
                                  return Container(
                                    margin:const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    height: 110,
                                    child: Card(
                                      child: InkWell(

                                        onTap: () => Navigator.pushNamed(
                                            context, RouteName.productDetailScreen,
                                            arguments: snapshot.data![index].productId


                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                          image: NetworkImage(snapshot.data![index].image.toString()),
                                                          fit: BoxFit.contain)),
                                                ),
                                                MyButton.smallIcon(
                                                  context: context,
                                                  icon: mIconDelete,
                                                  color: Colors.redAccent,
                                                  onPressed: () =>
                                                      MyAlertDialog().removeCartItem(context, () {
                                                        dbHelper!.delete(snapshot.data![index].productId!);
                                                        cart.removerCounter();
                                                        cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                        Navigator.pop(context);
                                                      }),
                                                ),
                                              ],
                                            ),
                                            Flexible(
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            snapshot.data![index].productName.toString(),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                         //   style: Theme.of(context).textTheme.bodyText1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Price: ',
                                                        ),
                                                        Text(
                                                          '\$${snapshot.data![index].productPrice.toString()}',
                                                        //  style: Theme.of(context).textTheme.caption,
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        MyButton.smallIcon(
                                                            context: context,
                                                            icon: mIconRemove,
                                                            color: snapshot.data![index].quantity! > 1
                                                                ? Colors.redAccent
                                                                : Theme.of(context).disabledColor,
                                                            onPressed: () {
                                                              int quantity =  snapshot.data![index].quantity! ;
                                                              int price = snapshot.data![index].initialPrice!;
                                                              quantity--;
                                                              int? newPrice = price * quantity ;

                                                              if(quantity > 0){
                                                                dbHelper!.updateQuantity(
                                                                    Cart(
                                                                        productId: snapshot.data![index].productId!.toString(),
                                                                        productName: snapshot.data![index].productName!,
                                                                        initialPrice: snapshot.data![index].initialPrice!,
                                                                        productPrice: newPrice,
                                                                        quantity: quantity,
                                                                        image: snapshot.data![index].image.toString())
                                                                ).then((value){
                                                                  newPrice = 0 ;
                                                                  quantity = 0;
                                                                  cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                }).onError((error, stackTrace){
                                                                  print(error.toString());
                                                                });
                                                              }
                                                            }
                                                        ),
                                                        Container(
                                                          width: 40,
                                                          height: 20,
                                                          child: TextField(
                                                            enabled: false,
                                                            keyboardType: TextInputType.number,
                                                            controller: TextEditingController(
                                                                text: snapshot.data![index].quantity.toString()),
                                                            maxLines: 1,
                                                         //   style: Theme.of(context).textTheme.bodyText1,
                                                            textAlign: TextAlign.center,
                                                            decoration:const  InputDecoration(
                                                              border: InputBorder.none,
                                                              fillColor: Colors.deepPurple,
                                                              isDense: true,
                                                              contentPadding: EdgeInsets.only(top: 2),
                                                            ),
                                                          ),
                                                        ),
                                                        MyButton.smallIcon(
                                                          context: context,
                                                          icon: mIconAdd,
                                                          color: Theme.of(context).primaryColor,
                                                          onPressed: () {

                                                            int quantity =  snapshot.data![index].quantity! ;
                                                            int price = snapshot.data![index].initialPrice!;
                                                            quantity++;
                                                            int? newPrice = price * quantity ;

                                                            dbHelper!.updateQuantity(
                                                                Cart(
                                                                    productId: snapshot.data![index].productId!.toString(),
                                                                    productName: snapshot.data![index].productName!,
                                                                    initialPrice: snapshot.data![index].initialPrice!,
                                                                    productPrice: newPrice,
                                                                    quantity: quantity,
                                                                    image: snapshot.data![index].image.toString())
                                                            ).then((value){
                                                              newPrice = 0 ;
                                                              quantity = 0;
                                                              cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                            }).onError((error, stackTrace){
                                                              print(error.toString());
                                                            });

                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }

                      }
                      return Text('') ;
                    }),

              ],
            ),
          ),

          bottomSheet: Consumer<CartProvider>(builder: (context, value, child){
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
              child: checkoutSection(totalAmount:value.getTotalPrice().toStringAsFixed(2)),
            );
          }),



        ),
      ),
    );
  }

  Widget checkoutSection({required var totalAmount}) {
    final cart  = Provider.of<CartProvider>(context);

    return Container(
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
                  Text('SubTotal ',
                      //style: Theme.of(context).textTheme.caption
                  ),
                  Flexible(
                    child: Text(
                      '\$$totalAmount',
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
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Material(
                color: Theme.of(context).primaryColor,
                child: InkWell(
                  onTap: () async {
                    print("onTap");
                   var allCartItemsList = await cart.getData();
                   List<BuyProductModel> productListFromCarts = [];
                   //
                    for(int i=0; i<allCartItemsList.length; i++){

                      productListFromCarts.add(
                          BuyProductModel(title: allCartItemsList[i].productName??"",
                                          imageUrl: allCartItemsList[i].image??"",
                                          price: (allCartItemsList[i].productPrice??0).toDouble(),
                                          totalItemsOFSingleProduct: allCartItemsList[i].quantity??0,/// will have to add.

                          ));
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            BuyScreen(proDucts: productListFromCarts, totalPrice: double.parse(totalAmount)),
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Checkout',
                      style: TextStyle(
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
    );
  }
}



class ReusableWidget extends StatelessWidget {
  final String title , value ;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ,
           // style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(value.toString() ,
            //style: Theme.of(context).textTheme.subtitle2,
          )
        ],
      ),
    );
  }
}