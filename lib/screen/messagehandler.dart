import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:term_project/controller/messagingcontroller.dart';
import 'package:term_project/model/message.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  _Controller con;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final TextEditingController titleController =
      TextEditingController(text: 'Title');
  final TextEditingController bodyController =
      TextEditingController(text: 'Body123');
  final List<Message> message = [];
  String msg = ' ';

  @override
  void initState() {
    _fcm.subscribeToTopic('all');
    _fcm.onTokenRefresh.listen(con.sendTokenToServer);
    _fcm.getToken();

    super.initState();
    con = _Controller(this);
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

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('testing'),
      ),
      body: ListView(
        children: <Widget>[
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: bodyController,
            decoration: InputDecoration(labelText: 'Body'),
          ),
          RaisedButton(
            onPressed: con.sendNotification,
            child: Text('Send notification to all'),
          ),
        ]..addAll(message.map(buildMessage).toList()),
      ),
    );
  }

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );

  // Future sendNotification() async {
  //   final response = await MessagingController.sendToAll(
  //     title: titleController.text,
  //     body: bodyController.text,
  //     // fcmToken: fcmToken,
  //   );
  // }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    // send key to your server to allow server to use
    // this token to send push notifications
  }
}

class _Controller extends ControllerMVC {
  _MessageHandlerState _state;
  _Controller(this._state);

  void sendTokenToServer(String fcmToken) {
    if (fcmToken != null) {
      print('Token: $fcmToken');
    } else {}
  }

  void test() {
    print("Fine");
  }

  Future sendNotification() async {
    Future.delayed(Duration(milliseconds: 0), () async {
      final response = await MessagingController.sendToAll(
          title: _state.titleController.text, body: _state.bodyController.text
          // fcmToken: fcmToken,
          );

      if (response.statusCode != 200) {
        Scaffold.of(_state.context).showSnackBar(SnackBar(
          content:
              Text('[${response.statusCode}] Error message: ${response.body}'),
        ));
      }
    });
  }
}
