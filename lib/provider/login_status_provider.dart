import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LoginStatus with ChangeNotifier {
  final storage = GetStorage('user');
  String? authProvider;
  late bool isLoggedIn;
  String? token, userId;

  LoginStatus() {
    authProvider = storage.read('auth_provider');
    isLoggedIn = storage.read('isLoggedIn') ?? false;
    token = storage.read('token');
    userId = storage.read('userId');
  }

  void setAuthProvider(String? val) async {
    authProvider = val;
    await storage.write('auth_provider', val);
    notifyListeners();
  }

  void setIsLoggedIn(bool val) async {
    isLoggedIn = val;
    await storage.write('isLoggedIn', val);

    notifyListeners();
  }

  void setToken(String? val) async {
    token = val;
    await storage.write('token', val);
    notifyListeners();
  }

  void setUserId(String? val) async {
    token = val;
    await storage.write('userId', val);
    notifyListeners();
  }

  void clearData() async {
    await storage.erase();
    authProvider = null;
    token = null;
    isLoggedIn = false;
    userId = null;
    notifyListeners();
  }

  void syncVariables() {
    authProvider = storage.read('auth_provider');
    isLoggedIn = storage.read('isLoggedIn') ?? false;
    token = storage.read('token');
    userId = storage.read('userId');
    // notifyListeners();
  }
}
