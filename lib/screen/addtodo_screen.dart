import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:term_project/controller/firebasecontroller.dart';
import 'package:term_project/model/todolist.dart';
import 'package:term_project/model/userprofile.dart';

import 'view/mydialog.dart';

class AddToDoScreen extends StatefulWidget {
  static const routName = '/todoScreen/addToDoScreen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddToDoState();
  }
}

class _AddToDoState extends State<AddToDoScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Add new to do'),
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
                          hintText: 'Task Name',
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
                          hintText: 'Description',
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        autocorrect: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,
                        //validator: con.validatorNote,
                        onSaved: con.onSavedNote,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Tags: ',
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
                        maxLines: 5,
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
                    ],
                  ),
                ),
              )),
        ));
  }
}

class _Controller {
  _AddToDoState _state;
  _Controller(this._state);

  String title;
  String note;
  List<dynamic> tags;
  String uploadProgressMessage;

  Future<void> save() async {
    if (!_state.formKey.currentState.validate()) return;
    _state.formKey.currentState.save();

    try {
      var td = ToDoList(
        title: title,
        note: note,
        email: _state.userProfile[0].email,
        complete: false,
      );

      td.userId = await FireBaseController.addToDo(td);
      // _state.todoList.insert(0, td);
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

//validator
  String validatorTitle(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  // String validatorNote(String value) {
  //   if (value == null || value.trim().length < 3) {
  //     return 'min 3 chars';
  //   } else {
  //     return null;
  //   }
  // }

//save
  String onSavedTitle(String value) {
    this.title = value;
  }

  String onSavedNote(String value) {
    this.note = value;
  }

  String onSavedTags(String value) {
    if (value.trim().length != 0) {
      this.tags = value.split(',').map((e) => e.trim()).toList();
    }
  }
}
