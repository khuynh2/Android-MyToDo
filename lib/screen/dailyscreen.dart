import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:term_project/controller/firebasecontroller.dart';
import 'package:term_project/model/userprofile.dart';
import 'package:term_project/screen/settings_screen.dart';
import 'package:term_project/screen/signin_screen.dart';

import 'view/myimageview.dart';

class DailyScreen extends StatefulWidget {
  static const routeName = '/todoScreen/dailyScreen';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DailyState();
  }
}

class _DailyState extends State<DailyScreen> {
  _Controller con;
  FirebaseUser user;
  List<User> userProfile;

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
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          appBar: AppBar(
            title: Text('MyDaily'),
            actions: <Widget>[],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: MyImageView.netowrk(
                      imageUrl: userProfile[0].userImageURL, context: context),
                  accountName: Text('${userProfile[0].userName}'),
                  accountEmail: Text(user.email),
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                  ),
                  title: Text('Settings'),
                  onTap: con.settings,
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sign out'),
                  onTap: con.signOut,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.tealAccent,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            //onPressed: con.addMyToDo,
          ),
          body: Text('tESTING'),
        ));
  }
}

class _Controller {
  _DailyState _state;
  _Controller(this._state);

  Future<void> signOut() async {
    try {
      await FireBaseController.signOut();
    } catch (e) {
      print('signOut exception: ${e.message}');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }

  void settings() async {
    await Navigator.pushNamed(_state.context, SettingsScreen.routeName,
        arguments: {'user': _state.user, 'userProfile': _state.userProfile});
    _state.render(() {});
    // await _state.user.reload();

    //   Navigator.pop(_state.context);
  }
}
