import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../domain/data_provider/box_manager.dart';
import '../domain/entity/task.dart';
import '../navigation/main_navigation.dart';
import 'tasks_widget.dart';

class TasksWidgetModel extends ChangeNotifier {
  TasksWidgetModel({@required this.configuration}) {
    _setup();
  }
  ValueListenable<Object> _listenableBox;
  TasksWidgetConfiguration configuration;
  Future<Box<Task>> _box;

  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tasksForm,
        arguments: configuration.groupKey);
  }

  Future<void> deleteTask(int taskIndex) async {
    await (await _box).deleteAt(taskIndex);
  }

  Future<void> doneToogle(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(configuration.groupKey);
    _listenableBox = (await _box).listenable();
    await _readTasksFromHive();

    _listenableBox?.addListener(_readTasksFromHive);
  }

  @override
  Future<void> dispose() async {
    _listenableBox.removeListener(_readTasksFromHive);
    await BoxManager.instance.closeBox(await _box);
    super.dispose();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  const TasksWidgetModelProvider(
      {Key key, @required Widget child, @required this.model})
      : super(key: key, child: child, notifier: model);
  final TasksWidgetModel model;

  static TasksWidgetModelProvider watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
