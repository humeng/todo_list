import 'package:flutter/material.dart';
import 'package:todo_list/constant/event_type.dart';
import 'package:todo_list/util/database_helper.dart';

class EditPage extends StatefulWidget {
  final EventType _eventType;

  Todo _todo;

  EditPage(this._eventType, {Todo todo, Key key}) : super(key: key) {
    this._todo = todo;
  }

  @override
  State<StatefulWidget> createState() {
    return new _EditPageSate();
  }
}

class _EditPageSate extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    final eventType = widget._eventType;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(eventType.event + "事件详情"),
        backgroundColor: eventType.color,
        leading: new IconButton(
            icon: new BackButtonIcon(),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("id是  ${eventType.index}"),
        ),
      ),
    );
  }
}
