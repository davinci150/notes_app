import 'package:flutter/material.dart';
import 'group_form_widget_model.dart.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({Key key}) : super(key: key);

  @override
  _GroupFormWidgetState createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
        model: _model, child: const _GroupFormWidgetBody());
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.watch(context)?.model;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
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
                TextField(
                  onChanged: (value) => model?.groupName = value,
                  onEditingComplete: () => model?.saveGroup(context),
                  decoration: InputDecoration(
                    hintText: 'Enter your text',
                    errorText: model?.errorText,
                  ),
                  autofocus: true,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      GroupFormWidgetModelProvider.read(context)
                          ?.model
                          ?.saveGroup(context);
                    },
                    child: const Text('done'),
                  ),
                )
              ],
            ),
          )),
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     title: const Text('new group'),
    //   ),
    //   body: const Center(
    //     child: Padding(
    //       padding: EdgeInsets.all(20),
    //       child: SizedBox(child: _GroupNameWidget()),
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () => GroupFormWidgetModelProvider.read(context)
    //         ?.model
    //         ?.saveGroup(context),
    //     child: const Icon(Icons.save),
    //   ),
    // );
  }
}

// class _GroupNameWidget extends StatelessWidget {
//   const _GroupNameWidget({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final model = GroupFormWidgetModelProvider.watch(context)?.model;
//     print(model?.errorText.toString());
//     return TextField(
//       autofocus: true,
//       decoration: InputDecoration(
//           errorText: model?.errorText,
//           border: const OutlineInputBorder(),
//           hintText: 'name group'),
//       onChanged: (value) => model?.groupName = value,
//       onEditingComplete: () => model?.saveGroup(context),
//     );
//   }
// }
