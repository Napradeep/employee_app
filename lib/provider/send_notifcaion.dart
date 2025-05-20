import 'dart:convert';
import 'dart:developer';
import 'package:employe_task/utlis/notification/notification.dart';
import 'package:http/http.dart' as http;

class SendNotifcaion {
  static const String _fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/fir-877f2/messages:send';

  static Future<void> sendPushNotification({
    required String targetToken,
    required String title,
    required String body,
  }) async {
    await FCMService().obtainAccessToken();
    String? accessToken = FCMService().accessToken;
    log(accessToken.toString());
    final Map<String, dynamic> message = {
      "message": {
        "token": targetToken,
        "notification": {"title": title, "body": body},
      },
    };
    log(message.toString());

    final response = await http.post(
      Uri.parse(_fcmEndpoint),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print(' Notification sent successfully.');
    } else {
      print('Failed to send notification: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }
}
