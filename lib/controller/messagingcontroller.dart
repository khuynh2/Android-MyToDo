import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class MessagingController {
  static final Client client = Client();
  static FirebaseMessaging fcm = FirebaseMessaging();

  static const String serverKey =
      'AAAAuzgIDlA:APA91bEbIFEeTT_mGkTGT1Wme8iFoLZtkuRL7PUgqxj4r1BgKxUZQTe33ceSq8VQH_pP0mcu1Fj7r3WmI0oerKcWCRSj4NsQNzBP6qyRNglcMCAuPsH-U7UzMqZMnPpNyiGHQtBVwRTd';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
          {@required String title,
          @required String body,
          @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );

  static void fcmSubscribe(String topic) {
    fcm.subscribeToTopic(topic);
    print("Subscribed");
  }

  static void fcmUnSubscribe(String topic) {
    fcm.unsubscribeFromTopic(topic);
    print("UnSubscribed" + topic);
  }
}
