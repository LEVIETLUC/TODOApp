
import 'package:flutter/material.dart';

class TodoTask {
  final String id;
  final String todoDetails;
  final bool isCompleted;
  final DateTime ondate;
  final TimeOfDay ontime;
  final String priority;

  TodoTask({
    required this.id,
    required this.todoDetails,
    required this.isCompleted,
    required this.ondate,
    required this.ontime,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoDetails': todoDetails,
      'isCompleted': isCompleted ? 1 : 0,
      'ondate': ondate.toIso8601String(),
      'ontime': '${ontime.hour}:${ontime.minute}',
      'priority': priority,
    };
  }

  factory TodoTask.fromMap(Map<String, dynamic> map) {
    return TodoTask(
      id: map['id'],
      todoDetails: map['todoDetails'],
      isCompleted: map['isCompleted'] == 1,
      ondate: DateTime.parse(map['ondate']),
      ontime: TimeOfDay(
        hour: int.parse(map['ontime'].split(':')[0]),
        minute: int.parse(map['ontime'].split(':')[1]),
      ),
      priority: map['priority'],
    );
  }
}

