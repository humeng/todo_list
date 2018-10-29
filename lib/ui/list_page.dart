import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:todo_list/constant/db_operation_type.dart';
import 'package:todo_list/constant/event_type.dart';
import 'package:todo_list/constant/loading_state.dart';
import 'package:todo_list/constant/multi_color.dart';
import 'package:todo_list/db/dao/todo_dao.dart';
import 'package:todo_list/db/entry/todo_entry.dart';
import 'package:todo_list/plugin/alarm_manager.dart';
import 'package:todo_list/ui/edit_page.dart';
import 'package:todo_list/db/db_helper.dart';
import 'package:sqflite/sqflite.dart';
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

  final TodoDao _todoDao = new TodoDao();

  ///数据库处理器
  final DatabaseHelper _dbProvider = DatabaseHelper.instance;

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
        widget = LoadingWidget.buildCircularProgress();
        break;
      case LoadingState.LOAD_SUCCESS:
        widget = buildListDataWidget(context);
        break;
      default:
        break;
    }
    return widget;
  }

  ///build列表数据组件
  Widget buildListDataWidget(BuildContext context) {
    final eventType = widget._evenType;
    return new Scaffold(
        backgroundColor: Multicolor.GRAY_246,
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
              return new Container(
                  margin: EdgeInsets.all(1.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(new Radius.circular(5.0))),
                  child: new Slidable(
                    delegate: SlidableScrollDelegate(),
                    actionExtentRatio: 0.2,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                          caption: '删除',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => _deleteTodo(todo, context)),
                    ],
                    child: new ListTile(
                        title: new Text(todo.content),
                        subtitle: new Text(todo.warningTime),
                        onTap: () =>
                            _pushEditPage(context, eventType, todo: todo)),
                  ));
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

  ///插入
  void _insertTodo(Todo todoNew) async {
    bool result =
        await _dbProvider.handle(DBOperation.ADD, _todoDao, t: todoNew);
    if (result) {
      if (todoNew.isWarning) {
        AlarManager.setAlarm(todoNew.id, todoNew.content, todoNew.warningTime);
      }
      setState(() {
        _items.add(todoNew);
      });
    }
  }

  ///删除
  void _deleteTodo(Todo todo, BuildContext context) async {
    bool result =
        await _dbProvider.handle(DBOperation.DELETE, _todoDao, t: todo);
    if (result) {
      if (todo.isWarning) {
        AlarManager.cancelAlarm(todo.id);
      }
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("${todo.warningTime} 日期事件已经删除")));
      setState(() {
        _items.remove(todo);
      });
    }
  }

  ///更新
  void _updateTodo(Todo todoNew, Todo todo) async {
    bool result =
        await _dbProvider.handle(DBOperation.UPDATE, _todoDao, t: todoNew);
    if (result) {
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
    List<Map> mapList = await _dbProvider.handle(DBOperation.QUERY, _todoDao,
        type: widget._evenType.type);
    _items.clear();
    for (var map in mapList) {
      _items.add(Todo.fromMap(map));
    }
    setState(() {
      _loadingState = LoadingState.LOAD_SUCCESS;
    });
  }
}
