import 'package:flutter/material.dart';

class DateUtil {
  ///格式化日期 格式：yyyy/MM/dd hh:mm
  ///[dateTime] 需要格式化的日期
  ///[timeOfDay] 需要格式化的时间
  static String format(DateTime dateTime, TimeOfDay timeOfDay) {
    return "${dateTime.year}" +
        ("${dateTime.month}".length == 1 ? "/0" : "/") +
        "${dateTime.month}" +
        ("${dateTime.day}".length == 1 ? "/0" : "/") +
        "${dateTime.day}" +
        ("${timeOfDay.hour}".length == 1 ? " 0" : " ") +
        "${timeOfDay.hour}" +
        ("${timeOfDay.minute}".length == 1 ? ":0" : ":") +
        "${timeOfDay.minute}";
  }
}
