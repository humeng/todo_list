import 'package:flutter/material.dart';

class LoadFailureWidget {
  ///加载失败提示
  static Widget buildFailureTextPrompt(Function function) {
    return new Center(
        child: Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: new RaisedButton(
        onPressed: function,
        child: new Text(
          "加载失败，点击重试",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
        ),
      ),
    ));
  }
}
