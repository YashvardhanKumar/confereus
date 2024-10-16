import 'dart:convert';
import 'dart:io';

import 'package:confereus/constants.dart';
import 'package:confereus/controller/http.controller.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linkedin_login/linkedin_login.dart';

class AuthController extends GetxController {
  final h = Get.find<HttpController>();


  Future<Map<String, dynamic>> login(String mail, String cpwd) async {
    Map<String, dynamic> body = {
      "email": mail,
      "password": cpwd,
    };
    final res = await h.responseData(loginRoute, body, "POST");
    var data = await h.decodeBody(res);
    print(data);
    if (data['status']) {
      //
      await h.storage.write('token', data['token']);
      await h.storage.write('userId', data['userId']);
      await h.storage.write('isLoggedIn', true);
      await h.storage.write('auth_provider', 'email_login');
      await h.updateCookie(res);
    }
    return data;
  }

  Future<Map<String, dynamic>> changePassword(String mail, String cpwd) async {
    Map<String, dynamic> reqBody = {
      "email": mail,
      "password": cpwd,
    };
    final res = await h.responseData(changePasswordRoute, reqBody, "POST");
    var data = await h.decodeBody(res);
    print(data);
    if (data['status']) {
      await h.updateCookie(res);
    }
    return data;
  }

  void logout() async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    Map<String, dynamic> reqBody = {
      "login_refresh_token": refreshToken,
    };
    await h.secstore.deleteAll();
    await h.responseData(logoutRoute, reqBody, "POST", accessToken);
  }

  Future<String?> refreshToken() async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    Map<String, dynamic> reqBody = {
      "login_refresh_token": refreshToken,
      // "login_access_token": accessToken,
    };

    final res =
        await h.responseData(refreshTokenRoute, reqBody, "PUT", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      h.updateCookie(res);
      var token = data['token'];
      if (data['success'] == null) {
        await h.storage.write('token', token);
      }
    } else {
      return data['success'];
    }
    return null;
  }

  Future<String?> signUp(Users user) async {
    Map<String, dynamic> reqBody = user.toJson();
    HttpClientResponse res = await h.responseData(signupRoute, reqBody, "POST");
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.storage.write('token', data['token']);
      await h.storage.write('userId', data['userId']);
      await h.storage.write('isLoggedIn', true);
      await h.storage.write('auth_provider', 'email_login');
      await h.updateCookie(res);
    } else {
      return data['success'];
    }
    return null;
  }

  Future<bool> sendOTPMail(String email, bool isReset) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    Map<String, dynamic> reqBody = {
      "email": email,
      if (!isReset) "login_refresh_token": refreshToken,
    };
    HttpClientResponse res = await h.responseData(
        "$sendOTPMailRoute/${isReset ? "reset" : "verify"}", reqBody, "POST");
    var data = await h.decodeBody(res);
    await h.updateCookie(res);
    return data['status'];
  }

  Future<String?> verifyOTP(String otp, bool isForgotPass) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? encryptedOTP = await h.secstore.read(key: 'encrypted_otp_token');
    await h.secstore.delete(key: 'encrypted_otp_token');
    Map<String, dynamic> reqBody = {
      "otp": otp,
      "encrypted_otp_token": encryptedOTP,
      "login_refresh_token": refreshToken,
      // "login_access_token": accessToken,
    };
    HttpClientResponse res = await h.responseData(
        "$verifyMailRoute/${isForgotPass ? "reset" : "verify"}",
        reqBody,
        "POST",accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
    } else {
      return data['success'];
    }
    return null;
  }

  Future linkedInLogin(EnrichedUser user) async {
    Map<String, dynamic> reqBody = {
      'name': user.name,
      'picture': user.picture,
      'email': user.email,
    };
    HttpClientResponse res = await h.responseData(linkedinServerLoginRoute, reqBody, "POST");
    var data = await h.decodeBody(res);
    await h.storage.write('token', data['token']);
    await h.updateCookie(res);
    await h.storage.write('token', data['token']);
    await h.storage.write('userId', data['userId']);
    await h.storage.write('isLoggedIn', true);
    await h.storage.write('auth_provider', 'linkedin_login');
    // notifyListeners();
    return data;
  }
}
