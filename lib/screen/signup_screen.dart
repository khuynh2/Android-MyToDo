import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:term_project/controller/firebasecontroller.dart';
import 'view/mydialog.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signInScreen/signUpScreen';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Text(
                'create an account',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: con.validatorEmail,
                onSaved: con.onSavedEmail,
              ),
              TextFormField(
                controller: _pass,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                autocorrect: false,
                validator: con.validatorPassword,
                onSaved: con.onSavedPassword,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password confirm',
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                autocorrect: false,
                validator: con.validatorPasswordConfirm,
              ),
              RaisedButton(
                child: Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
                onPressed: con.signUp,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignUpState _state;
  _Controller(this._state);
  String email;
  String password;

  void signUp() async {
    if (!_state.formKey.currentState.validate()) return;
    _state.formKey.currentState.save();

    try {
      FireBaseController.signUp(email, password);
      MyDialog.info(
        context: _state.context,
        title: 'Account Successfully created',
        content: 'Your account is created! Go to Sign in',
      );
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error',
        content: e.message ?? e.toString(),
      );
    }
  }

//validate
  String validatorEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'email is invalid';
    else
      return null;
  }

  String validatorPassword(String value) {
    Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'password must be min 6 characters, has at least 1 number, 1 letter';
    else
      return null;
  }

  String validatorPasswordConfirm(String value) {
    //String pass2 = _state._pass.text;
    if (value != _state._pass.text) {
      return 'Password does not match';
    } else {
      return null;
    }
  }

//save
  void onSavedEmail(String value) {
    this.email = value;
  }

  void onSavedPassword(String value) {
    this.password = value;
  }
}
