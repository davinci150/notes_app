import 'package:hive/hive.dart';

import '../entity/group.dart';
import '../entity/task.dart';

class BoxManager {
  BoxManager._();
  static final BoxManager instance = BoxManager._();
  final Map<String, int> _boxCounter = <String, int>{};

  Future<Box<Group>> openGroupBox() async {
    return _openBox(name: 'groups_box', typeId: 1, adapter: GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox(
        name: makeTaskBoxName(groupKey), typeId: 2, adapter: TaskAdapter());
  }

  String makeTaskBoxName(int groupKey) => 'tasks_box_$groupKey';

  Future<void> closeBox<T>(Box<T> box) async {
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
      return;
    }
    var count = _boxCounter[box.name] ?? 1;
    count -= 1;
    _boxCounter[box.name] = count;
    if (count > 0) return;
    _boxCounter.remove(box.name);
    await box.compact();
    await box.close();
  }

  Future<Box<T>> _openBox<T>(
      {String name, int typeId, TypeAdapter<T> adapter}) async {
    if (Hive.isBoxOpen(name)) {
      final count = _boxCounter[name] ?? 1;
      _boxCounter[name] = count + 1;
      return Hive.box(name);
    }
    _boxCounter[name] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }

    return Hive.openBox<T>(name);
  }
}
