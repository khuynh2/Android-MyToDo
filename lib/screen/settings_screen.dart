import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:term_project/model/userprofile.dart';

import 'view/mydialog.dart';

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
  File image;
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
                  RaisedButton(
                      color: Colors.blue,
                      onPressed: con.getPicture,
                      child: Text(
                        'Change',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      )),
                  Text('Username: ${userProfile[0].userName}'),
                  Text('Theme: ')
                ],
              ),
            )));
  }
}

class _Controller {
  _SettingsState _state;
  File imageFile;

  _Controller(this._state);

  void test() {
    print('working');
  }

  Future<void> getPicture() async {
    try {
      print('Picking image');
      PickedFile _image;
      _image = await ImagePicker().getImage(source: ImageSource.gallery);
      _state.render(() => imageFile = File(_image.path));
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Image capture error',
        content: e.message ?? e.toString(),
      );
    }
  }
}
