import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:todo_list/ui/ViewPage.dart';
import 'package:todo_list/constant/constant.dart';
import 'package:todo_list/util/sqflitehelper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite/sqflite.dart';

class ListPage extends StatefulWidget {
  final String type;

  ListPage({Key key, @required this.type}) : super(key: key);

  @override
  _ListData createState() => new _ListData();
}

class _ListData extends State<ListPage> {
  String type;
  DbProvider provider = new DbProvider();
  Future<List<Todo>> todoList;

  Future<bool> initDB() async{
    String databasePath = join(await getDatabasesPath(),"db.db");
    return provider.open(databasePath);
  }

  void insertTodo(int suffix) async{
    Todo todo = new Todo();
    todo.type = type;
    todo.content = "这是一条代办"+suffix.toString();
    todo.type = type;
    todo.isWarning = true;
    todo.warningTime = DateTime.now().toString();
    todo.isDelete = false;
    await provider.insert(todo);

  }

  Future<List<Todo>> getTodoListFormDB() async {
    await initDB();
//    var index = 1;
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
//    insertTodo(index++);
    List<Map> mapList = await provider.getListByType(type);
    List<Todo> todoList = new List();
    for(var map in mapList){
      Todo todo = new Todo();
      todo.id = map["id"];
      todo.content = map["content"].toString();
      todoList.add(todo);
    }
//    await provider.close();
    return todoList;
  }

  void deleteTodo(BuildContext context, int id) async{
    await provider.delete(id);
    this._showToast(context, id.toString());
    updateData(id);
//    await provider.close();
  }

  void _showToast(BuildContext context, String info) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(info+'删除成功'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    todoList = getTodoListFormDB();
  }

  void updateData(int id) {
    setState(() {
      todoList.then((list) {
        list.removeWhere((todo) {
          return todo.id == id;
        });
      });
    });
  }

  void gotoViewPage(BuildContext context, var id){
    Navigator.push(
        context,
        new MaterialPageRoute(
            settings: const RouteSettings(name: '/viewPage'),
            builder: (context) => new ViewPage(id: id)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    type = widget.type;
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      appBar: new AppBar(
          title: new Text(Constant.typeContent[type]),
          elevation: 0.0,
          backgroundColor: getAppBarColorByType(type),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: ()=>gotoViewPage(context, 0),
            )
          ]
      ),
      body: new Container(
        padding: const EdgeInsets.only(left: 20.0),
        child: FutureBuilder <List<Todo>> (
          future: todoList,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (content,index){
                    return Slidable(
                      delegate: SlidableScrollDelegate(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => deleteTodo(context, snapshot.data[index].id),
                        ),
                      ],
                      child: ListTile(
                        title: Text(
                            snapshot.data[index].content
                        ),
                         onTap: ()=>gotoViewPage(context, snapshot.data[index].id),
                      ),
                    );
                  },
                );
              }
            }
            return new Container(
              alignment: Alignment.center,
              child: new CircularProgressIndicator(),
            );
          }
        )
      )
    );
  }
}

Color getAppBarColorByType(String type) {
  Color color;
  switch (type) {
    case Constant.secondBlock :
      color = Colors.orange[400].withOpacity(0.5);
      break;
    case Constant.thirdBlock :
      color = Colors.blue[400].withOpacity(0.5);
      break;
    case Constant.fourthBlock :
      color = Colors.green[400].withOpacity(0.5);
      break;
    default:
      color = Colors.red[400].withOpacity(0.5);
      break;
  }
  return color;
}
