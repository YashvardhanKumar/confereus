import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/tiles/event_tiles_big.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../API/conference_api.dart';
import '../../main.dart';
import '../../models/conference model/conference.model.dart';

class SeeAllPage extends StatefulWidget {
  const SeeAllPage(
      {Key? key,
      required this.stream,
      this.isCreated = false,
      required this.isRegistered})
      : super(key: key);
  final Stream<List<Conference>?> stream;

  final bool isCreated;
  final bool isRegistered;

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  String curUserId = storage.read('userId');
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
              stream: widget.stream,
              builder: (context, snapshot) {
                // if (!snapshot.hasData) {
                //   return const Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                if (snapshot.data!.isEmpty) {
                  return Container();
                }
                List<Conference>? data = snapshot.data
                    ?.where((e) =>
                        e.registered.contains(curUserId) ||
                        !widget.isRegistered)
                    .toList();
                if (widget.isCreated && !widget.isRegistered) {
                  data =
                      data?.where((e) => e.admin.contains(curUserId)).toList();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  // primary: true,
                  itemCount: data?.length ?? 0,
                  itemBuilder: (_, i) {
                    bool isRegistered =
                        data?[i].registered.contains(storage.read('userId')) ??
                            false;
                    return ConferenceBigCard(
                      data: data?[i],
                      onRegisterPressed: () async {
                        if (data == null) return;
                        await confApi.registerConference(data[i].id);
                        setState(() {});
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
