import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:todo_list/util/database_helper.dart';
import 'package:sqflite/sqflite.dart';
class EditPage extends StatefulWidget {
  final int id;
  final String type;

  EditPage({Key key, @required this.id, @required this.type}) : super(key: key);

  @override
  _EditPageData createState() => new _EditPageData();
}

class _EditPageData extends State<EditPage> {

  DbProvider provider = new DbProvider();
  static String content = "";
  DateTime _dateTime;

  Future<bool> initDB() async{
    String databasePath = join(await getDatabasesPath(),"db.db");
    return provider.open(databasePath);
  }

  //文本的控制器
  TextEditingController _controller = TextEditingController();

  Future getTodoListFormDB() async {
    await initDB();
    if(widget.id != 0){
      List<Map> mapList = await provider.getTodoById(widget.id);
      content = mapList[0]["content"];
      _controller.text=content;
    }

  }

  @override
  void initState() {
    super.initState();
    getTodoListFormDB();
  }

  @override
  Widget build(BuildContext context) {
    var id = widget.id;
    return new Scaffold(
        appBar: new AppBar(
            title: new Text('详情'),
            elevation: 0.0,
            backgroundColor: Colors.red[400].withOpacity(0.5),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.check),
                onPressed: ()=>saveData(context,_controller.text, widget.type,id),
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

  void saveData (BuildContext context, String content,String type,int id) async{
    Todo todo = new Todo();
    List<Map> result = new List<Map>();
    result = await provider.getTodoById(id);

    todo.type = type;
    todo.content = content;
    todo.isWarning = false;
    todo.warningTime = "";
    todo.isDelete = false;
    if(result.length == 0){
      await provider.insert(todo);
    }else{
      todo.id = result[0]["id"];
      todo.createTime = result[0]["createTime"];
      await provider.update(todo);
    }
    await provider.close();

    Navigator.pop(context);
  }
}
