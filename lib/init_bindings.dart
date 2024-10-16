import 'package:confereus/app.controller.dart';
import 'package:confereus/controller/auth.controller.dart';
import 'package:confereus/controller/http.controller.dart';
import 'package:get/get.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HttpController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => AppController());
    Get.lazyPut(() => );
  }

}