import 'dart:developer';
import 'dart:io';

import 'package:employe_task/firebase_options.dart';
import 'package:employe_task/provider/auth_provider.dart';
import 'package:employe_task/provider/user_provider.dart';
import 'package:employe_task/utlis/dio/dio.dart';
import 'package:employe_task/utlis/fcm/fcm_handler.dart';
import 'package:employe_task/utlis/messenger/snackbar.dart';
import 'package:employe_task/view/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await _setupLocalNotifications();

  runApp(MyApp());

  _initializeFCM();
}

Future<void> _setupLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _initializeFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  log('FCM Permission: ${settings.authorizationStatus}');

  // Get token
  String? token = await messaging.getToken();
  log('FCM Token: $token');

  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('FCM Foreground Message: ${message.notification?.title}');
    _showLocalNotification(message);
  });

  // When app opened from notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log('Notification clicked!');
  });
}

void _showLocalNotification(RemoteMessage message) {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? '',
    message.notification?.body ?? '',
    platformChannelSpecifics,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      builder: (BuildContext context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: Messenger.rootScaffoldMessengerKey,
          navigatorKey: MyRouter.navigatorKey,
          title: 'Employee Management',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: SplashScreen(),
        );
      },
    );
  }
}
