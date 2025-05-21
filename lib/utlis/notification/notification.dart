import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  String? _token;
  String? _accessToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getAccessToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token;
  }

  Future<void> getAndPrintToken() async {
    String? token = await getAccessToken();
    if (token != null) {
      log("FCM Token: $token");
    } else {
      log("Failed to get FCM Token");
    }
  }

  Future<void> requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("User granted permission for notifications.");
    } else {
      log("User denied permission for notifications.");
    }
  }

  Future<void> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      _token = token;
      log('FCM Token: $_token');

      if (Platform.isIOS) {
        await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      log('Error getting FCM token: $e');
    }
  }

  Future<void> obtainAccessToken() async {
    try {
      final accountCredentials = ServiceAccountCredentials.fromJson(

      
      );

      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final authClient = await clientViaServiceAccount(
        accountCredentials,
        scopes,
      );
      _accessToken = authClient.credentials.accessToken.data;
      log('Access Token: $_accessToken');
    } catch (e) {
      log('Error obtaining access token: $e');
    }
  }

  String? get token => _token;
  String? get accessToken => _accessToken;
}
