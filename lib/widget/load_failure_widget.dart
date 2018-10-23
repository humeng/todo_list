import 'package:flutter/material.dart';

class LoadingFailureWidget extends StatelessWidget {
  final Function _onTap;

  LoadingFailureWidget(this._onTap, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.white,
        child: new Center(
            child: new Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new GestureDetector(
            child: new Text("加载失败，点击重试"),
            onTap: _onTap,
          ),
        )));
  }
}
