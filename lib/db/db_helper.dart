import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/constant/db_operation_type.dart';
import 'dart:async';

import 'package:todo_list/db/entry_dao.dart';
import 'package:todo_list/db/table_entry.dart';

////在pubspec.yaml中dependencies:加入sqflite: any
class DatabaseHelper {
  static const String _DATABASE_NAME = "notepad.db";
  static const int _VERSION = 1;

  DatabaseHelper._internal();

  static DatabaseHelper get instance => _getInstance();
  static DatabaseHelper _instance;

  static DatabaseHelper _getInstance() {
    if (_instance == null) {
      _instance = new DatabaseHelper._internal();
    }
    return _instance;
  }

  ///打开数据库
  Future<Database> _openDB(EntryDao entryDao) async {
    String databasePath = join(await getDatabasesPath(), _DATABASE_NAME);
    return await openDatabase(databasePath,
        version: _VERSION, onCreate: entryDao.createTable);
  }

  Future<dynamic> handle<T extends Entry>(
      DBOperation operationType, EntryDao<T> entryDao,
      {T t, dynamic type}) async {
    Database db;
    var result;
    try {
      db = await _openDB(entryDao);
      switch (operationType) {
        case DBOperation.ADD:
          result = await entryDao.add(db, t);
          break;
        case DBOperation.DELETE:
          result = await entryDao.delete(db, t.id);
          break;
        case DBOperation.UPDATE:
          result = await entryDao.update(db, t);
          break;
        case DBOperation.QUERY:
          result = await entryDao.query(db, type);
          break;
      }
      return result;
    } catch (e) {
      print(e);
      return false;
    } finally {
      if (db != null && db.isOpen) {
        db.close();
      }
    }
  }
}
