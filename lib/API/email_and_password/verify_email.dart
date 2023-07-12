// import 'dart:convert';
// import 'dart:io';
//
// import 'package:confereus/constants.dart';
// import 'package:confereus/API/email_and_password/user_api.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
//
// import '../../provider/login_status_provider.dart';
// import '../../routes/add_about_you_page.dart';
//
// // import 'package:web_socket_channel/io.dart';
// //
// // Future<IOWebSocketChannel?> getOTP(
// //   BuildContext context,
// //   String _mail,
// // ) async {
// //   String auth = "8hi38h4n4jr8fj4j4nriio1903";
// //   String? otp;
// //   try {
// //     // Create connection.
// //     IOWebSocketChannel channel =
// //         IOWebSocketChannel.connect('ws://10.0.2.2:3000/getOTP$_mail');
// //
// //     // Data that will be sended to Node.js
// //     String verifyData = "{'auth':'$auth','cmd':'get_OTP','email':'$_mail'}";
// //     // Send data to Node.js
// //     channel.sink.add(verifyData);
// //     // listen for data from the server
// //     return channel;
// //   } catch (e) {
// //     print("Error on connecting to websocket: $e");
// //   }
// // }
// //
// // String? verifyEmail(
// //     BuildContext context, String otp, String verifyOTP) {
// //   String? errorMessage;
// // print(verifyOTP);
// //   if (verifyOTP == otp) {
// //     // Close connection.
// //     // return null;
// //     // SharedPreferences prefs = await SharedPreferences.getInstance();
// //     // prefs.setBool('loggedin', true);
// //     // prefs.setString('mail', _mail);
// //     // Return user to login if succesfull
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => const MainPage()),
// //     );
// //     return null;
// //   } else {
// //     // channel.sink.close();
// //     return "Incorrect OTP";
// //   }
// // }
//
// Future<bool> sendMail(String email) async {
//   String? refreshToken = await secstore.read(key: 'login_refresh_token');
//   Map<String, dynamic> reqBody = {
//     "email": email,
//     "login_refresh_token": refreshToken,
//   };
//   HttpClient client = HttpClient();
//   HttpClientRequest request = await client.postUrl(Uri.parse(sendMailRoute));
//   request.headers.contentType = ContentType.json;
//   request.add(utf8.encode(jsonEncode(reqBody)));
//   HttpClientResponse res = await request.close();
//   var data = jsonDecode(await res.transform(utf8.decoder).join());
//   // var res = await http.post(
//   //   Uri.parse(sendMailRoute),
//   //   headers: {"Content-Type": "application/json"},
//   //   body: jsonEncode(reqBody),
//   // );
//   updateCookie(res);
//   // var jsonResp = jsonDecode(res.body);
//   return data['status'];
// }
//
// Future<String?> verifyOTP(BuildContext context, String otp) async {
//   String? refreshToken = await secstore.read(key: 'login_refresh_token');
//   String? accessToken = await secstore.read(key: 'login_access_token');
//   String? encryptedOTP = await secstore.read(key: 'encrypted_otp_token');
//   await secstore.delete(key: 'encrypted_otp_token');
//   Map<String, dynamic> reqBody = {
//     "otp": otp,
//     "encrypted_otp_token": encryptedOTP,
//     "login_refresh_token": refreshToken,
//     "login_access_token": accessToken,
//   };
//   HttpClient client = HttpClient();
//   HttpClientRequest request = await client.postUrl(Uri.parse(verifyMailRoute));
//   request.headers.contentType = ContentType.json;
//   request.add(utf8.encode(jsonEncode(reqBody)));
//   HttpClientResponse res = await request.close();
//   var data = jsonDecode(await res.transform(utf8.decoder).join());
//   // var res = await http.post(
//   //   Uri.parse(verifyMailRoute),
//   //   headers: {"Content-Type": "application/json"},
//   //   body: jsonEncode(reqBody),
//   // );
//   // var jsonRes = jsonDecode(res.body);
//   if(data['status']) {
//
//     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => AddAboutYou()), (route) => false);
//   } else {
//     return data['success'];
//   }
// }
