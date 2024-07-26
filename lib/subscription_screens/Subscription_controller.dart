//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// // import 'package:purchases_flutter/purchases_flutter.dart';
//
// class subscription {
//   static const _Apikey="goog_SyUltPoRgOdcyGLQGrOzZbZJFWv";
//
//   static Future init()async{
//     await Purchases.setDebugLogsEnabled(true);
//     await Purchases.setup(_Apikey);
//   }
//
//   static Future<List<Offering>> fetchingoffers()async{
//     try{
//       final offerings=await Purchases.getOfferings();
//       final current = offerings.current;
//       return current==null ?[]:[current];
//
//     }on PlatformException catch(e){
//       return[];
//     }
//
//   }
// //..............................  there are the method for the fatching the data...................................
//
// static Future purchasePackage(Package package)async{
//     await Purchases.purchasePackage(package);
//
// }
//
//
//
//
//
//
// }