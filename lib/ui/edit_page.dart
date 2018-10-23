import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_list/util/database_helper.dart';
import 'package:todo_list/constant/event_type.dart';

import 'package:todo_list/plugin/alarm_manager.dart';

class EditPage extends StatefulWidget {
  final Todo todo;
  final EventType eventType;

  EditPage(this.eventType,{Key key,this.todo}) : super(key: key);

  @override
  _EditPageData createState() => new _EditPageData();
}

class _EditPageData extends State<EditPage> {

  static String content = "";
  DateTime _dateTime;

  //文本的控制器
  TextEditingController _controller = TextEditingController();

  Future getTodoListFormDB() async {
    if(widget.todo != null ){
      _controller.text=widget.todo.content;
    }

  }

  @override
  void initState() {
    super.initState();
    getTodoListFormDB();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text( widget.eventType.event+"详情"),
            elevation: 0.0,
            backgroundColor: widget.eventType.color,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.check),
                onPressed: ()=>saveData(context,_controller.text, widget.eventType.event,widget.todo),
              )
            ]
        ),
        body: new Container(
          child: new TextField(
              controller: _controller,
              maxLines:20,
              decoration:new InputDecoration(
                hintText:"记录内容",
              )
          ),
        )
    );
  }
  //调用时间控件
  void _showDatePicker(BuildContext context){
    _selectDate(context);
  }
  //时间控件
  Future<Null> _selectDate(BuildContext context) async{
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2050)
    );
    if(_picked != null){
      print(_picked);
      setState(() {
        _dateTime = _picked;
      });
    }
  }

  void saveData (BuildContext context, String content,String type,Todo todo) async{
    if(todo == null){
      todo = new Todo();
    }
    todo.type = type;
    todo.content = content;
    todo.isWarning = false;
    todo.warningTime = "";
    todo.isDelete = false;

    //AlarManager.setAlarm(id, event, dateTime)
    
    
    Navigator.pop(context,todo);
  }
}
