import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:term_project/controller/firebasecontroller.dart';

import 'package:term_project/model/userprofile.dart';
import 'package:term_project/screen/todo_screen.dart';

import 'messagehandler.dart';
import 'view/mydialog.dart';
import 'view/myimageview.dart';

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
          actions: <Widget>[
            IconButton(icon: Icon(Icons.check), onPressed: con.save)
          ],
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: con.imageFile == null
                        ? MyImageView.netowrk(
                            imageUrl: userProfile[0].userImageURL,
                            context: context)
                        : Image.file(con.imageFile, fit: BoxFit.fill),
                  ),
                  RaisedButton(
                      onPressed: con.getPicture,
                      child: Text(
                        'Change',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      )),
                  Text('Username: ${userProfile[0].userName}'),
                  Text('Theme: '),
                ],
              ),
            )));
  }
}

class _Controller {
  _SettingsState _state;
  File imageFile;
  String uploadProgressMessage;

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

  void save() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();

    //upload to storage
    try {
      MyDialog.circularProgressStart(_state.context);
      if (imageFile != null) {
        Map<String, String> profile = await FireBaseController.uploadStorage(
            uid: _state.user.uid,
            image: imageFile,
            listener: (double progressPercentage) {
              _state.render(() {
                uploadProgressMessage =
                    'Uploading: ${progressPercentage.toStringAsFixed(1)}';
              });
            });

        print('========= ${profile["path"]}');
        print('========= ${profile["url"]}');

        print(
            '========= updating profile for user ${_state.userProfile[0].email}');
        User userP = User(
            email: _state.userProfile[0].email,
            userName: _state.userProfile[0].userName,
            userRole: _state.userProfile[0].userRole,
            userImage: profile['path'],
            userImageURL: profile['url']);

        await FireBaseController.updateUserProfile(userP, _state.userProfile);
        MyDialog.CircularProgressEnd(_state.context);

        // await Navigator.pushNamed(_state.context, ToDoScreen.routeName,
        //     arguments: {
        //       'user': _state.user,
        //       'userProfile': _state.userProfile
        //     });

        _state.userProfile.insert(0, userP);
        Navigator.pop(_state.context);
      }
    } catch (e) {
      MyDialog.CircularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Firebase Error',
        content: e.message ?? e.toString(),
      );
    }
  }
}
