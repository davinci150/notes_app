import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pedantic/pedantic.dart';

import '../domain/data_provider/box_manager.dart';
import '../domain/entity/group.dart';
import '../navigation/main_navigation.dart';
import '../tasks/tasks_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  GroupsWidgetModel() {
    _setup();
  }
  Future<Box<Group>> _box;
  var _groups = <Group>[];
  ValueListenable<Object> _listenableBox;
  List<Group> get groups => _groups.toList();

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {

    final group = (await _box).getAt(groupIndex);
    if(group != null){
      final configuration = TasksWidgetConfiguration(groupKey: group.key as int, title: group.name);
    unawaited(Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.tasks, arguments: configuration));
        }

  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
     final groupKey = (await _box).keyAt(groupIndex) as int;
   final taskBoxName =  BoxManager.instance.makeTaskBoxName(groupKey);
   await Hive.deleteBoxFromDisk(taskBoxName);

    await box.deleteAt(groupIndex);
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openGroupBox();

    await _readGroupsFromHive();
_listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }
  @override
    Future<void> dispose()async {
      _listenableBox.removeListener(_readGroupsFromHive);
     await BoxManager.instance.closeBox(await _box);
      super.dispose();
    }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  const GroupsWidgetModelProvider(
      {Key key, @required Widget child, @required this.model})
      : super(key: key, child: child, notifier: model);

  final GroupsWidgetModel model;

  static GroupsWidgetModelProvider watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
