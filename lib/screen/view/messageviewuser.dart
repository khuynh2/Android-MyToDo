import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:term_project/controller/messagingcontroller.dart';
import 'package:term_project/model/message.dart';

class MessageViewUser extends StatefulWidget {
  @override
  _MessageViewUserState createState() => _MessageViewUserState();
}

class _MessageViewUserState extends State<MessageViewUser> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  final List<Message> message = [];
  String msg = ' ';

  @override
  void initState() {
    _fcm.subscribeToTopic('all');
    _fcm.onTokenRefresh.listen((fcmToken) {
      print(fcmToken);
    });
    _fcm.getToken();

    super.initState();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        setState(() {
          msg = message['notification']['title'];
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
        setState(() {
          msg = message['title'];
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
        setState(() {
          msg = message['title'];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox();
  }
}
