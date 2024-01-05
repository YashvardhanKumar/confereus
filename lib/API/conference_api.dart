import 'dart:convert';
import 'dart:io';

import 'package:confereus/API/http_client.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

import '../constants.dart';
import '../models/conference model/conference.model.dart';

Future<Map<String, dynamic>?> fetch(String url) async {
  // if(url == null) return null;
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
  if (url.startsWith('http://') == true || url.startsWith('https://') == true) {
    return url;
  } else {
    return 'http://$url';
  }
}

class ConferenceAPI extends HTTPClientProvider {
  Future<String> uploadConf(File file) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    String? accessToken = await secstore.read(key: 'login_access_token');
    UploadTask uploadTask = _storage.ref('uploads/${DateTime.now()}.jpeg').putFile(file);
    String url = await uploadTask.whenComplete(() {}).then((value) {
      return value.ref.getDownloadURL();
    });
    //Upload the file to firebase

    // Waits till the file is uploaded then stores the download url

    //returns the download url
    return url;
    // String fileName = file.path.split("/").last;
    // MultipartRequest request = MultipartRequest('PATCH', Uri.parse(uploadConfLogoRoute(id,confId)));
    // request.files.add(
    //     MultipartFile.fromBytes(
    //         'picture',
    //         await file.readAsBytes(),
    //         filename: fileName,
    //     )
    // );
    // request.headers.addAll({
    //   "Content-type": "multipart/form-data",
    //   "Authorization": "Bearer $accessToken"
    // });
    // var res = await request.send();
    // return res.reasonPhrase;
    // HttpClientRequest request =
    //     await client.postUrl(Uri.parse(uploadConfLogoRoute));
    // request.headers.contentType = ContentType.binary;
    // request.headers.add('Authorization', 'Bearer $accessToken');
    // request.add(encoded);
    // HttpClientResponse res = await request.close();
  }

  Future<List<Conference>?> fetchConference(
    // Conference conference,
    String visibility,
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
    HttpClientRequest request =
        await client.getUrl(Uri.parse(conferenceGetRoute(userId!, visibility)));
    request.headers.contentType = ContentType.json;
    request.headers.contentLength = encoded.length;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(encoded);

    HttpClientResponse res = await request.close();

    var data = jsonDecode(await res.transform(utf8.decoder).join());
    print(data);
    print((data['data'] as List).map((e) => Conference.fromJson(e)).toList());
    if (data['status']) {
      await updateCookie(res);
      return (data['data'] as List).map((e) => Conference.fromJson(e)).toList();
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Conference?> addConference(
    Conference conference,
  ) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': conference.toJson(),
      // {
      //   'subject': subject,
      //   'about': about,
      //   'startTime': startTime,
      //   'endTime': endTime,
      // }
    };
    HttpClientRequest request =
        await client.postUrl(Uri.parse(conferenceAddRoute(userId!)));
    request.headers.contentType = ContentType.json;
    // request.headers.add('Content-Type', 'application/x-www-form-urlencoded');
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await updateCookie(res);
      print(data);
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
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
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
        if(admin != null && !listEquals(admin, conference.admin)) 'admin': admin,
        if(reviewer != null && !listEquals(reviewer, conference.reviewer)) 'reviewer': reviewer,
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
    HttpClientRequest request =
        await client.patchUrl(Uri.parse(conferenceEditRoute(userId!, confId)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await updateCookie(res);

      return Conference.fromJson(data['data']);
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<bool> deleteConference(String confId) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientRequest request = await client
        .deleteUrl(Uri.parse(conferenceDeleteRoute(userId!, confId)));
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

  Future<bool> registerConference(String confId) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientRequest request = await client
        .postUrl(Uri.parse(conferenceRegisterRoute(userId!, confId)));
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

  Future<List<Conference>?> getRegisteredConferences(String confId) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    final encoded = utf8.encode(jsonEncode(reqBody));
    // print(encoded);
    HttpClientRequest request =
        await client.getUrl(Uri.parse(getRegisteredConferencesRoute(userId!)));
    request.headers.contentType = ContentType.json;
    request.headers.contentLength = encoded.length;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(encoded);
    HttpClientResponse res = await request.close();
    print(res);

    var data = jsonDecode(await res.transform(utf8.decoder).join());
    // print("=>$data");
    if (data['status']) {
      await updateCookie(res);
      print(data);
      return (data['data'] as List).map((e) => Conference.fromJson(e)).toList();
    }
    return null;
  }
}

class EventAPI extends HTTPClientProvider {
  Future<List<Event>?> getEvent(String confId) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      // {
      //   'subject': subject,
      //   'location': location,
      //   'presenter': presenter,
      //   'startTime': startTime,
      //   'endTime': endTime,
      // }
    };
    final encoded = utf8.encode(jsonEncode(reqBody));
    HttpClientRequest request =
        await client.getUrl(Uri.parse(eventGetRoute(userId!, confId)));
    request.headers.contentType = ContentType.json;
    request.headers.contentLength = encoded.length;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(encoded);

    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      // await storage.write('token', data['token']);
      // await storage.write('isLoggedIn', true);
      // await storage.write('auth_provider', 'email_login');
      await updateCookie(res);
      return (data['data'] as List).map((e) => Event.fromJson(e)).toList();
    } else {
      // return data['message'];
    }
    return null;
  }

  Future<Event?> addEvent(String confId, Event event) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
      'data': event.toJson(),
      // {
      //   'subject': subject,
      //   'location': location,
      //   'presenter': presenter,
      //   'startTime': startTime,
      //   'endTime': endTime,
      // }
    };
    HttpClientRequest request =
        await client.postUrl(Uri.parse(eventAddRoute(userId!, confId)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    // print(await res.transform(utf8.decoder).join());
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      // await storage.write('token', data['token']);
      // await storage.write('isLoggedIn', true);
      // await storage.write('auth_provider', 'email_login');
      await updateCookie(res);
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
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
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
    HttpClientRequest request = await client
        .patchUrl(Uri.parse(eventEditRoute(userId!, confId, event.id)));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer $accessToken');
    request.add(utf8.encode(jsonEncode(reqBody)));
    HttpClientResponse res = await request.close();
    var data = jsonDecode(await res.transform(utf8.decoder).join());
    if (data['status']) {
      await updateCookie(res);
      return Event.fromJson(data['data']);
    } else {
      return data['message'];
    }
  }

  Future<bool> deleteEvent(String confId, String eventId) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    String? userId = storage.read('userId');
    Map<String, dynamic> reqBody = {
      'login_refresh_token': refreshToken,
    };
    HttpClientRequest request = await client
        .deleteUrl(Uri.parse(eventDeleteRoute(userId!, confId, eventId)));
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
