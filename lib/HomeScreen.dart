import 'package:flutter/material.dart';
import 'package:todo_list/ListPage.dart';
import 'package:todo_list/constant.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void blockTap(BuildContext context, String type){
      print("----"+type);
      Navigator.push(
        context,
          new MaterialPageRoute(
              settings: const RouteSettings(name: '/listPage'),
              builder: (context) => new ListPage(type: type)
          )
      );
    }

    TextStyle bold24Roboto = new TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w900,
    );

    Widget firstBlock = new GestureDetector(
        onTap: () {
          blockTap(context, Constant.firstBlock);
        },
        child: new Container(
          // grey box
          child: new Center(
            child: new Container(
              // red circle
              child: new Text(
                "重要且紧急",
                style: bold24Roboto,
              ),
              padding: new EdgeInsets.all(16.0),
            ),
          ),
          width: 150.0,
          height: 110.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [Colors.red[400], Colors.red[200]], // whitish to gray
            ),
          ),
          margin: const EdgeInsets.only(right: 20.0),
        ));
    Widget secondBlock = new GestureDetector(
        onTap: () {
          blockTap(context, Constant.secondBlock);
        },
        child: new Container(
          // grey box
          child: new Center(
            child: new Container(
              // red circle
              child: new Text(
                "紧急不重要",
                style: bold24Roboto,
              ),
              padding: new EdgeInsets.all(16.0),
            ),
          ),
          width: 150.0,
          height: 110.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [
                Colors.orange[400],
                Colors.orange[200]
              ], // whitish to gray
            ),
          ),
        ));
    Widget thirdBlock = new GestureDetector(
        onTap: () {
          blockTap(context, Constant.thirdBlock);
        },
        child: new Container(
          // grey box
          child: new Center(
            child: new Container(
              // red circle
              child: new Text(
                "重要不紧急",
                style: bold24Roboto,
              ),
              padding: new EdgeInsets.all(16.0),
            ),
          ),
          width: 150.0,
          height: 110.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [Colors.blue[400], Colors.blue[200]], // whitish to gray
            ),
          ),
          margin: const EdgeInsets.only(right: 20.0),
        ));
    Widget fourthBlock = new GestureDetector(
        onTap: () {
          blockTap(context, Constant.fourthBlock);
        },
        child: new Container(
          //
          child: new Center(
            child: new Container(
              // red circle
              child: new Text(
                "不重要不紧急",
                style: bold24Roboto,
              ),
              padding: new EdgeInsets.all(16.0),
            ),
          ),
          width: 150.0,
          height: 110.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [Colors.green[400], Colors.green[200]], // whitish to gray
            ),
          ),
        ));

    Widget firstRow = Container(
      padding: const EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [firstBlock, secondBlock]),
    );
    Widget secondRow = Container(
      padding: const EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [thirdBlock, fourthBlock]),
    );
    return new Scaffold(
        appBar: AppBar(
          title: Text('首页'),
        ),
        body: new Container(
          alignment: Alignment.topCenter,
          child: new ListView(
            children: [firstRow, secondRow],
            padding: const EdgeInsets.only(top: 30.0),
          ),
        ));
  }
}
