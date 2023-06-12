// import 'dart:convert';
//
// import 'package:confereus/routes/otp_page.dart';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
//
// Future<IOWebSocketChannel?> signUp(BuildContext context, String _mail, String _name,
//     String _dob, String _cpwd) async {
//   // Check if email is valid.
//   // bool isValid = RegExp(
//   //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//   //     .hasMatch(_mail);
//   String auth = "8hi38h4n4jr8fj4j4nriio1903";
//   String? errorMessage;
//   _dob = _dob.replaceAll(RegExp("/"), '-');
//   // Check if email is valid
//   // if (isValid == true) {
//   try {
//     // Create connection.
//     IOWebSocketChannel channel =
//         IOWebSocketChannel.connect('ws://10.0.2.2:3000/signup$_mail');
//     // Data that will be sended to Node.js
//     String signUpData =
//         "{'auth':'$auth','cmd':'signup','email':'$_mail','name':'$_name','dob': '$_dob','hash':'$_cpwd'}";
//     // Send data to Node.js
//     channel.sink.add(signUpData);
//     // listen for data from the server
//     return channel;
//     // return errorMessage;
//   } catch (e) {
//     print("Error on connecting to websocket: $e");
//   }
//   // }
//   // else {
//   //   print("email is false");
//   // }
// }

import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:confereus/routes/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
// final config = Configuration.flexibleSync(,[Users.schema]);
// final realm = Realm(config);

Future<IOWebSocketChannel?> signUp(BuildContext context, String _mail, String _name,
    DateTime _dob, String _cpwd) async {
  Map<String,dynamic> reqBody = {
    "name": _name,
    "email": _mail,
    "password": _cpwd,
  "dob": _dob,
  };
  var res = await http.post(Uri.parse(signup),
  headers: {
    "Content-Type": "application/json"
  },
    body: jsonEncode(reqBody),
  );
  var jsonResp = jsonDecode(res.body);
  if(jsonResp['status']){

  }else {
    print("Something Went Wrong");

  }
  // User
  // Check if email is valid.
  // bool isValid = RegExp(
  //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //     .hasMatch(_mail);
  // String auth = "8hi38h4n4jr8fj4j4nriio1903";
  // String? errorMessage;
  // // _dob = _dob.replaceAll(RegExp("/"), '-');
  // // Check if email is valid
  // // if (isValid == true) {
  // try {
  //
  //   String salt = BCrypt.gensalt();
  //   String hashedPw = BCrypt.hashpw(_cpwd, salt);
  //   final user = Users(ObjectId(), _mail, hashedPw, _name, _dob);
  //   realm.write(() => user);
  //   // Create connection.
  //   // IOWebSocketChannel channel =
  //   // IOWebSocketChannel.connect('ws://10.0.2.2:3000/signup$_mail');
  //   // // Data that will be sended to Node.js
  //   // String signUpData =
  //   //     "{'auth':'$auth','cmd':'signup','email':'$_mail','name':'$_name','dob': '$_dob','hash':'$_cpwd'}";
  //   // // Send data to Node.js
  //   // channel.sink.add(signUpData);
  //   // // listen for data from the server
  //   // return channel;
  //   // return errorMessage;
  // } catch (e) {
  //   print("Error on connecting to websocket: $e");
  // }
  // }
  // else {
  //   print("email is false");
  // }
}