import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:confereus/controller/http.controller.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../constants.dart';

class SingleUserController extends GetxController {
  final h = Get.find<HttpController>();
  final user = Rxn<Users>();
  final loading = RxBool(false);

  void getUsersOneLive(String userId) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    h.socket.emit('users', [
      accessToken,
      refreshToken,
      {
        "userId": userId,
      }
    ]);
    h.socket.on('users-one', (eventdata) {
      user.value = Users.fromJson(eventdata);
    });
  }

  Future<void> userProfile([String? userId_]) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = userId_ ?? h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientResponse res = await h.responseData(
        fetchProfile(userId ?? ''), reqBody, "GET", accessToken);
    var data = await h.decodeBody(res);
    print(data);
    if (data['status']) {
      await h.updateCookie(res);
      user.value = Users.fromJson(data['data']);
    } else {
      Get.showSnackbar(GetSnackBar(
        title: 'Error',
        message: data['message'],
      ));
    }
  }

  Future<Map<String, dynamic>?> editProfile(
    Users user, {
    String? name,
    String? password,
    DateTime? dob,
    String? profileImageURL,
  }) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (name != user.name && name != null) 'name': name,
        if (password != user.password) 'password': password,
        if ((dob?.compareTo(user.dob ?? dob) != 0))
          'dob': dob?.toIso8601String(),
        'profileImageURL': profileImageURL,
      }
    };

    HttpClientResponse res = await h.responseData(
        editProfileRoute(userId!), reqBody, "PATCH", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      return data['data'];
    } else {
      Get.showSnackbar(GetSnackBar(
        title: 'Error',
        message: data['message'],
      ));
    }
    return null;
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    loading.value = true;
    userProfile().then((e) {
      loading.value = false;
    });
  }
}
