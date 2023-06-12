import 'dart:convert';

import 'package:confereus/routes/main_page.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

Future<IOWebSocketChannel?> login(BuildContext context, String _mail, String _pwd) async {
  String auth = "8hi38h4n4jr8fj4j4nriio1903";
  String? errorMessage;
  try {
    // Create connection.
    IOWebSocketChannel channel =
        IOWebSocketChannel.connect('ws://10.0.2.2:3000/login$_mail');

    // Data that will be sended to Node.js
    String signUpData =
        "{'auth':'$auth','cmd':'login','email':'$_mail','hash':'$_pwd'}";
    // Send data to Node.js
    channel.sink.add(signUpData);
    // listen for data from the server
    return channel;
  } catch (e) {
    print("Error on connecting to websocket: $e");
  }
  // return errorMessage;
}
