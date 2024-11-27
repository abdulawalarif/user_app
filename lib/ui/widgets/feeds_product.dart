import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/product_model.dart';
import 'package:user_app/ui/widgets/feeds_dialog.dart';
import 'package:user_app/ui/widgets/my_button.dart';

class FeedsProduct extends StatelessWidget {
  const FeedsProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context, listen: false);
    double productImageSize = MediaQuery.of(context).size.width * 0.45;
    return SizedBox(
      width: productImageSize,
      height: productImageSize + 80,
      child: Material(
        elevation: 0.4,
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            RouteName.productDetailScreen,
            arguments: product.id,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: productImageSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrls![0]),
                        onError: (object, stacktrace) => {},
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  //here this logic is for new product badge if productd creatio date is less then a week it is gonna show new

                  isNew(dateOfCreation: product.createdAt)
                      ? const badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.square,
                            badgeColor: Colors.deepPurple,
                          ),
                          badgeContent: Text(
                            'New',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(left: 35.w, top: 2.h),
                    child: Container(
                      height: 3.5.h,
                      width: 7.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7)),
                      child: Center(
                        child: MyButton.smallIcon(
                          context: context,
                          icon: Icons.more_vert,
                          color: Colors.black,
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => FeedsDialog(
                                productId: product.id,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$ ${product.price.toString()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isNew({required String dateOfCreation}) {
    final now = DateTime.now();
    final creationDate = DateTime.parse(dateOfCreation);
    final difference = now.difference(creationDate).inDays;
    //Here i calculated time based on days change the number of days as you need
    return difference < 10;
  }
}
