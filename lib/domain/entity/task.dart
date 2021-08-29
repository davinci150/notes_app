import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 2)
class Task extends HiveObject {
  Task({@required this.text, @required this.isDone});

  @HiveField(0)
  String text;

  @HiveField(1)
  bool isDone;
}
