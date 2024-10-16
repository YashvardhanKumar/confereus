import 'dart:io';

import 'package:confereus/controller/user.controller.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:get/get.dart';

import '../constants.dart';
import 'http.controller.dart';

class UserProfileController extends GetxController {
  final h = Get.find<HttpController>();
  final u = Get.find<UserController>();
  Future<void> addWorkExperience(WorkExperience workExperience) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': workExperience.toJson(),
    };

    HttpClientResponse res = await h.responseData(
        workspaceAddRoute(userId!), reqBody, "POST", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      // u.singleUser.value!.workExperience_data.add(WorkExperience.fromJson(data['data']));
    } else {
      // return data['message'];
    }
    // return null;
  }

  Future<void> editWorkExperience(
      WorkExperience old,
      {String? position,
        String? company,
        String? jobType,
        DateTime? start,
        DateTime? end,
        String? location}) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (position != old.position && position != null) 'position': position,
        if (company != old.position && company != null) 'company': company,
        if (jobType != old.jobType && jobType != null) 'jobType': jobType,
        if (old.start.compareTo(start ?? old.start) != 0)
          'start': start!.toIso8601String(),
        if ((old.end?.compareTo(end ?? old.end!) ?? 0) != 0)
          'end': end?.toIso8601String(),
        if (location != old.location && location != null) 'location': location,
      }
    };

    HttpClientResponse res = await h.responseData(
        workspaceEditRoute(userId!, old.id), reqBody, "PATCH", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);

      // u.singleUser.value!.workExperience_data.add(WorkExperience.fromJson(data['data']));
    } else {
      // return data['message'];
    }
    // return null;
  }

  Future<void> deleteWorkExperience(String wid) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };

    HttpClientResponse res = await h.responseData(
        workspaceDeleteRoute(userId!, wid), reqBody, "DELETE", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      // return data['status'];
    } else {
      // return data['message'];
    }
    // return null;
  }

  Future<void> addEducation(Education education) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': education.toJson(),
    };
    HttpClientResponse res = await h.responseData(
        educationAddRoute(userId!), reqBody, "POST", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      // return Education.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    // return null;
  }

  Future<void> editEducation(Education old,
      {String? institution,
        String? degree,
        String? field,
        DateTime? start,
        DateTime? end,
        String? location}) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (institution != old.institution && institution != null)
          'institution': institution,
        if (degree != old.degree && degree != null) 'company': degree,
        if (field != old.field && field != null) 'field': field,
        if (old.start.compareTo(start ?? old.start) != 0)
          'start': start!.toIso8601String(),
        if ((old.end?.compareTo(end ?? old.end!) ?? 0) != 0)
          'end': end!.toIso8601String(),
        if (location != old.location && location != null) 'location': location,
      }
    };

    HttpClientResponse res = await h.responseData(
        educationEditRoute(userId!, old.id), reqBody, "PATCH", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      // return Education.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    // return null;
  }

  Future<void> deleteEducation(String eid) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };

    HttpClientResponse res = await h.responseData(
        educationDeleteRoute(userId!, eid), reqBody, "DELETE", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
    }
    // return data['status'];
  }

  Future<void> addSkills(Skills skills) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': skills.toJson(),
    };

    HttpClientResponse res = await h.responseData(
        skillsAddRoute(userId!), reqBody, "POST", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      // return Skills.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    // return null;
  }

  Future<Skills?> editSkills(Skills old,
      {String? skill, String? expertise}) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (expertise != null && expertise != old.expertise)
          'expertise': expertise,
        if (skill != null && skill != old.skill) 'skill': skill,
      }
    };
    HttpClientResponse res = await h.responseData(
        skillsEditRoute(userId!, old.id), reqBody, "PATCH", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
      // return Skills.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    // return null;
  }

  Future<void> deleteSkills(String sid) async {
    String? refreshToken = await h.secstore.read(key: 'login_refresh_token');
    String? accessToken = await h.secstore.read(key: 'login_access_token');
    String? userId = h.storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };

    HttpClientResponse res = await h.responseData(
        skillsDeleteRoute(userId!, sid), reqBody, "DELETE", accessToken);
    var data = await h.decodeBody(res);
    if (data['status']) {
      await h.updateCookie(res);
    }
    // return data['status'];
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    
  }

}