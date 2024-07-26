import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kosarica/ButtomBar.dart';
import 'package:kosarica/Languages/Languages.dart';
import 'package:kosarica/Splash_screen.dart';
import 'package:kosarica/cart_item.g.dart';
import 'package:kosarica/core.dart';
import 'package:flutter/material.dart';
import 'package:kosarica/kosarica_pocetna_screen.dart';
import 'package:kosarica/subscription_screens/Subscription_controller.dart';
import 'package:kosarica/subscription_screens/add_card.dart';
import 'package:kosarica/subscription_screens/subscription.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Initialize Hive boxes, open box if exists or create a new one
  Hive.registerAdapter<CartItem>(CartItemAdapter());
  await Hive.openBox("cart_items");
  await Hive.openBox("F_catagories");
  await Hive.openBox("F_offers");
  // insilizing the firebase push notifications
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  MobileAds.instance.initialize();
  // await subscription.init();

  // Request permissions for push notifications

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// Future<String> getDeviceToken() async {
//   String? token = await FirebaseMessaging.instance.getToken();
//   print("token: $token");
//   return token!;
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Language(),
      locale: Locale("hr", "croatia"),
      fallbackLocale: Locale("eng", "US"),
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'kosarica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
