// import 'dart:convert';
//
// import 'package:confereus/routes/main_page.dart';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
//
// Future<IOWebSocketChannel?> login(BuildContext context, String _mail, String _pwd) async {
//   String auth = "8hi38h4n4jr8fj4j4nriio1903";
//   String? errorMessage;
//   try {
//     // Create connection.
//     IOWebSocketChannel channel =
//         IOWebSocketChannel.connect('ws://10.0.2.2:3000/login$_mail');
//
//     // Data that will be sended to Node.js
//     String signUpData =
//         "{'auth':'$auth','cmd':'login','email':'$_mail','hash':'$_pwd'}";
//     // Send data to Node.js
//     channel.sink.add(signUpData);
//     // listen for data from the server
//     return channel;
//   } catch (e) {
//     print("Error on connecting to websocket: $e");
//   }
//   // return errorMessage;
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../constants.dart';
import '../../routes/main_page.dart';

GetStorage storage = GetStorage('user');
final secstore = FlutterSecureStorage();

Future<String?> login(BuildContext context, String _mail, String _cpwd) async {
  Map<String, dynamic> reqBody = {
    "email": _mail,
    "password": _cpwd,
  };
  HttpClient client = HttpClient();
  HttpClientRequest request = await client.postUrl(Uri.parse(loginRoute));
  request.headers.contentType = ContentType.json;
  request.add(utf8.encode(jsonEncode(reqBody)));
  HttpClientResponse res = await request.close();
  var data = jsonDecode(await res.transform(utf8.decoder).join());
  // print('cookies of res = ${res.cookies}');
  // print('cookies of req = ${request.cookies}');
  // await secstore.write(key: 'cookies', value: res.cookies.join('; '));

  // http.Response res = await http.post(
  //   Uri.parse(loginRoute),
  //   headers: {"Content-Type": "application/json"},
  //   body: jsonEncode(reqBody),
  // );
  // var jsonResp = jsonDecode(res.body);
  if (data['status']) {
  //
    var token = data['token'];
    await storage.write('token', data['token']);
    await storage.write('isLoggedIn', true);
    await storage.write('auth_provider', 'email_login');
    final auth = JwtDecoder.decode(token);
    print("data: ${auth}");
    print(storage.getKeys());
    print(storage.getValues());
    // await secstore.write(key: 'cookies', value: );
    updateCookie(res);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MainPage(email: auth['email'],)));
  } else {
    return data['success'];
  }
}

void updateCookie(HttpClientResponse response) async {
  for(Cookie cookie in response.cookies) {
    await secstore.write(key: cookie.name, value: cookie.value);
    print('${cookie.name} =>>> ${cookie.value}');
  }
  // print(await secstore.readAll());
  // print(response.headers);
  print("head");
}
