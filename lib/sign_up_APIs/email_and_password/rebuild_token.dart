import 'dart:convert';
import 'dart:io';

import 'package:confereus/sign_up_APIs/email_and_password/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

GetStorage storage = GetStorage('user');
final secStore = FlutterSecureStorage();

Future<String?> refreshToken() async {
  String? refreshToken = await secstore.read(key: 'login_refresh_token');
  String? accessToken = await secstore.read(key: 'login_access_token');
  Map<String, dynamic> reqBody = {
    "login_refresh_token": refreshToken,
    "login_access_token": accessToken,
  };
  HttpClient client = HttpClient();
  HttpClientRequest request = await client.putUrl(Uri.parse(refreshTokenRoute));
  request.headers.contentType = ContentType.json;
  request.add(utf8.encode(jsonEncode(reqBody)));
  HttpClientResponse res = await request.close();
  var data = jsonDecode(await res.transform(utf8.decoder).join());
  print(data);
  if (data['status']) {
    updateCookie(res);
    var token = data['token'];
    if (data['success'] == null) {
      await storage.write('token', token);
    }
  } else {
    return data['success'];
  }
}
