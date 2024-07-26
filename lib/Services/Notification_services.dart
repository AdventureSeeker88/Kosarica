import 'dart:io';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {
      //AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitilization =
    const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitilizationSettings = const DarwinInitializationSettings();

    var initialzationSetting = InitializationSettings(
      android: androidInitilization,
      iOS: iosInitilizationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initialzationSetting,
        onDidReceiveNotificationResponse: (payload) {
          handleMessage(context, message);
        });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      if (kDebugMode) {
        print("event message title: ${event.notification!.title.toString()}");
        print("event message body: ${event.notification!.body.toString()}");
        print("event message data: ${event.data.toString()}");
      }
      if (Platform.isAndroid) {
        initLocalNotification(context, event);
        showNotification(event);
      } else {
        showNotification(event);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    print("showNotification ***********************************");

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
        "com.therapist.mender", "High Importance Notifications",
        importance: Importance.max,
        description: 'This channel is used for important notifications.');
    AndroidNotificationDetails androidNotificationDetails;
    if (message.data['image'] == "" || message.data['image'] == null) {
      androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
      );
    } else {
      String image = "";
      // await urlToFile(
      //   message.data['image'],
      // ).then((value) {
      //   image = value;
      // });

      androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(image),
          hideExpandedLargeIcon: false,
        ),
      );
    }

    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    try {
      Future.delayed(
        Duration.zero,
            () {
          _flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            notificationDetails,
          );
        },
      );
    } catch (e) {
      print("exception **********************$e");
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("token: $token");
    return token!;
  }

  void iSTokenRefreh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print("refresh");
      }
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
//terminated

    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // ignore: use_build_context_synchronously
      handleMessage(context, initialMessage);
    }

    //background

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  handleMessage(BuildContext context, RemoteMessage message) async {
    // if (message.data['type'] == 'chat') {
    //   Navigator.of(context);
    //   context.pushNamed(message.data['location'], params: {
    //     'oppisteruid': message.data['senderId'],
    //     'color': themeorangecolor.value.toString(),
    //   });
    // } else if (message.data['type'] == 'pa-post') {
    //   Navigator.of(context);
    //   context.pushNamed(message.data['location'], params: {
    //     'id': message.data['feedid'],
    //   });
    // } else if (message.data['type'] == 'following') {
    //   Navigator.of(context);
    //   context.pushNamed(message.data['location'], params: {
    //     'uid': message.data['senderid'],
    //   });
    // } else if (message.data['type'] == 'pa-story') {
    //   Navigator.of(context);
    //   context.pushNamed(message.data['location'], params: {
    //     'uid': message.data['senderid'],
    //   });
    // } else {}
  }
}
