import 'dart:convert';
import 'dart:io';

import 'package:confereus/constants.dart';
import 'package:confereus/models/abstract%20model/abstract.model.dart';
import 'package:flutter/foundation.dart';

import 'http_client.dart';

class AbstractAPI extends HTTPClientProvider {


  Future<List<Abstract>?> fetchAbstract(
      String confId,
      String? eventId,
      ) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      // 'data': conference.toJson(),
      // {
      //   'subject': subject,
      //   'about': about,
      //   'startTime': startTime,
      //   'endTime': endTime,
      // }
    };
    final encoded = utf8.encode(jsonEncode(reqBody));
    print(abstractGetRoute(userId!, confId,eventId));
    HttpClientRequest request =
    await client.getUrl(Uri.parse(abstractGetRoute(userId, confId,eventId)));
    request.headers.contentType = ContentType.json;
    request.headers.contentLength = encoded.length;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(encoded);
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await updateCookie(res);
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
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': abstract.toJson(),
      // {
      //   'subject': subject,
      //   'about': about,
      //   'startTime': startTime,
      //   'endTime': endTime,
      // }
    };
    HttpClientRequest request =
    await client.postUrl(Uri.parse(abstractAddRoute(userId!,confId)));
    request.headers.contentType = ContentType.json;
    // request.headers.add('Content-Type', 'application/x-www-form-urlencoded');
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await updateCookie(res);
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
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
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
    HttpClientRequest request =
    await client.patchUrl(Uri.parse(abstractEditRoute(userId!, confId,absId)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await updateCookie(res);

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
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (approved != abstract.approved && approved != null)
          'approved': approved,
        if(isApproved != null && isApproved != abstract.isApproved)
          'isApproved': isApproved,
      }
    };
    HttpClientRequest request =
    await client.patchUrl(Uri.parse(abstractApproveRoute(userId!, confId,absId)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await updateCookie(res);
      return Abstract.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<bool> deleteAbstract(String confId,String absId) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientRequest request = await client
        .deleteUrl(Uri.parse(abstractDeleteRoute(userId!, confId, absId)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await updateCookie(res);
    }
    return data['status'];
  }

}
