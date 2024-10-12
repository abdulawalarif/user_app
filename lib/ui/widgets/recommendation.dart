import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/product_model.dart';

class Recommendation extends StatefulWidget {
  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<ProductModel>(context);
    double _productImageSize = MediaQuery.of(context).size.width * 0.45;

    return Container(
      width: _productImageSize,
      child: Material(
        elevation: 0.4,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
              context, RouteName.productDetailScreen,
              arguments: _product.id),
          child: Container(
            color: Theme.of(context).cardColor,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: _productImageSize,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      /// TODO edited imageList
                        image: NetworkImage(_product.imageUrls![0]),
                        fit: BoxFit.contain)),
              ),
              Container(
                margin: EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        _product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                       // style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$ ${_product.price}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14),
                        ),

                      ],
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
