import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:term_project/controller/analyticcontroller.dart';
import 'package:term_project/controller/firebasecontroller.dart';
import 'package:term_project/controller/messagingcontroller.dart';
import 'package:term_project/model/todolist.dart';
import 'package:term_project/model/userprofile.dart';
import 'package:term_project/screen/adminscreen.dart';
import 'package:term_project/screen/signup_screen.dart';
import 'package:term_project/screen/todo_screen.dart';
import 'package:term_project/screen/view/mydialog.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/signin.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
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
                      hintText: 'Email',
                    ),
                    autocorrect: false,
                    validator: con.validatorEmail,
                    onSaved: con.onSavedEmail,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    validator: con.validatorPassword,
                    onSaved: con.onSavedPassword,
                  ),
                  RaisedButton(
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    onPressed: con.signIn,
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    onPressed: con.signUp,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _Controller {
  _SignInState _state;
  _Controller(this._state);

  String email;
  String password;

  void signUp() async {
    Navigator.pushNamed(_state.context, SignUpScreen.routeName);
  }

  void signIn() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();
    MyDialog.circularProgressStart(_state.context);
    print("--------------User email: $email is Signing in");

    // push to ToDo
    FirebaseUser user;
    try {
      user = await FireBaseController.signIn(email, password);
      print('USER: $user');
    } catch (e) {
      MyDialog.circularProgressStart(_state.context);
      // print('***** $e');
      MyDialog.info(
        context: _state.context,
        title: 'Sign In Error',
        content: e.message ?? e.toString(),
      );
      return;
    }

    try {
      List<User> userProfile =
          await FireBaseController.getUserProfile(user.email);

      AnalyticController ac = AnalyticController();
      ac.setUserProperties(
          userId: user.uid,
          userRole: userProfile[0].userRole,
          username: userProfile[0].userName);
      MessagingController.fcmSubscribe('all');
      MessagingController.fcmSubscribe(userProfile[0].userName);

      if (userProfile[0].userRole == 'user') {
        List<ToDoList> todoList =
            await FireBaseController.getUserToDo(user.email);

        MyDialog.CircularProgressEnd(_state.context);
        ac.logLogin();
        Navigator.pushReplacementNamed(
          _state.context,
          ToDoScreen.routeName,
          arguments: {
            'user': user,
            'userProfile': userProfile,
            'todoList': todoList
          },
        );
      } else if (userProfile[0].userRole == 'admin') {
        List<User> userProfiles = await FireBaseController.getUserProfiles();
        ac.logLogin();
        await Navigator.pushNamed(_state.context, AdminScreen.routeName,
            arguments: {
              'user': user,
              'userProfile': userProfile,
              'userProfiles': userProfiles
            });
      }
    } catch (e) {
      MyDialog.CircularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Firebase/Firestore error',
        content: 'Cannot get user Profile. Try again later! \n ${e.message}',
      );
    }
  }

  //Validate
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
      return 'password must be min 6 characters, has min 1 number, 1 letter';
    else
      return null;
  }

//Save
  void onSavedEmail(String value) {
    email = value;
  }

  void onSavedPassword(String value) {
    password = value;
  }
}
