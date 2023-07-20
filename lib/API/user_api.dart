import 'dart:convert';
import 'dart:io';

import 'package:confereus/API/http_client.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';

import '../constants.dart';
import '../models/user model/user_model.dart';
class UserAPI extends HTTPClientProvider {
  Future<String?> login(BuildContext context, String mail,
      String cpwd) async {
    Map<String, dynamic> reqBody = {
      "email": mail,
      "password": cpwd,
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(loginRoute));
    request.headers.contentType = ContentType.json;
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    // print('cookies of res = ${res.cookies}');
    // print('cookies of req = ${request.cookies}');
    // await secstore.write(key: 'cookies', value: res.cookies.join('; '));

    // http.Response res = await http.post(
    //   Uri.parse(loginRoute),
    //   headers: {"Content-Type": "application/json"},
    //   body: jsonEncode(reqBody),
    // );
    // var jsonResp = jsonDecode(res.body);
    if (data['status']) {
      //
      await storage.write('token', data['token']);
      await storage.write('userId', data['userId']);
      await storage.write('isLoggedIn', true);
      await storage.write('auth_provider', 'email_login');
      // final auth = JwtDecoder.decode(token);
      await updateCookie(res);
      notifyListeners();
    } else {
      return data['success'];
    }
    return null;
  }

  void logout() async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    Map<String, dynamic> reqBody = {
      // "login_access_token": accessToken,
      "login_refresh_token": refreshToken,
    };
    await secstore.deleteAll();
    HttpClientRequest request = await client.postUrl(Uri.parse(logoutRoute));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    await request.close();
  }

  Future<String?> refreshToken() async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    Map<String, dynamic> reqBody = {
      "login_refresh_token": refreshToken,
      // "login_access_token": accessToken,
    };
    HttpClientRequest request = await client.putUrl(Uri.parse(refreshTokenRoute));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
      var token = data['token'];
      if (data['success'] == null) {
        await storage.write('token', token);
        notifyListeners();
      }
    } else {
      return data['success'];
    }
    return null;
  }
  Future<String?> signUp(BuildContext context, Users user) async {
    Map<String, dynamic> reqBody = user.toJson();
    // {
    //   "name": _name,
    //   "email": _mail,
    //   "password": _cpwd,
    //   "dob": _dob,
    // };

    HttpClientRequest request = await client.postUrl(Uri.parse(signupRoute));
    request.headers.contentType = ContentType.json;
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await storage.write('token', data['token']);
      await storage.write('userId', data['userId']);
      await storage.write('isLoggedIn', true);
      await storage.write('auth_provider', 'email_login');
      await updateCookie(res);
      notifyListeners();
    } else {
      return data['success'];
    }
    return null;
  }

  Future<bool> sendMail(String email) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    Map<String, dynamic> reqBody = {
      "email": email,
      "login_refresh_token": refreshToken,
    };
    HttpClient client = HttpClient();
    HttpClientRequest request = await client.postUrl(Uri.parse(sendMailRoute));
    request.headers.contentType = ContentType.json;
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    await updateCookie(res);
    return data['status'];
  }

  Future<String?> verifyOTP(BuildContext context, String otp) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? encryptedOTP = await secstore.read(key: 'encrypted_otp_token');
    await secstore.delete(key: 'encrypted_otp_token');
    Map<String, dynamic> reqBody = {
      "otp": otp,
      "encrypted_otp_token": encryptedOTP,
      "login_refresh_token": refreshToken,
      // "login_access_token": accessToken,
    };
    HttpClient client = HttpClient();
    HttpClientRequest request = await client.postUrl(Uri.parse(verifyMailRoute));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if(data['status']) {
    } else {
      return data['success'];
    }
    return null;
  }

  Future linkedInLogin(LinkedInUserModel user) async {
    Map<String, dynamic> reqBody = {
      'firstName': user.localizedFirstName,
      'lastName': user.localizedLastName,
      'profilePicture': user.profilePicture?.displayImage,
        // .displayImageContent?.elements?[0]
        //   .identifiers?[0].file,
      'email': user.email?.elements?[0].handleDeep?.emailAddress,
    };
    // HttpClient client = HttpClient();
    HttpClientRequest reqFinal =
    await client.postUrl(Uri.parse(linkedinServerLoginRoute));
    reqFinal.headers.contentType = ContentType.json;
    reqFinal.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse userRes = await reqFinal.close();
    // print((await userRes.transform(utf8.decoder).join()).toString());

    // await userRes.transform(utf8.decoder).join());
    var data = jsonDecode(await userRes.transform(utf8.decoder).join());
    await storage.write('token', data['token']);
    await updateCookie(userRes);
    await storage.write('token', data['token']);
    await storage.write('userId', data['userId']);
    await storage.write('isLoggedIn', true);
    await storage.write('auth_provider', 'linkedin_login');
    notifyListeners();
    return data;
  }

  Future<Users?> getCurUsers() async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    final encoded = utf8.encode(jsonEncode(reqBody));
    HttpClientRequest request = await client.getUrl(Uri.parse(fetchProfile(userId!)));
    request.headers.contentType = ContentType.json;
    request.headers.contentLength = encoded.length;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(encoded);
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await updateCookie(res);
      return Users.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<List<Users>?> getAllUsers(BuildContext context) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    final encoded = utf8.encode(jsonEncode(reqBody));
    HttpClientRequest request = await client.getUrl(Uri.parse(getAllUsersRoute));
    request.headers.contentType = ContentType.json;
    request.headers.contentLength = encoded.length;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(encoded);
    HttpClientResponse res = await request.close();
    // print(await res.transform(utf8.decoder).join());
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await updateCookie(res);
      return (data['data'] as List).map((e) => Users.fromJson(e)).toList();
    } else {
      // return data['message'];
    }
    return null;
  }
}
