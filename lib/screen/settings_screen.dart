import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:term_project/model/userprofile.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/homeScreen/settingsScreen';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
  _Controller con;
  FirebaseUser user;
  List<User> userProfile;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    userProfile ??= arg['userProfile'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'Profile',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Container(),
                ],
              ),
            )));
  }
}

class _Controller {
  _SettingsState _state;

  _Controller(this._state);
}
