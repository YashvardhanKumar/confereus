import 'dart:convert';

import 'package:confereus/routes/main_page.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

Future<IOWebSocketChannel?> getOTP(
  BuildContext context,
  String _mail,
) async {
  String auth = "8hi38h4n4jr8fj4j4nriio1903";
  String? otp;
  try {
    // Create connection.
    IOWebSocketChannel channel =
        IOWebSocketChannel.connect('ws://10.0.2.2:3000/getOTP$_mail');

    // Data that will be sended to Node.js
    String verifyData = "{'auth':'$auth','cmd':'get_OTP','email':'$_mail'}";
    // Send data to Node.js
    channel.sink.add(verifyData);
    // listen for data from the server
    return channel;
  } catch (e) {
    print("Error on connecting to websocket: $e");
  }
}

String? verifyEmail(
    BuildContext context, String otp, String verifyOTP) {
  String? errorMessage;
print(verifyOTP);
  if (verifyOTP == otp) {
    // Close connection.
    // return null;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool('loggedin', true);
    // prefs.setString('mail', _mail);
    // Return user to login if succesfull
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
    return null;
  } else {
    // channel.sink.close();
    return "Incorrect OTP";
  }
}
