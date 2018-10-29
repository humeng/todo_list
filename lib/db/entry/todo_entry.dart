import 'package:todo_list/db/table_entry.dart';

final String todoTableName = "todo";
final String todoContent = "content";
final String todoType = "type";
final String todoIsWarning = "isWarning";
final String todoWarningTime = "warningTime";
final String todoIsDelete = "isDelete";
final String todoCreateTime = "createTime";
final String todoUpdateTime = "updateTime";

class Todo extends Entry {
  String content;
  String type;
  bool isWarning;
  String warningTime;
  bool isDelete;
  String createTime;
  String updateTime;

  Todo(
      {this.content = "",
      this.type = "0",
      this.isWarning = false,
      this.warningTime = "",
      this.isDelete = false,
      this.createTime = "",
      this.updateTime = ""});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      todoContent: content,
      todoType: type,
      todoIsWarning: isWarning == true ? 1 : 0,
      todoWarningTime: warningTime,
      todoIsDelete: isDelete == true ? 1 : 0,
      todoCreateTime: createTime,
      todoUpdateTime: updateTime,
    };

    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    content = map[todoContent];
    type = map[todoType];
    isWarning = map[todoIsWarning] == 1;
    warningTime = map[todoWarningTime];
    isDelete = map[todoIsDelete] == 1;
    createTime = map[todoCreateTime];
    updateTime = map[todoUpdateTime];
  }
}
