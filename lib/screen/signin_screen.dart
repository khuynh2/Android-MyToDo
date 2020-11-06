import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Text('My To Do',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25))
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Username',
                  ),
                  autocorrect: false,
                  //validator: con.validatorUsername,
                  //onSaved: con.onSavedUsername,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: con.validatorPassword,
                  // onSaved: con.onSavedPassword,
                ),
                RaisedButton(
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  color: Colors.blue,
                  //onPressed: con.signIn,
                ),
              ],
            ),
          ),
        ));
  }
}

class _Controller {
  _SignInState _state;
  _Controller(this._state);

  void signIn() async {}

  String validatorUsername(String username) {
    return "Testing";
  }

  String validatorPassword(String password) {
    Pattern pattern = r'^[a-zA-Z0-9]{4,12}*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(password))
      return 'Invalid username';
    else
      return null;
  }

  void onSavedUsername(String username) {}

  void onSavedPassword(String password) {}
}
