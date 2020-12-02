import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:term_project/controller/messagingcontroller.dart';
import 'package:term_project/model/message.dart';

class MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  _Controller con;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final TextEditingController titleController =
      TextEditingController(text: 'Title');
  final TextEditingController bodyController =
      TextEditingController(text: 'Message');
  final TextEditingController topicController =
      TextEditingController(text: 'Topic');
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: bodyController,
            decoration: InputDecoration(labelText: 'Message'),
          ),
          TextFormField(
            controller: topicController,
            decoration: InputDecoration(labelText: 'Topic'),
          ),
          RaisedButton(
            onPressed: con.sendNotificationTopic,
            child: Text('Send notification to User'),
          ),
          RaisedButton(
            onPressed: con.sendNotificationAll,
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
}

class _Controller extends ControllerMVC {
  _MessageViewState _state;
  _Controller(this._state);

  void test() {
    print("Fine");
  }

  Future sendNotificationAll() async {
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

  Future sendNotificationTopic() async {
    Future.delayed(Duration(milliseconds: 0), () async {
      final response = await MessagingController.sendToTopic(
          title: _state.titleController.text,
          body: _state.bodyController.text,
          topic: _state.topicController.text);

      if (response.statusCode != 200) {
        Scaffold.of(_state.context).showSnackBar(SnackBar(
          content:
              Text('[${response.statusCode}] Error message: ${response.body}'),
        ));
      }
    });
  }
}
