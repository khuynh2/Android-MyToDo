import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:term_project/controller/firebasecontroller.dart';
import 'package:term_project/model/todolist.dart';
import 'package:term_project/model/userprofile.dart';
import 'package:term_project/screen/addtodo_screen.dart';
import 'package:term_project/screen/settings_screen.dart';
import 'package:term_project/screen/signin_screen.dart';

import 'view/myimageview.dart';

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
    todoList ??= arg['todoList'];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
          appBar: AppBar(
            title: Text('MyToDo'),
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
            backgroundColor: Colors.indigo[800],
            child: Icon(Icons.add),
            onPressed: con.addMyToDo,
          ),
          body: todoList.length == 0
              ? Text(
                  'My To Do list',
                  style: TextStyle(fontSize: 30.0),
                )
              : ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (BuildContext contet, int index) => Container(
                    child: ListTile(
                      leading: Checkbox(
                          value: todoList[index].complete,
                          onChanged: (bool value) {
                            con.completeToDo(value, index);
                          }),
                      title: Text(todoList[index].title),
                      trailing: IconButton(
                          icon: Icon(Icons.mode_edit), onPressed: null),
                    ),
                  ),
                )),
    );
  }
}

class _Controller {
  _ToDoState _state;
  _Controller(this._state);
  bool complete;

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

  void addMyToDo() async {
    await Navigator.pushNamed(_state.context, AddToDoScreen.routName,
        arguments: {
          'user': _state.user,
          'userProfile': _state.userProfile,
          'todoList': _state.todoList
        });
    _state.render(() {});
  }

  void completeToDo(bool value, int index) {
    _state.todoList[index].complete = value;
    print(
        'complete ${_state.todoList[index].title} = ${_state.todoList[index].complete}');
    _state.render(() {});
  }
}
