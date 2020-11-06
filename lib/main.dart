import 'package:flutter/material.dart';
import 'package:term_project/screen/signin_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      initialRoute: SignInScreen.routeName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
      },
    );
    return materialApp;
  }
}
