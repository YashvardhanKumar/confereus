import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:confereus/controller/http.controller.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:get/get.dart';

import '../constants.dart';

class UserController extends GetxController {
  final h = Get.find<HttpController>();
  final singleUser = Rxn<Users>();
  final isLoading = RxBool(false);
  final users = RxList<Users>();

  Future<void> getCurUsers() async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };

    HttpClientResponse res = await h.responseData(
        fetchProfile(userId!), reqBody, "GET", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      singleUser.value = Users.fromJson(data['data']);
    } else {
      Get.showSnackbar(GetSnackBar(
        title: 'Error',
        message: data['message'],
      ));
    }
  }

  void getUsersLive(String confId) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    h.socket.emit('users', [accessToken, refreshToken, {}]);
    h.socket.on('users', (eventdata) {
      // controller.sink
      //     .add((eventdata as List).map((e) => Users.fromJson(e)).toList());
      users.value = (eventdata as List).map((e) => Users.fromJson(e)).toList();
    });
  }
  void getCurUserLive() async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    h.socket.emit('users', [
      accessToken,
      refreshToken,
      {
        "userId": userId,
      }
    ]);
    h.socket.on('users-one', (eventdata) {
      singleUser.value = Users.fromJson(eventdata);
    });
  }
  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    isLoading.value = false;
    getCurUserLive();
    await getCurUsers().then((e) {
      isLoading.value = true;
      return e;
    });
  }
}
