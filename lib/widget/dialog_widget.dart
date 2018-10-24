import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogWidget {

  ///app退出dialog
  static Widget buildExitUI(BuildContext context) {
    return new AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
        content: new Text(
          '退出App吗？',
          style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.pop(context);
              if (!Navigator.canPop(context)) {
                SystemNavigator.pop();
              }
            },
            child: new Text(
              '确定',
              style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal),
            ),
          )
        ]);
  }
}
