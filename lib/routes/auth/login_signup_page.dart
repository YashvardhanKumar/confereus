import 'package:confereus/provider/login_status_provider.dart';
import 'package:confereus/routes/auth/add_dob_for_sso_login.dart';
import 'package:confereus/secrets.dart';
import 'package:confereus/sign_up_APIs/email_and_password/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:provider/provider.dart';

import '../../components/button/filled_button.dart';
import '../../components/button/outline_button.dart';
import '../../components/button/text_button.dart';
import '../../components/input_fields/text_form_field.dart';
import '../../constants.dart';
import '../../sign_up_APIs/linkedin/linkedin_login.dart';
import '../main_page.dart';
import 'signup_page.dart';

class LoginSignUpPage extends StatefulWidget {
  const LoginSignUpPage({Key? key}) : super(key: key);

  @override
  State<LoginSignUpPage> createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? errorText, errorTextEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Image.asset(
              'images/logowithname.png',
              height: 124,
              width: 100,
            ),
            const SizedBox(
              height: kToolbarHeight,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: emailCtrl,
                      label: 'Email ID',
                      hint: 'abc@example.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is Required';
                        } else if (!RegExp(
                                r"^([a-zA-Z\d_.+-]+)@([a-zA-Z\d-]+\.)+[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return 'Not an Email Format';
                        }
                        return errorTextEmail;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: passwordCtrl,
                      label: 'Password',
                      isPassword: true,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        } else {
                          return errorText;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomFilledButton(
                // margin: const EdgeInsets.all(10),
                onPressed: () async {
                  errorText = errorTextEmail = null;
                  setState(() {});

                  if (_formKey.currentState!.validate()) {
                    await login(
                      context,
                      emailCtrl.text,
                      passwordCtrl.text,
                    ).then((data) {
                      errorTextEmail = data;
                      setState(() {});
                    });
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    // });
                  }
                },
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextButton(
              child: Text(
                'Forgot Password',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kColorDark,
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'or',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: CustomOutlinedButton(
                // margin: const EdgeInsets.all(10),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SignUpWithEmail()));
                },
                child: (color) => Text(
                  'Create your Account',
                  style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                    child: CustomOutlinedButton(
                      // margin: const EdgeInsets.all(10),
                      color: const Color(0xff1877F2),
                      onPressed: () {},
                      child: (_) => Image.asset(
                        'images/facebooklogo.png',
                        height: 35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: CustomOutlinedButton(
                      // margin: const EdgeInsets.all(10),
                      color: const Color(0xff0077B7),
                      onPressed: () {},
                      child: (_) => Image.asset(
                        'images/twitterlogo.png',
                        height: 35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: LinkedInButtonCustom()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LinkedInButtonCustom extends StatefulWidget {
  const LinkedInButtonCustom({Key? key}) : super(key: key);

  @override
  State<LinkedInButtonCustom> createState() => _LinkedInButtonCustomState();
}

class _LinkedInButtonCustomState extends State<LinkedInButtonCustom> {
  AuthCodeObject? authorizationCode;
  UserObject? user;
  bool logoutUser = false;

  @override
  Widget build(BuildContext context) {
    return CustomOutlinedButton(
      // margin: const EdgeInsets.all(10),
      color: const Color(0xff0077B7),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (final BuildContext context) => Consumer<LoginStatus>(
              builder: (context,status,child) {
                return LinkedInUserWidget(
                  useVirtualDisplay: true,
                  appBar: AppBar(),
                  destroySession: !status.isLoggedIn,
                  redirectUrl: linkedinLoginRoute,
                  clientId: LinkedinAPI.CLIENT_ID,
                  clientSecret: LinkedinAPI.CLIENT_SECRET,
                  onGetUserProfile:
                      (final UserSucceededAction response) async {
                    final data = await linkedInLogin(response.user);
                    status.setIsLoggedIn(true);
                    status.setAuthProvider('linkedin_login');
                    status.setToken(null);
                    setState(() {});
                    print(status.storage.getValues());
                    print(status.storage.getKeys());
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => (data['dob'] == null)
                              ? AddDOBForSSOLogin()
                              : MainPage(email: data['email']),
                        ),
                        (route) => false);
                  },
                );
              }
            ),
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
