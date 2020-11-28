import 'package:flutter/material.dart';
import 'package:term_project/screen/adddailyscreen.dart';
import 'package:term_project/screen/addtodo_screen.dart';
import 'package:term_project/screen/dailyscreen.dart';
import 'package:term_project/screen/edittodo_screen.dart';
import 'package:term_project/screen/messagehandler.dart';
import 'package:term_project/screen/settings_screen.dart';
import 'package:term_project/screen/signin_screen.dart';
import 'package:term_project/screen/signup_screen.dart';
import 'package:term_project/screen/testing.dart';
import 'package:term_project/screen/todo_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MessageHandler();
    var materialApp = MaterialApp(
      initialRoute: SignInScreen.routeName,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[800],
        fontFamily: 'Monospace',
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.indigo[800],
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
            )),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        ToDoScreen.routeName: (context) => ToDoScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        AddToDoScreen.routName: (context) => AddToDoScreen(),
        EditToDoScreen.routName: (context) => EditToDoScreen(),
        DailyScreen.routeName: (context) => DailyScreen(),
        AddDailyScreen.routName: (context) => AddDailyScreen(),
        Test.routeName: (context) => Test(),
      },
    );
    return materialApp;
  }
}
