import 'package:flutter/material.dart';
import 'package:todo_list/ui/HomeScreen.dart';
import 'package:todo_list/ui/ListPage.dart';
import 'package:todo_list/ui/ViewPage.dart';

void main() => runApp(MaterialApp(
      title: "homePage",
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/listPage': (context) => ListPage(),
        '/viewPage': (context) => ViewPage(),
      },
    ));
