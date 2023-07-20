import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/tiles/event_tiles_big.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../API/conference_api.dart';
import '../../../main.dart';
import '../../../models/conference model/conference.model.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Explore conferences'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          )
        ],
      ),
      body: Consumer<ConferenceAPI>(builder: (context, confApi, child) {
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: StreamBuilder<List<Conference>?>(
              stream: confApi.fetchConference('all').asStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return Container();
                }
                final data = snapshot.requireData?.where((e) => e.admin!=storage.read('userId')).toList() ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  // primary: true,
                  itemCount: data.length,
                  itemBuilder: (_, i) {

                    bool isRegistered =
                        data[i].registered!.contains(storage.read('userId'));
                    return ConferenceBigCard(
                      data: data[i],
                      onRegisterPressed: () async {
                        if (snapshot.hasData) {
                          await confApi
                              .registerConference(snapshot.data![i].id);
                          setState(() {});
                        }
                      },
                      isRegistered: isRegistered,
                    );
                  },
                );
              }),
        );
      }),
    );
  }
}
