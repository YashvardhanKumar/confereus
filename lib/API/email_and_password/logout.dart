// import 'dart:convert';
// import 'dart:io';
//
// import 'package:confereus/constants.dart';
//
// import '../http_client.dart';
// import 'user_api.dart';
// Future<void> logout() async {
//   String? refreshToken = await secstore.read(key: 'login_refresh_token');
//   String? accessToken = await secstore.read(key: 'login_access_token');
//   Map<String, dynamic> reqBody = {
//     "login_access_token": accessToken,
//     "login_refresh_token": refreshToken,
//   };
//   await secstore.deleteAll();
//   HttpClient client = HttpClient();
//   HttpClientRequest request = await client.postUrl(Uri.parse(loginRoute));
//   request.headers.contentType = ContentType.json;
//   request.add(utf8.encode(jsonEncode(reqBody)));
//   HttpClientResponse res = await request.close();
//   var data = jsonDecode(await res.transform(utf8.decoder).join());
//   print(data);
//   // var res = await http.put(
//   //   Uri.parse(logoutRoute),
//   //   headers: {"Content-Type": "application/json"},
//   // );
//
//   // var jsonResp = jsonDecode(res.body);
//   // if (data['status']) {
//   //   // var token = jsonResp['token'];
//   //   if(data['success'] == null) {
//   //     // storage.writeIfNull('token', token);
//   //   }
//   //
//   // } else {
//   //   return jsonResp['success'];
//   // }
// }