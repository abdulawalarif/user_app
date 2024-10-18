class BuyProductModel {
  String prodId;
  double price;
  String title;
  String imageUrl;
  int totalItemsOFSingleProduct;

  BuyProductModel({
    required this.prodId,
    required this.price,
    required this.title,
    required this.imageUrl,
    required this.totalItemsOFSingleProduct,
  });
}
