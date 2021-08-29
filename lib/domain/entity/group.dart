import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


part 'group.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject{
  Group({@required this.name});

  @HiveField(0)
  String name;


}
