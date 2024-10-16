import 'dart:convert';
import 'dart:io';

import 'package:confereus/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HttpController extends GetxController {
  final storage = GetStorage('user');
  final secstore = const FlutterSecureStorage();
  late Socket socket;
  final authProvider = RxnString();
  final isLoggedIn = RxBool(false);
  final token = RxnString();
  final userId = RxnString();
  HttpClient client = HttpClient();

  void setAuthProvider(String? val) async {
    authProvider.value = val;
    await storage.write('auth_provider', val);
  }

  void setIsLoggedIn(bool val) async {
    isLoggedIn.value = val;
    await storage.write('isLoggedIn', val);
  }

  void setToken(String? val) async {
    token.value = val;
    await storage.write('token', val);
  }

  void setUserId(String? val) async {
    token.value = val;
    await storage.write('userId', val);
  }

  void clearData() async {
    await storage.erase();
    authProvider.value = null;
    token.value = null;
    isLoggedIn.value = false;
    userId.value = null;
  }

  void syncVariables() {
    authProvider.value = storage.read('auth_provider');
    isLoggedIn.value = storage.read('isLoggedIn') ?? false;
    token.value = storage.read('token');
    userId.value = storage.read('userId');
  }
  Future updateCookie(HttpClientResponse response) async {
    for (Cookie cookie in response.cookies) {
      await secstore.write(key: cookie.name, value: cookie.value);
    }
    await storage.write(
        'token', await secstore.read(key: 'login_access_token'));
  }

  Future<HttpClientResponse> responseData(
      String route, Map<String, dynamic> body, String method,
      [String? accessToken]) async {
    HttpClientRequest request =
    await client.openUrl(method, Uri.parse(route));
    request.headers.contentType = ContentType.json;
    if (accessToken != null) {
      request.headers.add('Authorization', 'Bearer $accessToken');
    }
    request.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse res = await request.close();
    return res;
  }

  Future<dynamic> decodeBody(HttpClientResponse res) async =>
      jsonDecode(await res.transform(utf8.decoder).join());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    authProvider.value = storage.read('auth_provider');
    isLoggedIn.value = storage.read('isLoggedIn') ?? false;
    token.value = storage.read('token');
    userId.value = storage.read('userId');
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

        await secstore.write(key: 'login_access_token', value: data);
        await storage.write(
            'token', await secstore.read(key: 'login_access_token'));
        syncVariables();
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

}