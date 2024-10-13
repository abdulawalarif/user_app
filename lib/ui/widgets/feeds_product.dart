import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/product_model.dart';
 import 'package:user_app/ui/widgets/feeds_dialog.dart';
import 'package:user_app/ui/widgets/my_button.dart';

class FeedsProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<ProductModel>(context, listen: false);
    double _productImageSize = MediaQuery.of(context).size.width * 0.45;
    return SizedBox(
      width: _productImageSize,
      height: _productImageSize + 120,
      child: Material(
        elevation: 0.4,
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
              context, RouteName.productDetailScreen,
              arguments: _product.id),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(
              children: [
                Container(
                  height: _productImageSize,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        /// TODO edited imageList
                          image: NetworkImage(_product.imageUrls![0]),
                          onError: (object, stacktrace) => {},
                          fit: BoxFit.contain,),),
                ),
                const    badges.Badge(
                //  toAnimate: false,
                //  shape: BadgeShape.square,
                //  badgeColor: Colors.deepPurple,
                  badgeContent:
                   Text('New', style:   TextStyle(color: Colors.white)),
                ),

                Padding(
                    padding:   EdgeInsets.only(left: 35.w, top: 2.h),
                    child: Container(
                        height: 3.5.h,
                        width: 7.w,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
                        child: Center(
                          child: MyButton.smallIcon(
                            context: context,
                            icon: Icons.more_vert,
                           // color: Theme.of(context).buttonColor,
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => FeedsDialog(
                                  productId: _product.id,
                                ),
                              );
                            },
                          ),
                        ),),),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _product.name,
                    overflow: TextOverflow.ellipsis,
                   // style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$ ${_product.price.toString()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16,),
                  ),
                  const SizedBox(height: 10),

                ],
              ),
            ),
          ],),
        ),
      ),
    );
  }
}
