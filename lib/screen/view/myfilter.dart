import 'package:flutter/material.dart';

class MyFilter {
  static void info({BuildContext context, String value, Set<dynamic> tagsSet}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Filter'),
            content:
                ListView.builder(itemCount: tagsSet.length, itemBuilder: null),
          );
        });
  }

//   Widget setupAlertDialoadContainer() {
//     return Container(
//       height: 300.0, // Change as per your requirement
//       width: 300.0, // Change as per your requirement
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: 5,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             title: Text('Gujarat, India'),
//           );
//         },
//       ),
//     );
//   }
// }

// class CustomFilter extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
}
