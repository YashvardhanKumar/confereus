import 'package:confereus/API/user_api.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/button/filled_button.dart';
import '../../components/input_fields/text_form_field.dart';
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
              const SizedBox(
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
              const SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                label: 'Name',
                controller: nameCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is Required';
                  }
                  return null;
                },
              ),
              const SizedBox(
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
                  try {
                    final data = DateFormat('dd/MM/yyyy').parseStrict(value);
                    date = date?.copyWith(hour: data.hour, minute: data.minute);
                  } catch (e) {
                    return 'Invalid Format';
                  }
                  return null;
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
              const SizedBox(
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
              const SizedBox(
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
              const SizedBox(
                height: 30,
              ),
              Consumer<UserAPI>(builder: (context, userApi, _) {
                return CustomFilledButton(
                  // margin: const EdgeInsets.all(10),
                  onPressed: () async {
                    errorText = null;
                    setState(() {});
                    if (_formKey.currentState!.validate()) {
                      Users user = Users(
                          id: "",
                          email: emailCtrl.text,
                          name: nameCtrl.text,
                          dob: date!,
                          emailVerified: false,
                          provider: "email_login",
                          password: passwordCtrl.text);
                      await userApi.signUp(context, user).then((value) {
                        errorText = value;
                        setState(() {});
                        // });
                      });
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OTPPage(user: user,)));
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
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
