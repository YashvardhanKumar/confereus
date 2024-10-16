import 'package:confereus/routes/auth/add_dob_for_sso_login.dart';
import 'package:get/get.dart';

class Routes {
  // Route Names
  static const home = "/";
  static const addDob = "/add-dob-sso";

  // Get Pages
  static List<GetPage> routes = [
    // Home
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: InitBindings(),
    ),
    GetPage(
      name: home,
      page: () => AddDOBForSSOLogin(),
    )

    // Online Ordering
  ];
}
