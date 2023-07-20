import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HTTPClientProvider with ChangeNotifier {
  HttpClient client = HttpClient();
  GetStorage storage = GetStorage('user');
  final secstore = const FlutterSecureStorage();

  // UserAPI userAPI = UserAPI();
  Future updateCookie(HttpClientResponse response) async {
    for (Cookie cookie in response.cookies) {
      await secstore.write(key: cookie.name, value: cookie.value);
    }
    await storage.write(
        'token', await secstore.read(key: 'login_access_token'));
    // print(await secstore.readAll());
    // print(response.headers);
  }
}