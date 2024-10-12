import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/brand_model.dart';
import 'package:user_app/core/models/carousel_model.dart';
import 'package:user_app/core/models/category_model.dart';
import 'package:user_app/core/providers/cart_provider.dart';

import 'package:user_app/core/providers/product_provider.dart';
import 'package:user_app/ui/widgets/category.dart';
import 'package:user_app/ui/widgets/my_carousel.dart';
import 'package:user_app/ui/widgets/popular_brand.dart';
import 'package:user_app/ui/widgets/popular_product.dart';
import 'package:user_app/ui/widgets/recommendation.dart';

import 'package:badges/badges.dart' as b;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CarouselModel> carouselImages = [];
  List<CategoryModel> categories = [];
  List<BrandModel> popularBrands = [];

  getCarouselImage() {
    carouselImages = CarouselModel().getCarouselImages();
  }

  getCategories() {
    categories = CategoryModel().getCategories();
  }

  getPopularBrands() {
    popularBrands = BrandModel().getBrands();
  }

  @override
  void initState() {
    super.initState();
    getCarouselImage();
    getCategories();
    getPopularBrands();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            pinned: true,
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.cartScreen);
                },
                child: Center(
                  child: b.Badge(
                    showBadge: true,
                    badgeContent: Consumer<CartProvider>(
                      builder: (context, value, child) {
                        return Text(value.getCounter().toString(),
                            style: const TextStyle(color: Colors.white));
                      },
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
            ],
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: MyCarousel(
                imageList: carouselImages,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories section
      
                  _sectionTitle('CATEGORIES', () {}),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 10.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) =>
                          Category(category: categories[index]),
                    ),
                  ),
      
                  // Popular Brands Section
      
                  _sectionTitle('POPULAR BRANDS', () {}),
      
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    child: GridView.count(
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 2,
                      padding:  const EdgeInsets.symmetric(horizontal: 8),
                      children: List.generate(
                          popularBrands.length,
                          (index) => Center(
                                  child: PopularBrand(
                                brand: popularBrands[index],
                              ),),),
                    ),
                  ),
      
                  // Popular Product Section
      
                  _sectionTitle(
                      'POPULAR PRODUCTS',
                      () => Navigator.pushNamed(context, RouteName.categoryScreen,
                          arguments: 'Popular Products ',),),
      
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Consumer<ProductProvider>(
                      builder: (_, consumerProvider, __) => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        itemCount: consumerProvider.popularProducts.length,
                        itemBuilder: (context, index) =>
                            ChangeNotifierProvider.value(
                          value: consumerProvider.popularProducts[index],
                          child:  const PopularProduct(),
                        ),
                      ),
                    ),
                  ),
      
                  // Recommendations Section
      
                  _sectionTitle('RECOMMENDATIONS', () {}),
                  Consumer<ProductProvider>(
                    builder: (_, productProvider, __) => Center(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: productProvider.products
                            .map((product) => ChangeNotifierProvider.value(
                                value: product, child: Recommendation(),),)
                            .toList(),
                      ),
                    ),
                  ),
      
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),),
    );
  }

  Widget _sectionTitle(String title, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 26, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            //  style: Theme.of(context).textTheme.headline6,
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              'More>',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).unselectedWidgetColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
