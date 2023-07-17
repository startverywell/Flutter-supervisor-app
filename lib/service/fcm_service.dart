import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FCMService {
  static sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                "key=AAAA0wJIbDc:APA91bHIC8j7Tx5BpZ8OImhnieMQlRRgOJe_FhuYfBXpydL4b0QdgTgywqWdC45Van6SwWVfh0sZ_ZhAOeH8wPsIIhVeagS5X8hpLnmLYn_-xCD-pQwNOkgKV4vZp9Lko_lpT00CfpLC",
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
              },
              'notification': <String, dynamic>{
                'title': title,
                'body': body,
                'android_channel_id': 'channelId'
              },
              'to': token,
            },
          ));
    } catch (e) {
      if (kDebugMode) {
        print("error push notification" + e.toString());
      }
    }
  }
}
