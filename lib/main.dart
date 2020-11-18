import 'package:flutter/material.dart';
import 'package:term_project/screen/addtodo_screen.dart';
import 'package:term_project/screen/settings_screen.dart';
import 'package:term_project/screen/signin_screen.dart';
import 'package:term_project/screen/signup_screen.dart';
import 'package:term_project/screen/todo_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      },
    );
    return materialApp;
  }
}
