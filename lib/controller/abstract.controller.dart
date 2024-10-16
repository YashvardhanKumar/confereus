import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/abstract model/abstract.model.dart';
import 'http.controller.dart';

class AbstractController extends GetxController {
  final h = Get.find<HttpController>();
  Future<List<Abstract>?> fetchAbstract(
      String confId,
      String? eventId,
      ) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };

    HttpClientResponse res = await h.responseData(
        abstractGetRoute(userId ?? '', confId,eventId), reqBody, "GET", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      //TODO: print((data['data'] as List).map((e) => Abstract.fromJson(e)).toList());
      return (data['data'] as List).map((e) => Abstract.fromJson(e)).toList();
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Abstract?> addAbstract(
      String confId,
      Abstract abstract,
      ) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': abstract.toJson(),
    };

    HttpClientResponse res = await h.responseData(
        abstractAddRoute(userId!,confId), reqBody, "POST", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      return Abstract.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Abstract?> editAbstract(String confId, Abstract abstract, String absId,
      {String? abstract_,
        String? paperName,
        String? paperLink,
        DateTime? approved,
        bool? isApproved,
        List<String>? userId_
      }) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (abstract_ != abstract.abstract && abstract_ != null)
          'abstract': abstract_,
        if (paperLink != abstract.paperLink && paperLink != null) 'paperLink': paperLink,
        if (paperName != abstract.paperName && paperName != null)
          'paperName': paperName,
        if (approved != abstract.approved && approved != null)
          'approved': approved,
        if(isApproved != null && isApproved != abstract.isApproved)
          'isApproved': isApproved,
        if(userId_ != null && !listEquals(userId_, abstract.userId)) 'userId': userId_,
      }
    };

    HttpClientResponse res = await h.responseData(
        abstractAddRoute(userId!,confId), reqBody, "PATCH", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);

      return Abstract.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Abstract?> approveAbstract(String confId, Abstract abstract, String absId,
      {
        DateTime? approved,
        bool? isApproved,
      }) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (approved != abstract.approved && approved != null)
          'approved': approved,
        if(isApproved != null && isApproved != abstract.isApproved)
          'isApproved': isApproved,
      }
    };
    HttpClientResponse res = await h.responseData(
        abstractApproveRoute(userId!, confId,absId), reqBody, "PATCH", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      return Abstract.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<bool> deleteAbstract(String confId,String absId) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientResponse res = await h.responseData(
        abstractDeleteRoute(userId!, confId, absId), reqBody, "DELETE", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
    }
    return data['status'];
  }
}