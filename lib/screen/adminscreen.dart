import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  FirebaseUser user;
  List<User> userProfile;
  List<User> userProfiles;

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
              : ListView.builder(
                  itemCount: userProfiles.length,
                  itemBuilder: (BuildContext contet, int index) {
                    if (userProfiles[index].userRole != 'admin') {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Text('index: ${index}'),
                            Text(userProfiles[index].email),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  })),
    );
  }
}
