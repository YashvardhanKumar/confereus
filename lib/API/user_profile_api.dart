import 'dart:convert';
import 'dart:io';

import 'package:confereus/API/http_client.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class UserProfileAPI extends HTTPClientProvider {
  Future<Map<String, dynamic>?> userProfile(BuildContext context) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientRequest request =
        await client.getUrl(Uri.parse(fetchProfile(userId!)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
      return data['data'];
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Map<String, dynamic>?> editProfile(
    BuildContext context,
    Users user, {
    String? name,
    String? password,
    DateTime? dob,
    String? profileImageURL,
  }) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
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
    HttpClientRequest request =
        await client.getUrl(Uri.parse(fetchProfile(userId!)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
      return data['data'];
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<WorkExperience?> addWorkExperience(
      BuildContext context, WorkExperience workExperience) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': workExperience.toJson(),
      // {
      //   'position': workExperience.position,
      //   'company': workExperience.company,
      //   'jobType': workExperience.jobType,
      //   'start': workExperience.start,
      //   'end': workExperience.end,
      //   if(workExperience.location != null) 'location': workExperience.location,
      // }
    };
    HttpClientRequest request =
        await client.postUrl(Uri.parse(workspaceAddRoute(userId!)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
      return WorkExperience.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<WorkExperience?> editWorkExperience(
      BuildContext context, WorkExperience old,
      {String? position,
      String? company,
      String? jobType,
      DateTime? start,
      DateTime? end,
      String? location}) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (position != old.position && position != null) 'position': position,
        if (company != old.position && company != null) 'company': company,
        if (jobType != old.jobType && jobType != null) 'jobType': jobType,
        if (old.start.compareTo(start ?? old.start) != 0)
          'start': start!.toIso8601String(),
        if ((old.end?.compareTo(end ?? old.end!) ?? 0) != 0)
          'end': end!.toIso8601String(),
        if (location != old.location && location != null) 'location': location,
      }
    };
    HttpClientRequest request =
        await client.patchUrl(Uri.parse(workspaceEditRoute(userId!, old.id)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
      return WorkExperience.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<bool?> deleteWorkExperience(BuildContext context, String wid) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientRequest request =
        await client.deleteUrl(Uri.parse(workspaceDeleteRoute(userId!, wid)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
      return data['status'];
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Education?> addEducation(
      BuildContext context, Education education) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': education.toJson(),
      // {
      // 'institution': institution,
      // 'degree': degree,
      // 'field': field,
      // 'start': start,
      // 'end': end,
      // 'location': location,
      // }
    };
    HttpClientRequest request =
        await client.postUrl(Uri.parse(educationAddRoute(userId!)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
      return Education.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Education?> editEducation(BuildContext context, Education old,
      {String? institution,
      String? degree,
      String? field,
      DateTime? start,
      DateTime? end,
      String? location}) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
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
    HttpClientRequest request =
        await client.patchUrl(Uri.parse(educationEditRoute(userId!, old.id)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
      return Education.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<bool?> deleteEducation(BuildContext context, String eid) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientRequest request =
        await client.deleteUrl(Uri.parse(educationDeleteRoute(userId!, eid)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
    }
    return data['status'];
  }

  Future<Skills?> addSkills(BuildContext context, Skills skills) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': skills.toJson(),
      // {
      // 'skill': skill,
      // 'expertise': expertise,
      // }
    };
    HttpClientRequest request =
        await client.postUrl(Uri.parse(skillsAddRoute(userId!)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
      return Skills.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Skills?> editSkills(BuildContext context, Skills old,
      {String? skill, String? expertise}) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': {
        if (expertise != null && expertise != old.expertise)
          'expertise': expertise,
        if (skill != null && skill != old.skill) 'skill': skill,
      }
    };
    HttpClientRequest request =
        await client.patchUrl(Uri.parse(skillsEditRoute(userId!, old.id)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
      return Skills.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<bool?> deleteSkills(BuildContext context, String sid) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientRequest request =
        await client.deleteUrl(Uri.parse(skillsDeleteRoute(userId!, sid)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      updateCookie(res);
    }
    return data['status'];
  }
}
