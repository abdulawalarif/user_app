// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// Future<void> makePayment({required String amount}) async {
//
//    try {
//     Map<String, dynamic> paymentIntent   = await createPaymentIntent(amount, 'GBP');
//
//     var gpay = PaymentSheetGooglePay(merchantCountryCode: "GB",
//         currencyCode: "GBP",
//         testEnv: true);
//
//     //STEP 2: Initialize Payment Sheet
//     await Stripe.instance
//         .initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: paymentIntent[
//             'client_secret'], //Gotten from payment intent
//             style: ThemeMode.light,
//             merchantDisplayName: 'Awal',
//             googlePay: gpay))
//         .then((value) {});
//
//     //STEP 3: Display Payment sheet
//     displayPaymentSheet();
//   } catch (err) {
//     print(err);
//   }
// }
//
// displayPaymentSheet() async {
//   try {
//     await Stripe.instance.presentPaymentSheet().then((value) {
//       print("Payment Successfully");
//     });
//   } catch (e) {
//     print('$e');
//   }
// }
//
// createPaymentIntent(String amount, String currency) async {
//   try {
//     Map<String, dynamic> body = {
//       'amount': amount,
//       'currency': currency,
//     };
//
//     var response = await http.post(
//       Uri.parse('https://api.stripe.com/v1/payment_intents'),
//       headers: {
//         'Authorization': 'Bearer sk_test_51NEQ3QIjwsvyjmzSi2CGfQEV1kyG5nr39OIZ9iiuiNHjQrX6QGkzv0VFjgUKnjPfVKmXpOsvzhEJUBgpt0SDc8bB00xu7xAXEA',
//         'Content-Type': 'application/x-www-form-urlencoded'
//       },
//       body: body,
//     );
//     return json.decode(response.body);
//   } catch (err) {
//     throw Exception(err.toString());
//   }
// }
//
