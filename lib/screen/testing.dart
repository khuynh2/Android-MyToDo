import 'package:flutter/widgets.dart';

import 'messagehandler.dart';

class Test extends StatefulWidget {
  static const routeName = '/testing';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestState();
  }
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MessageHandler();
  }
}