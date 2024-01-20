import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/tiles/event_tiles_big.dart';
import 'package:confereus/sockets/socket_stream.dart';
import 'package:confereus/stream_socket.dart';
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
  final _streamController =
      SocketController<List<Conference>?>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SocketStream>(context, listen: false)
        .fetchAllDocuments(initController, 'conferences');
  }

  void initController(dynamic eventdata) {
    _streamController
        .add((eventdata as List).map((e) => Conference.fromJson(e)).toList());
  }

  @override
  void dispose() {
    print("dispose");
    // _streamController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
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
              stream: _streamController.get,
              builder: (context, snapshot) {
                // if (!snapshot.hasData) {
                //   return const Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                List<Conference>? data;
                if (snapshot.hasData) {
                  // if (snapshot.data!.isEmpty) {
                  //   return Container();
                  // }
                  data = snapshot.data
                      ?.where((e) => !e.admin.contains(storage.read('userId')))
                      .toList();
                }
                return Builder(builder: (context) {
                  if (data != null && data.isEmpty) {
                    return const Center(
                      child: CustomText("Nothing to show!"),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    // primary: true,
                    itemCount: data?.length ?? 3,
                    itemBuilder: (_, i) {
                      bool? isRegistered;
                      if (data != null) {
                        isRegistered =
                            data[i].registered.contains(storage.read('userId'));
                      }
                      return ConferenceBigCard(
                        data: data?[i],
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
                });
              }),
        );
      }),
    );
  }
}
