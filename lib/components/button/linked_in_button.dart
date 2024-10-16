import 'package:confereus/components/custom_text.dart';
import 'package:confereus/controller/auth.controller.dart';
import 'package:confereus/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:provider/provider.dart';

import '../../API/user_api.dart';
import '../../constants.dart';
import '../../provider/login_status_provider.dart';
import '../../routes/auth/add_dob_for_sso_login.dart';
import '../../secrets.dart';
import 'filled_button.dart';

class LinkedInButtonCustom extends StatefulWidget {
  const LinkedInButtonCustom({Key? key}) : super(key: key);

  @override
  State<LinkedInButtonCustom> createState() => _LinkedInButtonCustomState();
}

class _LinkedInButtonCustomState extends State<LinkedInButtonCustom> {
  AuthCodeObject? authorizationCode;
  UserObject? user;
  bool logoutUser = false;
  bool isLoading = false;
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return CustomFilledButton(
      color: const Color(0xff0A66C2),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (final BuildContext context) => Obx(() {
              return Scaffold(
                body: Stack(
                  children: [
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: kColorDark,
                        ),
                      ),
                    LinkedInUserWidget(
                      useVirtualDisplay: true,
                      appBar: AppBar(
                        surfaceTintColor: Colors.white,
                        backgroundColor: Colors.white,
                      ),
                      destroySession: auth.h.isLoggedIn.isFalse,
                      redirectUrl: linkedinLoginRoute,
                      clientId: LinkedinAPI.CLIENT_ID,
                      clientSecret: LinkedinAPI.CLIENT_SECRET,
                      onError: (userFailed) {
                        print(userFailed.stackTrace);
                        Get.back();
                      },
                      onGetUserProfile:
                          (final UserSucceededAction response) async {
                        print("object");
                        Get.showOverlay(
                            asyncFunction: () async {
                              await auth.linkedInLogin(response.user);
                            },
                            loadingWidget: const CircularProgressIndicator());
                        Get.offAll(Routes.addDob);
                      },
                    ),
                  ],
                ),
              );
            }),
            fullscreenDialog: true,
          ),
        );
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Image.asset(
              'images/linkedin.png',
              height: 48,
            ),
          ),
          const Center(
              child: CustomText(
            'Login With LinkedIn',
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 18,
            textAlign: TextAlign.center,
          )),
        ],
      ),
    );
  }
}

class AuthCodeObject {
  AuthCodeObject({required this.code, required this.state});

  final String? code;
  final String? state;
}

class UserObject {
  UserObject({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String profileImageUrl;
}
