import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:todo_list/constant/event_type.dart';
import 'package:todo_list/constant/loading_state.dart';
import 'package:todo_list/ui/edit_page.dart';
import 'package:todo_list/util/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/widget/load_failure_widget.dart';
import 'package:todo_list/widget/loading_widget.dart';

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
    _getListData();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (_loadingState) {
      case LoadingState.LOADING:
        widget = new LoadingWidget();
        break;
      case LoadingState.LOADING_FAIL:
        widget = new LoadingFailureWidget(() {
          setState(() {
            _loadingState = LoadingState.LOADING;
          });
          _getListData();
        });
        break;
      case LoadingState.LOADING_SUCCESS:
        widget = buildListDataWidget(context);
        break;
    }
    return widget;
  }

  @override
  void deactivate() {
    if (_dbProvider.dbIsOpen()) {
      _dbProvider.close();
    }
    super.deactivate();
  }

  ///获取数据
  void _getListData() {
    _getListDataFromDB().then((isGet) {
      setState(() {
        if (isGet) {
          _loadingState = LoadingState.LOADING_SUCCESS;
        } else {
          _loadingState = LoadingState.LOADING_FAIL;
        }
      });
    });
  }

  ///从数据库中获取列表数据
  Future<bool> _getListDataFromDB() async {
    try {
      if (_dbPath == null) {
        _dbPath = await getDatabasesPath();
        _dbPath = join(_dbPath, "todo.db");
      }
      if (_dbProvider.db == null || !_dbProvider.dbIsOpen()) {
        await _dbProvider.open(_dbPath);
      }
      List<Map> mapList =
          await _dbProvider.getListByType(widget._evenType.event);
      _items.clear();
      for (var map in mapList) {
        _items.add(Todo.fromMap(map));
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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
                onPressed: () {
                  _pushEditPage(context, eventType);
                })
          ],
          backgroundColor: eventType.color,
        ),
        body: new ListView.builder(
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              var todo = _items[index];
              return new Dismissible(
                key: new Key(todo.warningTime),
                child: new ListTile(
                  title: new Text(todo.content),
                  subtitle: new Text(todo.warningTime),
                  onTap: () {
                    _pushEditPage(context, eventType, todo: todo);
                  },
                ),
                onDismissed: (DismissDirection direction) {
                  _items.removeAt(index);
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text("${todo.warningTime} 日期事件已经删除")));
                },
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
      setState(() {
        if (todoNew.id != null) {
          _items[todoNew.id] = todoNew;
          _dbProvider.update(todoNew);
        } else {
          _items.add(todoNew);
          _dbProvider.insert(todoNew);
        }
      });
    }
  }
}
