import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:todo_list/constant/event_type.dart';
import 'package:todo_list/constant/loading_state.dart';
import 'package:todo_list/plugin/alarm_manager.dart';
import 'package:todo_list/ui/edit_page.dart';
import 'package:todo_list/util/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/widget/load_failure_widget.dart';
import 'package:todo_list/widget/loading_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListPage extends StatefulWidget {
  final EventType _evenType;

  ListPage(this._evenType, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ListPageState();
  }
}

class _ListPageState extends State<ListPage> {
  final List<Todo> _items = new List();

  ///是否正在加载
  LoadingState _loadingState;

  ///数据库路径
  String _dbPath;

  ///数据库处理器
  final DbProvider _dbProvider = new DbProvider();

  @override
  void initState() {
    super.initState();
    _loadingState = LoadingState.LOADING;
    _findTodoList();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (_loadingState) {
      case LoadingState.LOADING:
        widget = new LoadingWidget();
        break;
      case LoadingState.LOADING_SUCCESS:
        widget = buildListDataWidget(context);
        break;
      case LoadingState.LOADING_FAIL:
        break;
    }
    return widget;
  }

  ///build列表数据组件
  Widget buildListDataWidget(BuildContext context) {
    final eventType = widget._evenType;
    return new Scaffold(
        appBar: new AppBar(
          leading: new IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: new BackButtonIcon()),
          title: new Text(eventType.event),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.add),
                onPressed: () => _pushEditPage(context, eventType))
          ],
          backgroundColor: eventType.color,
        ),
        body: new ListView.builder(
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              var todo = _items[index];
              return new Slidable(
                delegate: SlidableScrollDelegate(),
                actionExtentRatio: 0.25,
                secondaryActions: <Widget>[
                  IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => _deleteTodo(todo, context)),
                ],
                child: new ListTile(
                    title: new Text(todo.content),
                    subtitle: new Text(todo.warningTime),
                    onTap: () => _pushEditPage(context, eventType, todo: todo)),
              );
            }));
  }

  ///跳转到EditPage
  void _pushEditPage(BuildContext context, EventType eventType,
      {Todo todo}) async {
    Todo todoNew = await Navigator.push<Todo>(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return EditPage(eventType, todo: todo);
    }));
    if (todoNew != null) {
      if (todoNew.id != null) {
        _updateTodo(todoNew, todo);
      } else {
        _insertTodo(todoNew);
      }
    }
  }

  ////打开数据库
  Future _openDatabase() async {
    if (_dbPath == null) {
      _dbPath = await getDatabasesPath();
      _dbPath = join(_dbPath, "todo.db");
    }
    if (_dbProvider.db == null || !_dbProvider.dbIsOpen()) {
      await _dbProvider.open(_dbPath);
    }
  }

  ///关闭数据库
  Future _closeDatabase() async {
    if (_dbProvider.dbIsOpen()) {
      await _dbProvider.close();
    }
  }

  ///插入
  void _insertTodo(Todo todoNew) async {
    await _openDatabase();
    todoNew.id = await _dbProvider.insert(todoNew);
    await _closeDatabase();
    AlarManager.setAlarm(todoNew.id, todoNew.content, todoNew.warningTime);
    setState(() {
      _items.add(todoNew);
    });
  }

  ///删除
  void _deleteTodo(Todo todo, BuildContext context) async {
    await _openDatabase();
    int result = await _dbProvider.delete(todo.id);
    await _closeDatabase();
    if (result == 1) {
      AlarManager.cancelAlarm(todo.id);
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("${todo.warningTime} 日期事件已经删除")));
      setState(() {
        _items.remove(todo);
      });
    }
  }

  ///更新
  void _updateTodo(Todo todoNew, Todo todo) async {
    await _openDatabase();
    int result = await _dbProvider.update(todoNew);
    await _closeDatabase();
    if (result == 1) {
      if (todoNew.isWarning) {
        AlarManager.setAlarm(todoNew.id, todoNew.content, todoNew.warningTime);
      } else {
        AlarManager.cancelAlarm(todoNew.id);
      }
      setState(() {
        todo = todoNew;
      });
    }
  }

  ///查找
  Future _findTodoList() async {
    await _openDatabase();
    List<Map> mapList = await _dbProvider.getListByType(widget._evenType.index.toString());
    await _closeDatabase();
    _items.clear();
    for (var map in mapList) {
      _items.add(Todo.fromMap(map));
    }
    setState(() {
      _loadingState = LoadingState.LOADING_SUCCESS;
    });
  }
}
