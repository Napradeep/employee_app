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
      final accountCredentials = ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "fir-877f2",
        "private_key_id": "68e6b56c2e3bf3613e8071055129340d9fce07f1",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDxRK4MGjgKud76\n6GFptrNkXdp7t3BfCPJHYfTwHwjeqNOL3lcFyJ4dd7sshRUfvz58wd5cK+9ijvF+\nEeIdhPUv0DEmgAW+YJuR4yaVGLj0Me5xPaw1OssWwslgeNJtwcV1/W0sLQJYLrfu\nAT9UPrQIsiHpSVgHIYV2lJCzYFKHH6JU+iqlb1JAwdzQP0yPF2uxgXPiwl0jfkDI\nlI0bIVmedEDuT/KtsBlR+YLJ2t+ETI0hE3qIPvJce/4IKcWE794YY5/5AfimYoyg\nhXAPSCtfCQFPYldZ0VloUu5R1hME0MS9/cw9U3TenSPfZUFnO+hKFi3bVvwb/oQx\npKY/1UdzAgMBAAECggEAMJdDcl6JcOeUV/YbQF4ybQFV8lq0f/9eRDAfU4j8kVNx\nH5dM8XZBGfA2OzYmVfl/TUMCVI/oq3HcgyZ44rcXZmTIsVdRUNFGI7Ca4aZUAaJY\nwmfIWgQYSOI8Cnjq8H35FdVPenkqIrZuBrorlfz251Vw7Pn/h5ghuAsdxXKdzGaX\nfi6lGovFLV+V9skYtjWcBf8NKUm8+VIxVs1eDqBXJGhTRZV3cTzYGEOb5H+ueAjh\nWnuTzozGPkofL5wV+UrKxNNpFj3ar49ghN1M3UcEPT1jYDAfeJprkOJr+YttWvGX\nAGqBZVW13u75ipJFUE88czCBsc3JOXOqewDkSxtZ2QKBgQD8HO9IjnUvYPSCCbJR\nfXzfNzCl5Spl3Y3JuMHv0FdWpNOFcg3/bbO4/VtM+jhb9mXbQ/ixJ3SLTev5XQeA\n5xh+TthlXiDYsyZ9fPglKESGnQWQWcobB4HUssqQhHTrXMrG20tZiFR1yD6Yqkqu\n+YhsjI/Whd3POUbYqypCrBbn3wKBgQD0/PEoyEXhc2Ls6ayztQXvxUIPozGNliLX\ncAyNHdKlpjfx+AZY/A68v2BHEiZiRvwZi2SjhApLiJdmDtwagHY4rJVCD0DD1VNe\n8kCWyRHtkDGhEXTJlWbFLG1BHfqh+dqMDcOxuc3YL+WLx1lMiR2Utp7v0IcjtPw2\n9x6Qussi7QKBgQC7yRWWVr4Eh1Q4U96lgjHz1Zj/yH1XGLqW6W5TIT0cxXLkL/sr\nKdw3S0epQ6udHB/sPWnNEpVleantuJRxODDvS+01O/J9Vpux1tbCXocEOYs+ZRL8\nJRBYjMAC+xZXhWtoyUkLrFc0z+2IKzersyQhrmUpJdb8li4mDwBQXvxEwwKBgQDh\njLK2elQj8ailN6nhtYrmqfRdE0E++nfPYwCbN1bFXVfqdQ/bAwzKZ2NLa4FdP79A\nAV7BUIJt8i55LrsjxxuQqAuuyv40jgV4x44BhNL1paibgsfEA8GfTHy109T5JWA5\nSz7dNJQ4MjiizQEA/sf2L3/6iECy9iCytic01lTJLQKBgHEewLZJ/cG3PUWdn0T5\nSPpEfobaWFriKSOLd7M6/RefYzxBPwbA9bij3C3QH68WdnqL8ptUU4h3fkQnI8BX\n300o8JZNhZKq1gG29WqNFaAJmNYYVi5KJr3IOPAb833s7ICovtG2uColUQdbGiug\n+1xXjQE9x4an857LITO2MOYR\n-----END PRIVATE KEY-----\n",
        "client_email": "employee-task@fir-877f2.iam.gserviceaccount.com",
        "client_id": "117373961592541442349",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/employee-task%40fir-877f2.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      });

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
