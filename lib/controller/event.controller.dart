import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/conference model/conference.model.dart';
import 'http.controller.dart';

class EventController extends GetxController {
  final h = Get.find<HttpController>();
  final events = RxList<Event>();
  void getEventLive(String confId) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    h.socket.emit('events', [
      accessToken,
      refreshToken,
      {
        "confId": confId,
      }
    ]);
    h.socket.on('events', (eventdata) {
      events.value = (eventdata as List).map((e) => Event.fromJson(e)).toList();
    });
  }

  // void getEventOneLive(String confId,
  //     String eventId) async {
  //   String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
  //   String? accessToken = await h.secstore.read(key: 'login_access_token');
  //   h.socket.emit('events', [
  //     accessToken,
  //     refreshToken,
  //     {
  //       "confId": confId,
  //       "eventId": eventId,
  //     }
  //   ]);
  //   // socket.on('connect', (data) {
  //   h.socket.on('events-one', (eventdata) {
  //     controller.sink.add(Event.fromJson(eventdata));
  //   });
  //   // });
  // }

  Future<List<Event>?> getEvent(String confId) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };

    HttpClientResponse res = await h.responseData(
        eventGetRoute(userId!, confId), reqBody, "GET", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      return (data['data'] as List).map((e) => Event.fromJson(e)).toList();
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Event?> addEvent(String confId, Event event) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': event.toJson(),
    };
    HttpClientResponse res = await h.responseData(
        eventAddRoute(userId!, confId), reqBody, "POST", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      return Event.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Event?> editEvent(
      String confId,
      Event event, {
        String? subject,
        String? location,
        String? reviewer,
        DateTime? startTime,
        DateTime? endTime,
        List<String>? presenter,
      }) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (subject != event.subject && subject != null) 'subject': subject,
        if (location != event.location && location != null)
          'location': location,
        if (reviewer != event.reviewer && reviewer != null)
          'reviewer': reviewer,
        if (listEquals(presenter, event.presenter)) 'presenter': presenter,
        if ((startTime ?? event.startTime).compareTo(event.startTime) != 0)
          'startTime': startTime!.toIso8601String(),
        if ((startTime ?? event.endTime).compareTo(event.endTime) != 0)
          'endTime': endTime!.toIso8601String(),
      }
    };

    HttpClientResponse res = await h.responseData(
        eventEditRoute(userId!, confId, event.id), reqBody, "PATCH", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      return Event.fromJson(data['data']);
    } else {
      return data['message'];
    }
  }

  Future<bool> deleteEvent(String confId, String eventId) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };

    HttpClientResponse res = await h.responseData(
        eventDeleteRoute(userId!, confId, eventId), reqBody, "DELETE", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
    }
    return data['status'];
  }
}