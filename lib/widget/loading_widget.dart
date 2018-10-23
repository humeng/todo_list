import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.white,
        child: new Center(
            child: new Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new CircularProgressIndicator(),
        )));
  }
}
