import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:todo_list/db/table_entry.dart';



abstract class EntryDao<T extends Entry>{

  ///创建表
  FutureOr createTable(Database db, int version);

  ///增
  Future<bool> add(Database db, T t);

  ///删
  Future<bool> delete(Database db, int id);

  ///改
  Future<bool> update(Database db, T t);

  ///查
  Future<List<Map<String, dynamic>>> query(
      Database db, dynamic type);
}
