import 'package:flutter/material.dart';

class EventType {
  final int index;
  final String event;
  final Color color;

  const EventType(this.index, this.event, this.color);

  ///第一象限
  static const EventType URGENT_IMPORTANT =
      const EventType(0, "重要且紧急", Colors.red);

  ///第二象限
  static const EventType URGENT_NOT_IMPORTANT =
      const EventType(1, "重要但不紧急", Colors.green);

  ///第三象限
  static const EventType IMPORTANT_NOT_URGENT =
      const EventType(2, "不重要且不紧急", Colors.blue);

  ///第四象限
  static const EventType NOT_IMPORTANT_NOT_URGENT =
      const EventType(3, "不重要但紧急", Colors.purple);

  static const Map<int, EventType> EVENT_MAP = {
    0: URGENT_IMPORTANT,
    1: URGENT_NOT_IMPORTANT,
    2: IMPORTANT_NOT_URGENT,
    3: NOT_IMPORTANT_NOT_URGENT,
  };
}
