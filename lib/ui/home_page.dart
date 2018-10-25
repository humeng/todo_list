import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_list/constant/event_type.dart';
import 'package:todo_list/constant/multi_color.dart';
import 'package:todo_list/ui/list_page.dart';
import 'package:todo_list/widget/dialog_widget.dart';

class HomePage extends StatelessWidget {
  var _context;

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return new WillPopScope(
        child: new Scaffold(
          backgroundColor: Multicolor.GRAY_246,
          appBar: new AppBar(
            title: new Text("记事本"),
            centerTitle: true,
            backgroundColor: Multicolor.GREEN_TITLE,
          ),
          body: new GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20.0),
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            crossAxisCount: 2,
            children: <Widget>[
              const ItemWidget(1),
              const ItemWidget(0),
              const ItemWidget(2),
              const ItemWidget(3),
            ],
          ),
        ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() {
    return showDialog<bool>(
        context: _context,
        builder: (context) {
          return DialogWidget.buildExitUI(context);
        });
  }
}

class ItemWidget extends StatefulWidget {
  final int _index;

  const ItemWidget(this._index, {Key key}) : super(key: key);

  @override
  State<ItemWidget> createState() {
    return new _ItemWidgetSate();
  }
}

class _ItemWidgetSate extends State<ItemWidget> {
  EventType _eventType;

  @override
  void initState() {
    super.initState();
    _eventType = EventType.EVENT_MAP[widget._index];
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        alignment: Alignment.center,
        child: new Text(
          _eventType.event,
          style: new TextStyle(
              color: Colors.white, fontSize: 18.0, fontStyle: FontStyle.normal),
        ),
        padding: new EdgeInsets.all(10.0),
        height: 100.0,
        width: 0.0,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
          color: _eventType.color,
        ),
      ),
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new ListPage(_eventType);
        }));
      },
    );
  }
}
