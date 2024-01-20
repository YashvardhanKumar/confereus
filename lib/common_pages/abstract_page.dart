import 'package:confereus/constants.dart';
import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:flutter/material.dart';

import '../components/custom_text.dart';

class AbstractPage extends StatefulWidget {
  const AbstractPage({Key? key, required this.isAdmin, required this.conference, this.curEvent}) : super(key: key);
  final bool isAdmin;
  final Conference conference;
  final Event? curEvent;

  @override
  State<AbstractPage> createState() => _AbstractPageState();
}

class _AbstractPageState extends State<AbstractPage>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  bool expand = true;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.ease,
    );
  }

  void _runExpandCheck() {
    if (expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(AbstractPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Abstracts'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView.builder(
          itemBuilder: (_, i) {
            return Material(
              child: InkWell(
                onTap: () {
                  // Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (_) => ShowAbstract(
                  //           isAdmin: widget.isAdmin,
                  //           abstract: abstract[i],
                  //         ),
                  //       ),
                  //     );
                },
                child: Column(
                  children: [
                    const ListTile(
                      title: CustomText("Abstract Name"),
                      subtitle: CustomText("Event Name"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: List.generate(
                          2,
                          (index) => const Padding(
                            padding: EdgeInsets.all(1.5),
                            child: InputChip(
                              label: Text("yash"),
                              labelPadding: EdgeInsets.zero,
                              backgroundColor: kColorLight,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }
}

//return Scaffold(
//       appBar: AppBar(
//         title: const CustomText('Abstract Submissions'),
//       ),
//       // floatingActionButton: widget.isAdmin
//       //     ? null
//       //     : FloatingActionButton(
//       //         onPressed: () {},
//       //         isExtended: true,
//       //         child: Row(
//       //           children: [
//       //             Icon(Icons.add_card_rounded),
//       //             SizedBox(width: 5),
//       //             CustomText("Add Abstract"),
//       //           ],
//       //         ),
//       //       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           setState(() {});
//         },
//         child: Consumer2<AbstractAPI, UserProfileAPI>(
//           builder: (context, abstractDat, userProfile, child) {
//             return FutureBuilder<List<Abstract>?>(
//               future: abstractDat.fetchAbstract(widget.conference.id, null),
//               builder: (context, snapshot) {
//                 List<Abstract> abstract = [];
//                 if (snapshot.hasData) {
//                   //TODO: print(snapshot.requireData);
//                   // if (widget.isAdmin) {
//                   abstract = (snapshot.requireData ?? [])
//                       .where((e) =>
//                           widget.isAdmin ||
//                           e.userId.contains(storage.read('userId')))
//                       .toList();
//                   // } else {
//
//                   // }
//                 }
//
//                 if (abstract.isEmpty) {
//                   return const Center(
//                     child: CustomText(
//                       'No Submissions Yet',
//                       color: Colors.grey,
//                     ),
//                   );
//                 }
//                 return ListView.builder(
//                   itemBuilder: (context, i) => ListTile(
//                     title: CustomText(abstract[i].paperName),
//                     subtitle: CustomText(
//                         abstract[i].users?.map((e) => e.name).join(",") ?? ''),
//                     trailing: CustomText(
//                         DateFormat.yMd().format(abstract[i].createdAt)),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ShowAbstract(
//                             isAdmin: widget.isAdmin,
//                             abstract: abstract[i],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   itemCount: abstract.length,
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );