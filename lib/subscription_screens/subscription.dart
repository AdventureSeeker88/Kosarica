// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:kosarica/constants/color_text.dart';
//
// class SubscriptionPage extends StatefulWidget {
//   const SubscriptionPage({super.key});
//
//   @override
//   _SubscriptionPageState createState() => _SubscriptionPageState();
// }
//
// class _SubscriptionPageState extends State<SubscriptionPage> {
//   final InAppPurchase _iap = InAppPurchase.instance;
//   bool _available = true;
//   List<ProductDetails> _products = [];
//   bool _loading = true;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//     final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (error) {
//       // Handle error
//     });
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
//
//   Future<void> _initialize() async {
//     _available = await _iap.isAvailable();
//     if (_available) {
//       const Set<String> _kIds = {'kosarica_monthly', 'kosarica_yearly'};
//       final ProductDetailsResponse response = await _iap.queryProductDetails(_kIds);
//       if (response.error == null) {
//         setState(() {
//           _products = response.productDetails;
//           _loading = false;
//         });
//       }
//     }
//   }
//
//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     for (var purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         // Show pending UI
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           // Handle error
//         } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
//           bool valid = _verifyPurchase(purchaseDetails);
//           if (valid) {
//             // Deliver the product
//           } else {
//             // Deliver an error
//           }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           InAppPurchase.instance.completePurchase(purchaseDetails);
//         }
//       }
//     }
//   }
//
//   bool _verifyPurchase(PurchaseDetails purchaseDetails) {
//     // Verify the purchase details with your backend server
//     return true;
//   }
//
//   void _buyProduct(ProductDetails product) {
//     final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
//     _iap.buyNonConsumable(purchaseParam: purchaseParam);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: _loading
//             ? Center(child: CircularProgressIndicator())
//             : CustomScrollView(
//           scrollDirection: Axis.vertical,
//           slivers: [
//             SliverFillRemaining(
//               hasScrollBody: false,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 40, left: 18, right: 18),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Card(
//                         elevation: 10,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                               top: 25, left: 10, right: 10, bottom: 40,
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Container(
//                                       height: 5,
//                                       width: 70,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                         color: Colors.grey.shade300,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 30,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: const Icon(
//                                             Icons.arrow_back,
//                                             size: 30,
//                                           ),
//                                         ),
//                                         Text(
//                                           'Our Plans        ',
//                                           style: heading1,
//                                         ),
//                                         const Text(''),
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       height: 60,
//                                     ),
//                                     _buildSubscriptionOption(
//                                       title: '\$9.99',
//                                       subtitle: '/Monthly',
//                                       onTap: () {
//                                         if (_products.isNotEmpty) {
//                                           _buyProduct(_products.firstWhere(
//                                                 (product) => product.id == 'kosarica_monthly',
//                                           ));
//                                         }
//                                       },
//                                     ),
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                     _buildSubscriptionOption(
//                                       title: '\$19.99',
//                                       subtitle: '/Yearly',
//                                       onTap: () {
//                                         if (_products.isNotEmpty) {
//                                           _buyProduct(_products.firstWhere(
//                                                 (product) => product.id == 'kosarica_yearly',
//                                           ));
//                                         }
//                                       },
//                                     ),
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubscriptionOption({required String title, required String subtitle, required VoidCallback onTap}) {
//     return Container(
//       height: 100,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: const Color(0xffFF9F1A),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 15, right: 15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: Text(
//                     subtitle,
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w300,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             InkWell(
//               onTap: onTap,
//               child: Container(
//                 height: 40,
//                 width: 105,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   color: Colors.white,
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'Subscribe',
//                     style: TextStyle(
//                       color: Color(0xffFF9F1A),
//                       fontWeight: FontWeight.w500,
//                       fontSize: 17,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
