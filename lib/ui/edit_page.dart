import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_list/util/database_helper.dart';
import 'package:todo_list/constant/event_type.dart';
import 'package:flutter/cupertino.dart';

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
  TimeOfDay _timeOfDay;
  bool _switchValue = false;
  //文本的控制器
  TextEditingController _controller = TextEditingController();

  Future getTodoListFormDB() async {
    if(widget.todo != null ){
      _controller.text=widget.todo.content;
      _switchValue = widget.todo == null ? false : widget.todo.isWarning;
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
            title: new Text( widget.eventType.event+"-记事本"),
            elevation: 0.0,
            backgroundColor: widget.eventType.color,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.check),
                onPressed: ()=>saveData(context,_controller.text, widget.eventType.index.toString(),widget.todo),
              )
            ]
        ),
        body: new Container(
          child: new SingleChildScrollView(
            child: new Column(
            children: <Widget>[
              new TextField(
                  controller: _controller,
                  maxLines:26,
                  decoration:new InputDecoration(
                    hintText:"记录内容",
                  )
              ),
              new Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(left:20.0,right: 20.0,top: 20.0),
                    child: new Text(
                        "提醒闹钟",
                        style:new TextStyle(
                            fontSize:20.0
                        ),
                    ),
                  ),
                  new RaisedButton(
                      padding: new EdgeInsets.only(top:25.0),
                      child: new Text(
                        (_dateTime == null?"     无提醒 ":
                              _dateTime.year.toString()+"年"+
                              _dateTime.month.toString()+"月"+
                              _dateTime.day.toString()+"日"+"-"+
                                  (_timeOfDay == null ? "" : _timeOfDay.hour.toString()+"时"+
                                      _timeOfDay.minute.toString()+"分"))
                      ),
                    onPressed: null,
                      highlightColor:Colors.red
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top:25.0),
                    child: new CupertinoSwitch(
                      value: _switchValue,
                      onChanged: (bool value) {
                        setState(() {
                          _switchValue = value;
                          if(_switchValue){

                          }
                        });
                      },
                    ),
                  )
                ],
              ),
            ],
           ),
          )
        )
    );
  }


  //调用时间控件
  void _showDatePicker(){
    _selectTime(context);
    _selectDate(context);
  }
  //日期控件
  Future<Null> _selectDate(BuildContext context) async{
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: _dateTime == null? new DateTime.now() : _dateTime,
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

  Future<Null> _selectTime(BuildContext context)async{
    final TimeOfDay _picked = await showTimePicker(
        context: context,
        initialTime: new TimeOfDay.now()
    );
    if(_picked != null){
      print(_picked);
      setState(() {
        _timeOfDay = _picked;
      });
    }
  }

  void saveData (BuildContext context, String content,String type,Todo todo) async{
    if(todo == null){
      todo = new Todo();
    }
    if(content == null || content == ""){
      return;
    }
    todo.type = type;
    todo.content = content;
    todo.isWarning = _switchValue;
    todo.warningTime = _dateTime == null? "" :
                       _dateTime.year.toString()+"/"
                      +_dateTime.month.toString()+"/"
                      +_dateTime.day.toString()+" "
                      +_timeOfDay.hour.toString()+":"
                      +_timeOfDay.minute.toString();
    todo.isDelete = false;

    Navigator.pop(context,todo);
  }
}
