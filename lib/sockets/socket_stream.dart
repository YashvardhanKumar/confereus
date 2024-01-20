import 'dart:io';

import 'package:confereus/provider/login_status_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

import '../constants.dart';

class SocketStream extends LoginStatus {
  GetStorage storage = GetStorage('user');
  final secstore = const FlutterSecureStorage();
  late Socket socket;
  SocketStream() {
    try {
      socket = io(
          url,
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .build());
      socket.connect();
      socket.onConnecting((data) {
        print('socket connecting');
      });
      socket.on("access-token", (data) async {
        print(data);
        await secstore.write(key: 'login_access_token', value: data);
        await storage.write(
            'token', await secstore.read(key: 'login_access_token'));
        syncVariables();
        notifyListeners();
      });
      socket.onDisconnect((_) {
        print('socket Disconnected');
      });
      socket.onError((data) {
        print('socket error');
      });
      if (socket.disconnected) {
        socket.connect();
      }
    } catch (e) {
      print(e);
    }
  }
  Future<String> uploadConf(File file) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    String? accessToken = await secstore.read(key: 'login_access_token');
    UploadTask uploadTask =
        _storage.ref('uploads/${DateTime.now()}.jpeg').putFile(file);
    String url = await uploadTask.whenComplete(() {}).then((value) {
      return value.ref.getDownloadURL();
    });
    return url;
  }

  void changedDocumentListener(Function(dynamic) callback, String tableName) {
    socket.on("$tableName-one", (data) {
      callback(data);
    });
  }

  void fetchAllDocuments(Function(dynamic) callback, String tableName,
      [Map<String, dynamic>? data]) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    socket.emit(tableName, [accessToken, refreshToken, data ?? {}]);
    socket.on(tableName, (data) {
      callback(data);
      notifyListeners();
    });
  }

  void fetchOneDocument(Function(dynamic) callback, String tableName,
      [Map<String, dynamic>? data]) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    socket.emit(tableName, [accessToken, refreshToken, data ?? {}]);
    socket.on("$tableName-one", (data) {
      callback(data);
      notifyListeners();
    });
  }

  void addDocument(String tableName, Map<String, dynamic>? data) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    socket.emit("$tableName-add", [accessToken, refreshToken, data ?? {}]);
  }

  void deleteDocument(String tableName, Map<String, dynamic>? data) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    socket.emit("$tableName-delete", [accessToken, refreshToken, data ?? {}]);
  }

  void editDocument(String tableName,data) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    socket.emit("$tableName-edit", [accessToken, refreshToken, data ?? {}]);
  }

  void registerConferences(String tableName, Map<String, dynamic>? data) async {
    String? refreshToken = await secstore.read(key: 'login_refresh_token');
    String? accessToken = await secstore.read(key: 'login_access_token');
    socket.emit("$tableName-register", [accessToken, refreshToken, data ?? {}]);
  }  
}
