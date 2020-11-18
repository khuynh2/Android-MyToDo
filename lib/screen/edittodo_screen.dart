import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:term_project/controller/firebasecontroller.dart';
import 'package:term_project/model/todolist.dart';
import 'package:term_project/model/userprofile.dart';

import 'view/mydialog.dart';

class EditToDoScreen extends StatefulWidget {
  static const routName = '/todoScreen/editToDoScreen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditToDoState();
  }
}

class _EditToDoState extends State<EditToDoScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  FirebaseUser user;
  List<User> userProfile;
  ToDoList todoList;
  int indeX;

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
    indeX ??= arg['index'];
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit to do'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: con.save,
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  width: 350,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: todoList.title,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        autocorrect: true,
                        validator: con.validatorTitle,
                        onSaved: con.onSavedTitle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: todoList.note.length == 0
                              ? 'Description'
                              : todoList.note,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        autocorrect: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        //validator: con.validatorNote,
                        onSaved: con.onSavedNote,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Tags: ',
                      ),
                      Wrap(
                        spacing: 10.0,
                        children: <Widget>[
                          if (todoList.tags != null)
                            for (var i in todoList.tags)
                              Container(
                                padding: EdgeInsets.all(5.0),
                                color: Colors.grey[800],
                                child: Text('${i.toString().trim()}'),
                              ),
                        ],
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Enter new tags',
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        autocorrect: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onSaved: con.onSavedTags,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Due: ',
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'mm/dd/yy',
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),

                        autocorrect: true,
                        keyboardType: TextInputType.datetime,

                        //validator: con.validatorMemo,
                        //onSaved: con.onSavedLabel,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      FlatButton(
                        onPressed: con.delete,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Delete this task',
                              style: TextStyle(color: Colors.red),
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }
}

class _Controller {
  _EditToDoState _state;
  _Controller(this._state);

  List<dynamic> tags;
  String uploadProgressMessage;

  Future<void> save() async {
    if (!_state.formKey.currentState.validate()) return;
    _state.formKey.currentState.save();

    try {
      await FireBaseController.updateToDo(_state.todoList);
      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.CircularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Error saving',
        content: e.message ?? e.toString(),
      );
    }
  }

  Future<void> delete() async {
    try {
      await FireBaseController.deleteToDo(_state.todoList);
      Navigator.pop(_state.context, _state.indeX);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Delete To do task error',
        content: e.message ?? e.toString(),
      );
    }
  }

//validator
  String validatorTitle(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

//save
  String onSavedTitle(String value) {
    if (value != null) {
      print("Testing **********");
      print(value);
      _state.todoList.title = value;
    }
  }

  String onSavedNote(String value) {
    if (value != null) {
      _state.todoList.note = value;
    }
  }

  String onSavedTags(String value) {
    if (value.trim().length != 0) {
      _state.todoList.tags
          .addAll(value.split(',').map((e) => e.trim()).toList());
    }
  }
}
