import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:term_project/controller/firebasecontroller.dart';
import 'package:term_project/model/dailylist.dart';
import 'package:term_project/model/todolist.dart';
import 'package:term_project/model/userprofile.dart';
import 'package:term_project/screen/adddailyscreen.dart';
import 'package:term_project/screen/settings_screen.dart';
import 'package:term_project/screen/signin_screen.dart';
import 'package:term_project/screen/todo_screen.dart';
import 'package:term_project/screen/view/mydialog.dart';

import 'view/myimageview.dart';

class DailyScreen extends StatefulWidget {
  static const routeName = '/dailyScreen';

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
  List<DailyList> dailyList;
  List<ToDoList> todoList;

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
    dailyList ??= arg['dailyList'];
    todoList ??= arg['todoList'];

    return Scaffold(
        appBar: AppBar(
          title: Text('MyDaily'),
          actions: <Widget>[],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                child: Text("To Do"),
                highlightColor: Colors.red,
                onPressed: con.todo,
              ),
              SizedBox(width: 20),
              FlatButton(
                child: Text("Daily"),
                highlightColor: Colors.red,
                //onPressed: con.daily
              )
            ],
          ),
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
          onPressed: con.addMyDaily,
        ),
        body: dailyList.length == 0
            ? Text(
                'Daily list',
                style: TextStyle(fontSize: 30.0),
              )
            : ListView.builder(
                itemCount: dailyList.length,
                itemBuilder: (BuildContext contet, int index) {
                  if (true) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.remove),
                            ),
                            title: Center(child: Text(dailyList[index].title)),
                            trailing: IconButton(icon: Icon(Icons.add)),
                          )),
                    );
                  }
                },
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
  }

  void todo() async {
    print(_state.todoList[0].email);
    try {
      MyDialog.CircularProgressEnd(_state.context);
      await Navigator.pushNamed(_state.context, ToDoScreen.routeName,
          arguments: {
            'user': _state.user,
            'userProfile': _state.userProfile,
            'todoList': _state.todoList,
            //'dailyList': _state.dailyList
          });
    } catch (e) {
      MyDialog.CircularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Navigating error',
        content: 'Try again later! \n ${e.message}',
      );
    }

    // _state.render(() {});
    // Navigator.of(_state.context, rootNavigator: true).pop(_state.context);
    //Navigator.pop(_state.context);
  }

  void addMyDaily() async {
    await Navigator.pushNamed(_state.context, AddDailyScreen.routName,
        arguments: {
          'user': _state.user,
          'userProfile': _state.userProfile,
          'dailyList': _state.dailyList,
        });
    print("Back from addDaily");
    _state.render(() {});
  }
}
