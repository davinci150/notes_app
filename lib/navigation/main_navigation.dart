import 'package:flutter/material.dart';
import 'package:notes_app/ads/ad_screen.dart';
import 'package:notes_app/main.dart';
import '../group_form/group_form_widget.dart';
import '../groups/groups_widget.dart';
import '../task_form/task_form_widget.dart';
import '../tasks/tasks_widget.dart';

abstract class MainNavigationRouteNames {
  static const groups = 'groups';
  static const groupsForm = 'groups/groupsForm';
  static const tasks = 'groups/tasks';
  static const tasksForm = 'groups/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.groups;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.groups: (context) => const GroupsWidget(),
    MainNavigationRouteNames.groupsForm: (context) => const GroupFormWidget(),
  };
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.tasks:
        final configuration = settings.arguments as TasksWidgetConfiguration;
        return MaterialPageRoute(
            builder: (context) => TasksWidget(
                  configuration: configuration,
                ));

      case MainNavigationRouteNames.tasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => TaskFormWidget(
                  groupKey: groupKey,
                ));

      default:
        const widget = Text('Navigation Error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
