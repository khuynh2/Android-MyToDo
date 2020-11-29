import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:term_project/controller/messagingcontroller.dart';
import 'package:term_project/model/userprofile.dart';

class AdminScreen extends StatefulWidget {
  static const routeName = '/adminScreen';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdminState();
  }
}

class _AdminState extends State<AdminScreen> {
  _Controller con;
  FirebaseUser user;
  List<User> userProfile;
  List<User> userProfiles;

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
    userProfiles ??= arg['userProfiles'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
      ),
      body: Container(
          child: userProfiles == null || userProfiles.length == 0
              ? Text(
                  'No user',
                  style: TextStyle(fontSize: 30.0),
                )
              : Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(4.0),
                            width: 150.0,
                            child: Text(
                              "Username",
                              style: TextStyle(fontSize: 18),
                            )),
                        Container(
                            padding: EdgeInsets.all(4.0),
                            width: 150.0,
                            child: Text(
                              "Email",
                              style: TextStyle(fontSize: 18),
                            )),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: userProfiles.length,
                          itemBuilder: (BuildContext contet, int index) {
                            if (userProfiles[index].userRole != 'admin') {
                              return Container(
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(4.0),
                                            width: 150.0,
                                            child: Text(
                                                userProfiles[index].userName)),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(4.0),
                                            width: 150.0,
                                            child: Text(
                                                userProfiles[index].email)),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                    ),
                  ],
                )),
    );
  }
}

class _Controller extends ControllerMVC {
  _AdminState _state;
  _Controller(this._state);
}
