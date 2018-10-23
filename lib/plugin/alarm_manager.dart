import 'package:flutter/services.dart';

class AlarManager {
  static final MethodChannel methodChannel = new MethodChannel("AlarmManager");

  ///添加闹钟
  ///[id] 通知的唯一标识
  ///[event] 提醒的事件
  ///[dateTime] 提醒日期的字符串，格式 yyyy/MM/dd hh:mm
  static void setAlarm(int id, String event, String dateTime) {
    assert(id >= 0);
    assert(event.isNotEmpty);
    assert(dateTime.isNotEmpty);
    methodChannel
        .invokeMethod("setAlarm", {"id": id, "event": event, "time": dateTime});
  }

  ///删除闹钟
  ///[id] 通知的唯一标识
  static void cancelAlarm(int id) {
    assert(id >= 0);
    methodChannel.invokeMethod("cancelAlarm", {"id": id});
  }
}
