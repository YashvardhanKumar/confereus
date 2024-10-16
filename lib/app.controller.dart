import 'dart:async';

import 'package:confereus/controller/auth.controller.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AppController extends GetxController {
  final storage = GetStorage('user');
  RxBool needsLogin = false.obs;
  RxBool isLoggedIn = false.obs;
  late Timer timer;
  final auth = Get.find<AuthController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (storage.read('provider') == 'email_login') {
      String? token = storage.read('token');
      Duration time = (token == null || !JwtDecoder.isExpired(token))
          ? const Duration()
          : JwtDecoder.getRemainingTime(token);
      Timer(
        time,
            () async {
          String? message =
          await auth.refreshToken();
          needsLogin.value = message != null;
          if (token == null && (storage.read('isLoggedIn') ?? false)) {
            needsLogin.value = false;
          }
        },
      );
      timer = Timer.periodic(
        const Duration(minutes: 15),
            (timer) async {
          String? message =
          await auth.refreshToken();
          needsLogin.value = message != null;
          if (token == null && (storage.read('isLoggedIn') ?? false)) {
            needsLogin.value = false;
          }
        },
      );
    } else if (storage.read('provider') == 'linkedin_login') {
      if (storage.read('isLoggedIn')) {
        needsLogin.value = false;
      }
    }
    isLoggedIn.value = Provider.of<LoginStatus>(context, listen: false).isLoggedIn;
  }
}