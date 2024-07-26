import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosarica/ButtomBar.dart';
import 'package:kosarica/Controller/AppDetails_Controller.dart';

import 'Services/Notification_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  appDetails_controller controller = Get.put(appDetails_controller());
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    controller.fetchingStore();
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken();
    notificationServices.firebaseInit(context);

    // Listen for changes in the controller's status
    ever(controller.Loading, (bool isLoaded) {
      if (isLoaded) {
        // Ensure this is run on the UI thread
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AnimatedBar()));
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Kosarica Icon_cropped.png',
                scale: 0.9,
                height: 250,
              ),
              SizedBox(height: 20),
              Text("Please wait, data is loading"),
              SizedBox(height: 30),
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
