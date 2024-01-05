import 'package:confereus/API/abstract_api.dart';
import 'package:confereus/API/user_profile_api.dart';
import 'package:confereus/models/abstract%20model/abstract.model.dart';
import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../custom_text.dart';
import 'show_abstract.dart';

class AbstractPage extends StatefulWidget {
  const AbstractPage({Key? key, required this.isAdmin, required this.conference, this.curEvent}) : super(key: key);
  final bool isAdmin;
  final Conference conference;
  final Event? curEvent;

  @override
  State<AbstractPage> createState() => _AbstractPageState();
}

class _AbstractPageState extends State<AbstractPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Abstract Submissions'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Consumer2<AbstractAPI, UserProfileAPI>(
          builder: (context, abstractDat, userProfile, child) {
            return FutureBuilder<List<Abstract>?>(
              future: abstractDat.fetchAbstract(widget.conference.id,null),
              builder: (context, snapshot) {
                List<Abstract> abstract = [];
                if (snapshot.hasData) {
                  print(snapshot.requireData);
                  // if (widget.isAdmin) {
                    abstract = (snapshot.requireData ?? [])
                        .where((e) =>
                            widget.isAdmin ||
                            e.userId.contains(storage.read('userId')))
                        .toList();
                  // } else {

                  // }
                }

                if(abstract.isEmpty) {
                  return Center(
                    child: CustomText('No Submissions Yet', color: Colors.grey,),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, i) => ListTile(
                    title: CustomText(abstract[i].paperName),
                    subtitle: CustomText(
                        abstract[i].users?.map((e) => e.name).join(",") ?? ''),
                    trailing: CustomText(
                        DateFormat.yMd().format(abstract[i].createdAt)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShowAbstract(
                            isAdmin: widget.isAdmin,
                            abstract: abstract[i],
                          ),
                        ),
                      );
                    },
                  ),
                  itemCount: abstract.length,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
