import 'package:flutter/material.dart';

class LoadingWidget {
  ///圆形进度条
  static Widget buildCircularProgress() {
    return new Center(
        child: Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: new CircularProgressIndicator(),
    ));
  }
}
