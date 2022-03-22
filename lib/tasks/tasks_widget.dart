import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notes_app/ads/ad_state.dart';
import 'package:provider/provider.dart';

import 'tasks_widget_model.dart';

class TasksWidgetConfiguration {
  TasksWidgetConfiguration({
    @required this.groupKey,
    @required this.title,
  });
  final int groupKey;
  final String title;
}

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key key, @required this.configuration}) : super(key: key);
  final TasksWidgetConfiguration configuration;
  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  TasksWidgetModel _model;

  @override
  void initState() {
    _model = TasksWidgetModel(configuration: widget.configuration);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
      model: _model,
      child: const TasksWidgetBody(),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model.configuration.title ?? 'tasks';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TasksListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TasksListWidget extends StatelessWidget {
  const _TasksListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        TasksWidgetModelProvider.watch(context)?.model?.tasks?.length ?? 0;
    return Stack(
      children: [
        ListView.separated(
          itemCount: groupsCount,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 3,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return _TaskListRowWidget(
              indexInList: index,
            );
          },
        ),
      ],
    );
  }
}

class _TaskListRowWidget extends StatelessWidget {
  const _TaskListRowWidget({Key key, @required this.indexInList})
      : super(key: key);
  final int indexInList;

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context).model;
    final task = model.tasks[indexInList];
    return InkWell(
      onTap: () => model.deleteTask(indexInList),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: const Color(0xFF1f1f1f),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Checkbox(
                  shape: const CircleBorder(),
                  checkColor: Colors.black,
                  activeColor: Colors.white,
                  hoverColor: Colors.red,
                  focusColor: Colors.red,
                  value: task.isDone,
                  onChanged: (value) => model.doneToogle(indexInList)
                  // onChanged: (bool value) => setState(() {
                  //       task.isDone = value;
                  //     })
                  ),
              InkWell(
                onTap: () {},
                child: Text(
                  task.text,
                  style: TextStyle(
                      color: !task.isDone ? Colors.white : Colors.grey,
                      fontSize: 16,
                      decoration: !task.isDone
                          ? TextDecoration.none
                          : TextDecoration.lineThrough),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
