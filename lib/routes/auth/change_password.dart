import 'package:confereus/routes/auth/login_signup_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../API/user_api.dart';
import '../../components/button/filled_button.dart';
import '../../components/input_fields/text_form_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.email});

  final String email;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController cnfPassCtrl = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                label: 'Password',
                isPassword: true,
                controller: passCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is Required';
                  } else if (value.length < 8) {
                    return 'Password Too Short';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                label: 'Confirm Password',
                isPassword: true,
                controller: cnfPassCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your Password';
                  } else if (passCtrl.text != value) {
                    return 'Password doesn\'t Match';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Consumer<UserAPI>(builder: (context, userApi, _) {
                return CustomFilledButton(
                  isLoading: isLoading,
                  // margin: const EdgeInsets.all(10),
                  onPressed: () async {
                    isLoading = true;

                    setState(() {});
                    if (_formKey.currentState!.validate()) {
                      await userApi
                          .changePassword(widget.email, passCtrl.text)
                          .then((value) {
                        isLoading = false;

                        setState(() {});
                        // });
                      });
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginSignUpPage(),
                        ),
                        (route) => false,
                      );
                      setState(() {});
                    }
                  },
                  child: Text(
                    'Change Password',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
