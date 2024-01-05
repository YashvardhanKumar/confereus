import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:provider/provider.dart';

import '../../API/user_api.dart';
import '../../constants.dart';
import '../../provider/login_status_provider.dart';
import '../../routes/auth/add_dob_for_sso_login.dart';
import '../../secrets.dart';
import 'outline_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return CustomOutlinedButton(
      // margin: const EdgeInsets.all(10),
      color: const Color(0xff0077B7),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (final BuildContext context) =>
                Consumer2<LoginStatus, UserAPI>(
                    builder: (context, status, userAPI, child) {
              return Stack(
                children: [
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: kColorDark,
                      ),
                    ),
                  LinkedInUserWidget(
                    useVirtualDisplay: true,
                    appBar: AppBar(),
                    destroySession: !status.isLoggedIn,
                    redirectUrl: linkedinLoginRoute,
                    clientId: LinkedinAPI.CLIENT_ID,
                    clientSecret: LinkedinAPI.CLIENT_SECRET,
                    onError: (userFailed) {
                      print(userFailed.stackTrace);
                      Navigator.pop(context);
                    },
                    onGetUserProfile:
                        (final UserSucceededAction response) async {
                      // isLoading = true;
                      // setState(() {});
                      await userAPI.linkedInLogin(response.user);
                      Navigator.maybePop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddDOBForSSOLogin(),
                        ),
                        (route) => false,
                      );
                      //     .then(
                      //       (value) async => await userAPI.getCurUsers().then(
                      //         (value) {
                      //           isLoading = false;
                      //           setState(() {});
                      //           if (user == null) {
                      //             ScaffoldMessenger.of(context).showSnackBar(
                      //                 const SnackBar(
                      //                     content: CustomText(
                      //                         'Something Went Wrong')));
                      //           }
                      //           return Navigator.pushAndRemoveUntil(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (_) => (value!.dob ==
                      //                       null)
                      //                   ? AddDOBForSSOLogin(
                      //                       isDobPresent: value.dob != null,
                      //                     )
                      //                   : MainPage(email: value.email),
                      //             ),
                      //             (route) => false,
                      //           );
                      //         },
                      //       ),
                      //     );
                    },
                  ),
                ],
              );
            }),
            fullscreenDialog: true,
          ),
        );
      },
      child: (_) => Image.asset(
        'images/linkedinlogo.png',
        height: 28,
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
