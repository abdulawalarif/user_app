
class OrdersModel {
  final String orderId;
  final String customerId;
  final DateTime orderDate;
  final int totalItemsOrdered;
  final double totalAmount;
  final String paymentStatus;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<Product> products;

  OrdersModel({
    required this.orderId,
    required this.customerId,
    required this.orderDate,
    required this.totalItemsOrdered,
    required this.totalAmount,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
  });

  factory OrdersModel.loading() {
    return OrdersModel(
      orderId: '',
      customerId: '',
      orderDate: DateTime.now(),
      totalItemsOrdered: 0,
      totalAmount: 0,
      paymentStatus: '',
      status: '',
      createdAt: '',
      updatedAt: '',
      products: [],
    );
  }

  // Convert JSON to OrdersModel
  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      orderId: json['orderId'],
      customerId: json['customerId'],
      orderDate: DateTime.parse(json['orderDate']),
      totalItemsOrdered: json['totalItemsOrdered'],
      totalAmount: json['totalAmount'].toDouble(),
      paymentStatus: json['paymentStatus'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      products: (json['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }

  // Convert OrdersModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'orderDate': orderDate.toIso8601String(),
      'totalItemsOrdered': totalItemsOrdered,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }
}

class Product {
  final String productId;
  final String productName;
  final int quantity;
  final double pricePerUnit;
  final double totalPriceForThisItem;

  Product({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalPriceForThisItem,
  });

  // Convert JSON to Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      pricePerUnit: json['pricePerUnit'].toDouble(),
      totalPriceForThisItem: json['totalPriceForThisItem'].toDouble(),
    );
  }

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'pricePerUnit': pricePerUnit,
      'totalPriceForThisItem': totalPriceForThisItem,
    };
  }
}

// class ShippingAddress with ChangeNotifier {
//   String addressLine1 = '';
//   String addressLine2 = '';
//   String city = '';
//   String state = '';
//   String postalCode = '';
//   String country = '';
//   String latitude = '';
//   String longitude = '';
//   String formattedAddress = '';

//   ShippingAddress({
//     required this.addressLine1,
//     required this.addressLine2,
//     required this.city,
//     required this.state,
//     required this.postalCode,
//     required this.country,
//     required this.latitude,
//     required this.longitude,
//     required this.formattedAddress,
//   });

//   // Convert JSON to ShippingAddress
//   factory ShippingAddress.fromJson(Map<String, dynamic> json) {
//     return ShippingAddress(
//       addressLine1: json['addressLine1'],
//       addressLine2: json['addressLine2'],
//       city: json['city'],
//       state: json['state'],
//       postalCode: json['postalCode'],
//       country: json['country'],
//       latitude: json['latitude'].toString(),
//       longitude: json['longitude'].toString(),
//       formattedAddress: json['formattedAddress'],
//     );
//   }

//   // Convert ShippingAddress to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'addressLine1': addressLine1,
//       'addressLine2': addressLine2,
//       'city': city,
//       'state': state,
//       'postalCode': postalCode,
//       'country': country,
//       'latitude': latitude,
//       'longitude': longitude,
//       'formattedAddress': formattedAddress,
//     };
//   }
// }
