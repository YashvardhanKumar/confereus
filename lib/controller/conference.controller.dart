import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

import '../constants.dart';
import '../models/conference model/conference.model.dart';
import 'http.controller.dart';

class ConferenceController extends GetxController {
  final h = Get.find<HttpController>();
  Future<Map<String, dynamic>?> fetch(String url) async {

    final client = Client();
    final response = await client.get(Uri.parse(_validateUrl(url)));

    final document = parse(response.body);

    String? description, title, image, appleIcon, favIcon;

    var elements = document.getElementsByTagName('meta');
    final linkElements = document.getElementsByTagName('link');
    for (var tmp in elements) {
      if (tmp.attributes['property'] == 'og:title') {
        //fetch seo title
        title = tmp.attributes['content'] ?? '';
      }
      //if seo title is empty then fetch normal title
      if (title == null || title.isEmpty) {
        title = document.getElementsByTagName('title')[0].text;
      }

      //fetch seo description
      if (tmp.attributes['property'] == 'og:description') {
        description = tmp.attributes['content'];
      }
      //if seo description is empty then fetch normal description.
      if (description == null || description.isEmpty) {
        //fetch base title
        if (tmp.attributes['name'] == 'description') {
          description = tmp.attributes['content'];
        }
      }

      //fetch image
      if (tmp.attributes['property'] == 'og:image') {
        image = tmp.attributes['content'];
      }
    }

    for (var tmp in linkElements) {
      if (tmp.attributes['rel'] == 'apple-touch-icon') {
        appleIcon = tmp.attributes['href'];
      }
      if (tmp.attributes['rel']?.contains('icon') == true) {
        favIcon = tmp.attributes['href'];
      }
    }

    return {
      'title': title ?? '',
      'description': description ?? '',
      'image': image ?? '',
      'appleIcon': appleIcon ?? '',
      'favIcon': favIcon ?? ''
    };
  }

  String _validateUrl(String url) {
    if (url.startsWith('http://') == true ||
        url.startsWith('https://') == true) {
      return url;
    } else {
      return 'http://$url';
    }
  }

  Future<Conference?> addConference(
    Conference conference,
  ) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': conference.toJson(),
    };

    HttpClientResponse res = await h.responseData(
        conferenceAddRoute(userId!), reqBody, "POST", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      //TODO: print(data);
      return Conference.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Conference?> editConference(String confId, Conference conference,
      {String? subject,
      String? about,
      String? eventLogo,
      String? location,
      List? reviewer,
      List? admin,
      // String? registeredID,
      String? visibility,
      // String? abstractLink,
      DateTime? startTime,
      DateTime? endTime}) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (subject != conference.subject && subject != null)
          'subject': subject,
        if (about != conference.about && about != null) 'about': about,
        if (eventLogo != conference.eventLogo && eventLogo != null)
          'eventLogo': eventLogo,
        if (location != conference.location && location != null)
          'location': location,
        if (admin != null && !listEquals(admin, conference.admin))
          'admin': admin,
        if (reviewer != null && !listEquals(reviewer, conference.reviewer))
          'reviewer': reviewer,
        // if(registeredID != null && !(conference.registered?.contains(registeredID) ?? false)) 'registered': registeredID,
        if (visibility != conference.visibility && visibility != null)
          'visibility': visibility,
        // if (abstractLink != conference.abstractLink && abstractLink != null)
        //   'abstractLink': abstractLink,
        if ((startTime ?? conference.startTime)
                .compareTo(conference.startTime) !=
            0)
          'startTime': startTime!.toIso8601String(),
        if ((startTime ?? conference.endTime).compareTo(conference.endTime) !=
            0)
          'endTime': endTime!.toIso8601String(),
      }
    };
    HttpClientResponse res = await h.responseData(
        conferenceEditRoute(userId!, confId), reqBody, "PATCH", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);

      return Conference.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<bool> deleteConference(String confId) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };

    HttpClientResponse res = await h.responseData(
        conferenceDeleteRoute(userId!, confId), reqBody, "DELETE", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
    }
    return data['status'];
  }

  Future<bool> registerConference(String confId) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientResponse res = await h.responseData(
        conferenceRegisterRoute(userId!, confId), reqBody, "POST", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
    }
    return data['status'];
  }
}
