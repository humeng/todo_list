import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notepad/alarm/alarm_manager.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
          child: new GestureDetector(
            onTap: _setAlarm,
            child: new Text("发送通知"),
          )),
    );
  }

  ///设置闹钟
  void _setAlarm() {
    AlarManager.setAlarm(0,"今天的天气真好1","2018/10/19 16:19");
    AlarManager.setAlarm(1,"今天的天气真好2","2018/10/19 16:20");
    AlarManager.setAlarm(2,"今天的天气真好3","2018/10/19 16:21");
    AlarManager.setAlarm(3,"今天的天气真好4","2018/10/19 16:22");
    print('已经设置了闹钟');
  }
}
