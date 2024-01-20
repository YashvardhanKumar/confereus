import 'dart:async';
import 'dart:io';

import 'package:confereus/constants.dart';
import 'package:confereus/provider/login_status_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HTTPClientProvider extends LoginStatus {
  HttpClient client = HttpClient();
  GetStorage storage = GetStorage('user');
  final secstore = const FlutterSecureStorage();
  late Socket socket;

  HTTPClientProvider() {
    try {
      socket = io(
          url,
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .build());
      socket.connect();
      socket.onConnecting((data) {
        print('socket connecting');
      });
      socket.on("access-token", (data) async {
        print(data);
        print(data);
        print(data);

        await secstore.write(key: 'login_access_token', value: data);
        await storage.write(
            'token', await secstore.read(key: 'login_access_token'));
        syncVariables();
        notifyListeners();
      });
      socket.onDisconnect((_) {
        print('socket Disconnected');
      });
      socket.onError((data) {
        print('socket error');
      });
      if (socket.disconnected) {
        socket.connect();
      }
    } catch (e) {
      print(e);
    }
  }
  
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
