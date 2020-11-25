import 'package:day_selector/day_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:term_project/controller/firebasecontroller.dart';
import 'package:term_project/model/dailylist.dart';
import 'package:term_project/model/userprofile.dart';
import 'package:term_project/screen/view/mydialog.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AddDailyScreen extends StatefulWidget {
  static const routName = '/dailyScreen/addDailycreen';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddDailyState();
  }
}

class _AddDailyState extends State<AddDailyScreen> {
  _Controller con;
  var formKey2 = GlobalKey<FormState>();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: formKey2,
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
                          height: 25,
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
                          maxLines: 4,
                          onSaved: con.onSavedNote,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Repeat: ',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DaySelector(
                  onChange: (value) {
                    print('value is $value');
                    if (DaySelector.monday & value == DaySelector.monday) {
                      print('monday selected');
                    }
                    if (DaySelector.tuesday & value == DaySelector.tuesday) {
                      print('tuesday selected');
                    }
                    if (DaySelector.wednesday & value ==
                        DaySelector.wednesday) {
                      print('wednesday selected');
                    }
                    if (DaySelector.thursday & value == DaySelector.thursday) {
                      print('thursday selected');
                    }
                    if (DaySelector.friday & value == DaySelector.friday) {
                      print('friday selected');
                    }
                    if (DaySelector.saturday & value == DaySelector.saturday) {
                      print('saturday selected');
                    }
                    if (DaySelector.sunday & value == DaySelector.sunday) {
                      print('sunday selected');
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class _Controller {
  _AddDailyState _state;
  _Controller(this._state);

  String title;
  String note;

  Future<void> save() async {
    if (!_state.formKey2.currentState.validate()) return;
    _state.formKey2.currentState.save();
    print("Pressed save");

    try {
      var d = DailyList(
        title: title,
        note: note,
        email: _state.userProfile[0].email,
        streak: 0,
      );

      d.userId = await FireBaseController.addDaily(d);
    } catch (e) {
      MyDialog.CircularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: 'Error saving',
          content: e.message ?? e.toString());
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
    this.title = value;
  }

  String onSavedNote(String value) {
    this.note = value;
  }
}
