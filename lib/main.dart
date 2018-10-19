import 'package:flutter/material.dart';
import 'package:todo_list/HomeScreen.dart';
import 'package:todo_list/ListPage.dart';
import 'package:todo_list/ViewPage.dart';

void main() => runApp(
    MaterialApp(
      title: "homePage",
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/listPage': (context) => ListPage(),
        '/viewPage': (context) => ViewPage(),
      },
    )
);
