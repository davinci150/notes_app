import 'package:flutter/material.dart';
import 'groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key key}) : super(key: key);

  @override
  _GroupsWidgetState createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupWidgetBody(),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class _GroupWidgetBody extends StatelessWidget {
  const _GroupWidgetBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color(0xff014872),
            Color(0xffA0EACF),
          ])),
      child: Scaffold(
        // backgroundColor: const Color(0xFF000000),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {})
          ],
          backgroundColor: Colors.transparent,
          title: const Text(
            'Notes',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.only(top: 10,left: 10,right: 10),
          child: _GroupListWidget(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            GroupsWidgetModelProvider.read(context)?.model?.showForm(context);
            // _showModal(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showModal(BuildContext context) {
    final Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            height: 140,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(hintText: 'Enter your text'),
                    autofocus: true,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('done'),
                    ),
                  )
                ],
              ),
            ));
      },
    );

    future.then(_closeModal);
  }

  void _closeModal(void value) {
    print('modal closed');
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        GroupsWidgetModelProvider.watch(context)?.model?.groups?.length ?? 0;
    return ListView.separated(
      itemCount: groupsCount,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 3,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return _GroupListRowWidget(
          indexInList: index,
        );
      },
    );
  }
}

class _GroupListRowWidget extends StatefulWidget {
  const _GroupListRowWidget({Key key, @required this.indexInList})
      : super(key: key);
  final int indexInList;

  @override
  __GroupListRowWidgetState createState() => __GroupListRowWidgetState();
}

class __GroupListRowWidgetState extends State<_GroupListRowWidget> {
  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context).model;
    final group = model.groups[widget.indexInList];
    return InkWell(
      onTap: () => model.showTasks(context, widget.indexInList),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // color: const Color(0xFF1f1f1f),
        color:  Color(0xFF001B2C).withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Checkbox(
                  // checkColor: Colors.black,
                  // checkColor: Colors.white,
                  activeColor: Colors.grey,
                  focusColor: Colors.red,
                  value: false,
                  onChanged: (value) => model.deleteGroup(widget.indexInList)),
              Text(
                group.name,
                style: TextStyle(
                  color: !false ? Colors.white : Colors.grey,
                  fontSize: 16,
                  // decoration: !isCheck
                  //     ? TextDecoration.none
                  //     : TextDecoration.lineThrough
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
