import 'package:flutter/material.dart';
import '../domain/data_provider/box_manager.dart';
import '../domain/entity/group.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  String errorText;
  var _groupName = '';

  set groupName(String value) {
    if (errorText != null && value.trim().isNotEmpty) {
      errorText = null;
      notifyListeners();
    }
    _groupName = value;
  }

  Future<void> saveGroup(BuildContext context) async {
    final groupName = _groupName.trim();
    if (groupName.isEmpty) {
      errorText = 'Enter name group';
      notifyListeners();
      return;
    }

    final box = await BoxManager.instance.openGroupBox();
    final group = Group(name: groupName, isDone: false);
    await box.add(group);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider extends InheritedNotifier {
  const GroupFormWidgetModelProvider({
    Key key,
    @required this.model,
    @required Widget child,
  }) : super(key: key, notifier: model, child: child);

  final GroupFormWidgetModel model;

  static GroupFormWidgetModelProvider watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return false;
  }
}
