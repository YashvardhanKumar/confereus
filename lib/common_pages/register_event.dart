import 'dart:io';

import 'package:confereus/components/custom_text.dart';
import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:confereus/sockets/socket_stream.dart';
import 'package:confereus/stream_socket.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterEvent extends StatefulWidget {
  const RegisterEvent({super.key, required this.conf});
  final Conference conf;
  @override
  State<RegisterEvent> createState() => _RegisterEventState();
}

class _RegisterEventState extends State<RegisterEvent> {
  final _socketController = SocketController<List<Event>?>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final prov = Provider.of<SocketStream>(context, listen: false);
    prov.fetchAllDocuments(initEvents, "events", {"confId": widget.conf.id});
  }

  void initEvents(events) {
    _socketController
        .add((events as List).map((e) => Event.fromJson(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Choose Event"),
      ),
      body: StreamBuilder<List<Event>?>(
          stream: _socketController.get,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: CustomText("No Events!"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                final data = snapshot.data![index];
                return ListTile(
                  title: CustomText(data.subject),
                  subtitle: CustomText(
                      "Held on ${DateFormat.yMd().format(data.startTime)} at ${DateFormat.jms().format(data.startTime)}"),
                );
              }),
            );
          }),
    );
  }
}
