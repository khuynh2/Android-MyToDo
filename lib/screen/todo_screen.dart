import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:term_project/controller/controller.dart';
import 'package:term_project/controller/firebasecontroller.dart';
import 'package:term_project/model/todolist.dart';
import 'package:term_project/model/userprofile.dart';
import 'package:term_project/screen/addtodo_screen.dart';
import 'package:term_project/screen/edittodo_screen.dart';
import 'package:term_project/screen/settings_screen.dart';
import 'package:term_project/screen/signin_screen.dart';
import 'package:term_project/screen/view/myfilter.dart';

import 'view/mydialog.dart';
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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: con.filter,
              )
            ],
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
            onPressed: con.addMyToDo,
          ),
          body: todoList.length == 0
              ? Text(
                  'My To Do list',
                  style: TextStyle(fontSize: 30.0),
                )
              : ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (BuildContext contet, int index) {
                    if (todoList[index].complete != true) {
                      return Container(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 10,
                            child: ListTile(
                              leading: Checkbox(
                                  value: todoList[index].complete,
                                  onChanged: (bool value) {
                                    con.completeToDo(value, index);
                                  }),
                              title: Text(todoList[index].title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    todoList[index].dueDate == null
                                        ? ''
                                        : todoList[index]
                                            .dueDate
                                            .toString()
                                            .split("00:")
                                            .first,
                                  ),
                                  Text(
                                    todoList[index].note.length == 0
                                        ? ''
                                        : todoList[index].note,
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.mode_edit),
                                onPressed: () => con.editToDo(index),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  })),
    );
  }
}

class _Controller {
  _ToDoState _state;
  _Controller(this._state);
  bool complete;
  List<dynamic> tagsList;

  Future<void> signOut() async {
    try {
      await FireBaseController.signOut();
    } catch (e) {
      print('signOut exception: ${e.message}');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }

  void filter() {
    Set<dynamic> tagsSet = HashSet<dynamic>();
    String value;
    for (var i in _state.todoList) {
      if (i.tags != null) {
        tagsSet.addAll(i.tags);
      }
    }
    tagsList = tagsSet.toList();

    for (int i = 0; i < tagsList.length; i++) {
      print(tagsList[i]);
    }

    // MyFilter.info(
    //   context: _state.context,
    //   tagsSet: tagsSet,
    //   value: value,
    // );
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

  Future<void> completeToDo(bool value, int index) async {
    try {
      _state.todoList[index].complete = value;
      await FireBaseController.updateToDoComp(value, _state.todoList, index);
      print(
          'complete ${_state.todoList[index].title} = ${_state.todoList[index].complete}');
      _state.render(() {});
      Future.delayed(Duration(seconds: 2), () {
        delete(index);
      });
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Completion error',
        content: e.message ?? e.toString(),
      );
    }
  }

  void editToDo(int index) async {
    final change = await Navigator.pushNamed(
        _state.context, EditToDoScreen.routName,
        arguments: {
          'user': _state.user,
          'userProfile': _state.userProfile,
          'todoList': _state.todoList[index],
          'index': index,
        });
    delete(change);
    print("Back from edit");
    _state.render(() {});
    // await _state.user.reload();

    //   Navigator.pop(_state.context);
  }

  // String getDueDate(int index) {
  //   String due =
  //       Controller.formatDate(_state.todoList[index].dueDate.toString());
  //   if (due != null) {
  //     return due;
  //   }
  //   return 'Due';
  // }

  void delete(int indeX) {
    if (indeX != null) {
      print("delete at position: ${indeX}");
      _state.todoList.removeAt(indeX);
      _state.render(() {});
    }
  }
}
