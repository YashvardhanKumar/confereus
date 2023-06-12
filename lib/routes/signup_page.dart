import 'dart:convert';

import 'package:confereus/sign_up_APIs/email_and_password/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../components/button/filled_button.dart';
import '../components/input_fields/text_form_field.dart';
import 'otp_page.dart';

class SignUpWithEmail extends StatefulWidget {
  const SignUpWithEmail({Key? key}) : super(key: key);

  @override
  State<SignUpWithEmail> createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController cnfPasswordCtrl = TextEditingController();
  DateTime? date;
  String? errorText;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Image.asset(
                'images/logowithname.png',
                height: 124,
                width: 100,
              ),
              // Text(
              //   'Create Account',
              //   style: GoogleFonts.poppins(
              //       fontSize: 28, fontWeight: FontWeight.w500),
              //   textAlign: TextAlign.center,
              // ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                label: 'Email ID',
                hint: 'abc@example.com',
                controller: emailCtrl,
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
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                label: 'Name',
                controller: nameCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is Required';
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                label: 'Date of Birth',
                hint: 'DD/MM/YYYY',
                controller: dateCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Date of Birth is Required';
                  }
                },
                suffix: GestureDetector(
                  child: const Icon(Icons.calendar_today_rounded),
                  onTap: () async {
                    date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1800),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(date!);
                      setState(() {
                        dateCtrl.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                label: 'Password',
                isPassword: true,
                controller: passwordCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is Required';
                  } else if (value.length < 8) {
                    return 'Password Too Short';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                label: 'Confirm Password',
                isPassword: true,
                controller: cnfPasswordCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your Password';
                  } else if (passwordCtrl.text != value) {
                    return 'Password doesn\'t Match';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              CustomFilledButton(
                // margin: const EdgeInsets.all(10),
                onPressed: () async {
                  errorText = null;
                  setState(() {});
                  if (_formKey.currentState!.validate()) {
                    await signUp(
                      context,
                      emailCtrl.text,
                      nameCtrl.text,
                      date!,
                      passwordCtrl.text,
                    ).then((value) {
                      print(value);
                      value?.stream.listen((event) async {
                        event = event.replaceAll(RegExp("'"), '"');
                        var signupData = json.decode(event);
                        // Check if the status is succesfull
                        if (signupData["status"] == 'success') {
                          // Close connection.
                          value.sink.close();
                          // Return user to login if succesfull
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTPPage(
                                email: emailCtrl.text,
                              ),
                            ),
                          );
                          return;
                        } else if (signupData["status"] == 'user_exists') {
                          errorText = "Email Already Exists!";
                        } else {
                          value.sink.close();
                          errorText = "Something went wrong";
                        }
                        setState(() {});
                        print(errorText);
                      });
                    });
                    // print(errorText);
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() {});
                  }
                },
                child: Text(
                  'Create Account',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
