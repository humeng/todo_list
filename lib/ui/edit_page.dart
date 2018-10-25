import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_list/constant/multi_color.dart';
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
  static String noConfigTime = "无提醒";
  DateTime _dateTime;
  TimeOfDay _timeOfDay;
  bool _switchValue = false;
  String warningTime = "";
  //文本的控制器
  TextEditingController _controller = TextEditingController();

  Future getTodoListFormDB() async {
    if(widget.todo != null ){
      _controller.text=widget.todo.content;
      _switchValue = widget.todo.isWarning;
      if(_switchValue){
        setState(() {
          _switchValue = widget.todo.isWarning;
        });
      }
      if(widget.todo.warningTime != null && (widget.todo.warningTime!="")){
        List<String> dateAndTime = widget.todo.warningTime.replaceAll("/", "-").split(" ");
        String dateStr=dateAndTime[0];
        DateTime date = DateTime.parse(dateStr);
        List<String> mAndSecond = dateAndTime[1].split(":");
        TimeOfDay time = TimeOfDay.fromDateTime(new DateTime(0,0,0,int.parse(mAndSecond[0]),int.parse(mAndSecond[1]),0));
        _dateTime = date;
        _timeOfDay = time;
      }
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
            child: new Column(
            children: <Widget>[
              new Expanded(
                
            child: new SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: new TextField(
                    controller: _controller,
                    maxLines:30,
                    decoration:new InputDecoration(
                      hintText:"记录内容",
                      border: InputBorder.none,
                      filled:true,
                      fillColor: Multicolor.GRAY_246

                    )
                )
            )
              ),

              new Stack(
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.only(left:10.0,right: 10.0,top: 25.0),
                    child: new Text(
                        "开启闹钟",
                        style:new TextStyle(
                            fontSize:20.0
                        ),
                    ),
                  ),
                  new Align(
                    alignment: FractionalOffset.centerRight,
                    //alignment:const FractionalOffset(0.3, 0.1),
                    child:new Container(
                      padding: new EdgeInsets.only(top:20.0,right: 10.0),
                      child: new CupertinoSwitch(
                        value: _switchValue,
                        onChanged: (bool value) {
                          setState(() {
                            _switchValue = value;
                            if(!_switchValue){
                              _dateTime = null;
                              _timeOfDay = null;
                            }else if(_switchValue && (widget.todo != null && widget.todo.warningTime != "")){
                              List<String> dateAndTime = widget.todo.warningTime.replaceAll("/", "-").split(" ");
                              String dateStr=dateAndTime[0];
                              DateTime date = DateTime.parse(dateStr);
                              List<String> mAndSecond = dateAndTime[1].split(":");
                              TimeOfDay time = TimeOfDay.fromDateTime(new DateTime(0,0,0,int.parse(mAndSecond[0]),int.parse(mAndSecond[1]),0));
                              _dateTime = date;
                              _timeOfDay = time;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              new Stack(
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.only(left:10.0,right: 10.0,top: 9.0),
                    child: new Text(
                      "提醒时间",
                      style:new TextStyle(
                          fontSize:20.0
                      ),
                    ),
                  ),
                  new Align(
                    child:new Container(
                      height: 48.0,
                      padding: EdgeInsets.only(top:15.0),
                      child: new Text(
                          (_dateTime == null?(_switchValue?"请选择提醒时间":noConfigTime):
                          _dateTime.year.toString()+"年"+
                              _dateTime.month.toString()+"月"+
                              _dateTime.day.toString()+"日"+"-"+
                              (_timeOfDay == null ? "" : _timeOfDay.hour.toString()+"时"+
                                  _timeOfDay.minute.toString()+"分"))
                      ),
                    ),
                  ),
                  new Align(
                      alignment: FractionalOffset.centerRight,
                      child: _switchValue ? new Container(
                          child: new IconButton(
                            icon:Icon(Icons.access_alarm),
                            onPressed: () =>selectTime(),
                          )
                      ):null
                  )
                ],
              )
            ],
           ),
        )
    );
  }

  void selectTime(){
    if(_switchValue){
      _showDatePicker();
    }
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
    if((content == null || content == "")){
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              title: new Text("提示"),
              content: new Text("保存内容不能为空。"),
          )
      );
      return;
    }

    if((_switchValue && (_dateTime == null || _timeOfDay == null))){
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              title: new Text("提示"),
              content: new Text("请设置提示时间"),
          )
      );
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
