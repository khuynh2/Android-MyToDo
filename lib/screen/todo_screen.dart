import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:term_project/controller/firebasecontroller.dart';
import 'package:term_project/model/userprofile.dart';
import 'package:term_project/screen/settings_screen.dart';
import 'package:term_project/screen/signin_screen.dart';

class ToDoScreen extends StatefulWidget {
  static const routeName = '/signInScreen/todoScreen';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ToDoState();
  }
}

class _ToDoState extends State<ToDoScreen> {
  _Controller con;
  FirebaseUser user;
  List<User> userProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    userProfile ??= arg['userProfile'];

    return Scaffold(
      appBar: AppBar(
        title: Text('My To Do'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
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
      floatingActionButton: FloatingActionButton(),
      body: Text("data"),
    );
  }
}

class _Controller {
  _ToDoState _state;
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
    await _state.user.reload();
    Navigator.pop(_state.context);
  }
}
