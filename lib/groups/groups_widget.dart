import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notes_app/ads/ad_state.dart';
import 'package:notes_app/tasks/tasks_widget.dart';
import 'package:provider/provider.dart';
import '../group_form/group_form_widget_model.dart.dart';
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

class _GroupWidgetBody extends StatefulWidget {
  const _GroupWidgetBody({Key key}) : super(key: key);

  @override
  State<_GroupWidgetBody> createState() => _GroupWidgetBodyState();
}

class _GroupWidgetBodyState extends State<_GroupWidgetBody> {
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3082969872662957/3702828366',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  @override
  void initState() {
    myBanner.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
            // IconButton(
            //     icon: const Icon(
            //       Icons.delete,
            //       color: Colors.white,
            //     ),
            //     onPressed: () {})
          ],
          backgroundColor: Colors.transparent,
          title: const Text(
            'Notes',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _GroupListWidget(),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: AdWidget(
                  ad: myBanner,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            GroupsWidgetModelProvider.read(context)?.model?.showForm(context);
          },
          child: const Icon(
            Icons.add,
            size: 34,
            color: Colors.black,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class _GroupListWidget extends StatefulWidget {
  const _GroupListWidget({Key key}) : super(key: key);

  @override
  State<_GroupListWidget> createState() => _GroupListWidgetState();
}

class _GroupListWidgetState extends State<_GroupListWidget> {
  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context).model;
    final groupname = model.groups;
    final groupsCount =
        GroupsWidgetModelProvider.watch(context)?.model?.groups?.length ?? 0;
    return ReorderableListView.builder(
        itemCount: groupsCount,
        itemBuilder: (context, index) {
          // print(ValueKey(groupname[index].name));
          return _GroupListRowWidget(
            key: ValueKey(groupname[index]),
            indexInList: index,
          );
        },
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex = newIndex - 1;
            }
            final element = groupname.removeAt(oldIndex);
            groupname.insert(newIndex, element);
          });
        });

    //  ListView.separated(
    //   itemCount: groupsCount,
    //   separatorBuilder: (BuildContext context, int index) {
    //     return const SizedBox(
    //       height: 3,
    //     );
    //   },
    //   itemBuilder: (BuildContext context, int index) {
    //     return _GroupListRowWidget(
    //       indexInList: index,
    //     );
    //   },
    // );
  }
}

/*class AdMob extends StatefulWidget {
  const AdMob({Key key}) : super(key: key);

  @override
  _AdMobState createState() => _AdMobState();
}

class _AdMobState extends State<AdMob> {
  BannerAd banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((value) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: const AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: AdWidget(
        ad: banner,
      ),
    );
  }
}*/

class _GroupListRowWidget extends StatelessWidget {
  const _GroupListRowWidget({Key key, @required this.indexInList})
      : super(key: key);
  final int indexInList;
  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context).model;
    final group = model.groups[indexInList];
    return InkWell(
      // onTap: () => model.showTasks(context, indexInList),
      onTap: () => null,
      child: Card(
        // elevation: group.isDone ? 0 : 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // color: const Color(0xFF1f1f1f),
        color: const Color(0xFF001B2C).withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Checkbox(
              //     side: const BorderSide(color: Colors.white, width: 2),
              //     shape: const CircleBorder(),
              //     checkColor: Colors.black,
              //     // checkColor: Colors.white,
              //     activeColor: !group.isDone ? Colors.white : Colors.grey,
              //     focusColor: Colors.white,
              //     value: group.isDone,
              //     onChanged: (value) => model.doneToogle(indexInList)),
              Expanded(
                child: Text(
                  group.name,
                  style: TextStyle(
                      // color: !group.isDone ? Colors.white : Colors.grey,
                      color: Colors.white,
                      fontSize: 16,
                      decoration: !group.isDone
                          ? TextDecoration.none
                          : TextDecoration.lineThrough),
                ),
              ),
              IconButton(
                onPressed: () => model.deleteGroup(indexInList),
                icon: const Icon(Icons.delete),
                // color: !group.isDone ? Colors.white : Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
