import 'package:flutter/material.dart';
import '../domain/data_provider/box_manager.dart';
import '../domain/entity/task.dart';

class TaskFormWidgetModel {
  TaskFormWidgetModel({@required this.groupKey});

  int groupKey;
  var taskText = '';

  Future<void> saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;
    final task = Task(text: taskText, isDone: false);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    await box.add(task);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  const TaskFormWidgetModelProvider(
      {Key key, @required this.model, @required Widget child})
      : super(key: key, child: child);

  final TaskFormWidgetModel model;

  static TaskFormWidgetModelProvider watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
        ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
