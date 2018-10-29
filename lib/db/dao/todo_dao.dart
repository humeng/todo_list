import 'package:todo_list/db/entry/todo_entry.dart';
import 'package:todo_list/db/entry_dao.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:todo_list/db/table_entry.dart';

class TodoDao extends EntryDao<Todo> {
  ///创建数据表
  ///[db] 数据表
  ///[version] 版本号
  @override
  FutureOr createTable(Database db, int version) async {
    return await db.execute('''
          create table $todoTableName (
          $columnId integer primary key autoincrement,
          $todoContent text not null,
          $todoType text not null,
          $todoIsWarning integer not null,
          $todoWarningTime text not null,
          $todoIsDelete integer not null,
          $todoCreateTime text not null,
          $todoUpdateTime text not null)
          ''');
  }

  ///增
  @override
  Future<bool> add(Database db, Todo todo) async {
    assert(db != null && todo != null);
    todo.createTime = DateTime.now().toString();
    todo.updateTime = DateTime.now().toString();
    //返回插入后的id
    int id = await db.insert(todoTableName, todo.toMap());
    if (id > 0) {
      todo.id = id;
      return true;
    }
    return false;
  }

  ///删
  ///返回影响的行数 即1为删除成功，0为删除失败
  Future<bool> delete(Database db, int id) async {
    assert(db != null && id > 0);
    int result =
        await db.delete(todoTableName, where: "$columnId = ?", whereArgs: [id]);
    if (result == 1) {
      return true;
    }
    return false;
  }

  ///改
  ///返回影响的行数 即1为更改成功，0为更改失败
  Future<bool> update(Database db, Todo todo) async {
    assert(todo != null);
    todo.updateTime = DateTime.now().toString();
    int result = await db.update(todoTableName, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
    if (result == 1) {
      return true;
    }
    return false;
  }

  ///查
  ///[type] 查找的类型
  Future<List<Map<String, dynamic>>> query(Database db, dynamic type) async {
//    return await db.rawQuery("select * from $tableName where type=?", [type]);
    return await db.query(todoTableName,
        columns: [
          columnId,
          todoContent,
          todoType,
          todoIsWarning,
          todoWarningTime,
          todoIsDelete,
          todoCreateTime
        ],
        where: "type = ?",
        whereArgs: [type]);
  }
}
