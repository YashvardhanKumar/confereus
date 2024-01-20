import 'package:confereus/API/user_api.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'otp_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  String? errorText;
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<UserAPI>(builder: (context, userApi, child) {
        return SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomTextFormField(
                    label: "Enter mail to send OTP",
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is Required';
                      } else if (!RegExp(
                              r"^([a-zA-Z\d_.+-]+)@([a-zA-Z\d-]+\.)+[a-zA-Z]{2,}$")
                          .hasMatch(value)) {
                        return 'Not an Email Format';
                      }
                      return errorText;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomFilledButton(
                    isLoading: isLoading,
                      child: const CustomText(
                        "Send OTP",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        isLoading = true;
                        await userApi
                            .sendOTPMail(email.text,true)
                            .then((value) {
                          if (!value) {
                            errorText = "Email doesn't exist";
                          }
                          isLoading = false;
                          setState(() {});
                          // });
                        });
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OTPPage(
                              email: email.text,
                              isForgotPass: true,
                            ),
                          ),
                        );
                        setState(() {});
                      }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
