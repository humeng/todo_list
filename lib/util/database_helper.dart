import 'package:sqflite/sqflite.dart';
import 'dart:async';

////在pubspec.yaml中dependencies:加入sqflite: any

final String tableName = "note";
final String columnId = "id";
final String columnContent = "content";
final String columnType = "type";
final String columnIsWarning = "isWarning";
final String columnWarningTime = "warningTime";
final String columnIsDelete = "isDelete";
final String columnCreateTime = "createTime";
final String columnUpdateTime = "updateTime";

class Todo {
  int id;
  String content;
  String type;
  bool isWarning;
  String warningTime;
  bool isDelete;
  String createTime;
  String updateTime;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnContent: content,
      columnType: type,
      columnIsWarning: isWarning == true ? 1 : 0 ,
      columnWarningTime: warningTime,
      columnIsDelete: isDelete == true ? 1 : 0,
      columnCreateTime:createTime,
      columnUpdateTime:updateTime,
    };

    return map;
  }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    content = map[columnContent];
    type = map[columnType];
    isWarning = map[columnIsWarning] == 1;
    warningTime = map[columnWarningTime];
    isDelete = map[columnIsDelete] == 1;
    createTime = map[columnCreateTime];
    updateTime = map[columnUpdateTime];
  }
}

class DbProvider {
  Database db;

  DbProvider();

  Future<bool> open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          create table $tableName (
          $columnId integer primary key autoincrement,
          $columnContent text not null,
          $columnType text not null,
          $columnIsWarning integer not null,
          $columnWarningTime text not null,
          $columnIsDelete integer not null,
          $columnCreateTime text not null,
          $columnUpdateTime text not null)
          ''');
        });

    return dbIsOpen();
  }

  //返回插入的Id
  Future<int> insert(Todo todo) async {
    todo.id = null;
    todo.createTime = DateTime.now().toString();
    todo.updateTime = DateTime.now().toString();

    return await db.insert(tableName , todo.toMap());
  }

  Future<List<Map>> getTodoById(int id) async {
    return await db.query(tableName ,columns: null,
        //columns: [columnId, columnContent, columnType, columnIsWarning, columnWarningTime, columnIsDelete, columnCreateTime],
        where: "id = ?",
        whereArgs: [id]);
  }
  Future<List<Map>> getListByType(String type) async {
    return await db.rawQuery("select * from $tableName where type=?", [type]);
//    return await db.query(tableName ,columns: null,
//        //columns: [columnId, columnContent, columnType, columnIsWarning, columnWarningTime, columnIsDelete, columnCreateTime],
//        where: "type = ?",
//        whereArgs: [type]);
  }

  Future<List<Map>> todoBySql(String sqlStr) async{
    return await db.rawQuery(sqlStr);
  }

  //返回1删除成功
  Future<int> delete(int id) async {
    return await db.delete(tableName , where: "$columnId = ?", whereArgs: [id]);
  }

  //返回1更新成功
  Future<int> update(Todo todo) async {
    todo.updateTime = DateTime.now().toString();
    return await db.update(tableName , todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }

  Future<bool> close() async {
     await db.close();
    return dbIsOpen();
  }

  bool dbIsOpen() => db.isOpen;
}