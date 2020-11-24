import 'package:flutter/material.dart';

class MyFilter {
  static void info({BuildContext context, var value, List<dynamic> tagsList}) {
    showDialog(
        //barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          String _tags = '';
          return AlertDialog(
            title: Text('Filter'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                  width: 350,
                  height: 250,
                  child: ListView.builder(
                      //scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: tagsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(tagsList[index]),
                          leading: Radio<String>(
                            //activeColor: Color(0xFF6200EE),
                            value: tagsList[index],
                            groupValue: _tags,
                            onChanged: (String value) {
                              setState(() {
                                _tags = value;
                                //print(_tags);
                              });
                            },
                          ),
                        );
                      }));
            }),
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
