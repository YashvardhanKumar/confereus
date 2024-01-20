import 'dart:async';

import 'package:confereus/API/user_api.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/routes/add_about_you_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/button/text_button.dart';
import '../../provider/login_status_provider.dart';
import 'change_password.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({Key? key, required this.email, this.isForgotPass = false})
      : super(key: key);
  final String email;
  final bool isForgotPass;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  // final List<FocusNode> focusNode = [];
  final List<TextEditingController> controllers = [];
  String? errorText;
  Timer? timer;
  Timer? resendTimer;
  bool isSent = false;

  // String? verifyOTP;
  int? tick;

  // IOWebSocketChannel? _channel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      isSent = true;
      timer = Timer.periodic(const Duration(minutes: 2), (timer) {
        if (timer.tick == 1) {
          // errorText = null;
          setState(() {});
          timer.cancel();
        }
      });
      resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        tick = 60 - timer.tick;
        // setState(() {});
        if (timer.tick == 60) {
          timer.cancel();
        }
      });
    for (int i = 0; i < 6; i++) {
      // focusNode.add(FocusNode());
      controllers.add(TextEditingController());
    }
    // focusNode[0].requestFocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    resendTimer?.cancel();
    for (int i = 0; i < 6; i++) {
      // focusNode[i].dispose();
      controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if(!isSent) {
    //   Provider.of<LoginStatus>(context).clearData();
    //   return const LogoPage(needsLogin: true);
    // }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: Container(),
        leadingWidth: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Verify your OTP',
              style: GoogleFonts.poppins(
                  fontSize: 28, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: List.generate(
                  6,
                      (index) => Flexible(
                    child: OTPBox(
                      errorText: errorText,
                      controller: controllers[index],
                      // focusNode: focusNode[index],
                      onChanged: (value) {
                        if (index == 5) {
                          FocusScope.of(context).unfocus();
                          continueFunction(context);
                          return;
                        }
                      },
                        ),
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextButton(
                    onPressed: (tick == null || tick != 0)
                        ? null
                        : () async {
                            await Provider.of<UserAPI>(context)
                                .sendOTPMail(widget.email,widget.isForgotPass)
                                .then((value) {
                              // _channel = value;
                              setState(() {});
                              timer = Timer.periodic(const Duration(minutes: 2),
                                  (timer) {
                                if (timer.tick == 1) {
                                  // errorText = null;
                                  setState(() {});
                                  timer.cancel();
                                }
                              });
                              resendTimer = Timer.periodic(
                                  const Duration(seconds: 1), (timer) {
                                tick = 60 - timer.tick;
                                setState(() {});
                                if (timer.tick == 60) {
                                  timer.cancel();
                                }
                              });
                            });
                            setState(() {});
                          },
                    child: Text(
                      'Resend?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kColorDark,
                      ),
                    )),
                const SizedBox(
                  width: 5,
                ),
                if (tick != null && tick != 0)
                  Text(
                    '$tick s',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  void continueFunction(BuildContext context) async {
    String otp = '';
    for (int i = 0; i < 6; i++) {
      if (controllers[i].text.isEmpty) {
        return;
      }
      otp += controllers[i].text;
      controllers[i].clear();
    }

    errorText = await Provider.of<UserAPI>(context, listen: false)
        .verifyOTP(context, otp,widget.isForgotPass);
    setState(() {});
    if (errorText == "Login Needed") {
      Provider.of<LoginStatus>(context).clearData();
    }
    if (widget.isForgotPass) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChangePassword(email: widget.email)),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AddAboutYou()),
        (route) => false,
      );
    }
  }
// }
}

class OTPBox extends StatelessWidget {
  const OTPBox({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        cursorColor: Colors.black,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceSansPro',
        ),
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isCollapsed: true,
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: (errorText != null)
                  ? Colors.red.shade800
                  : (controller.text.isNotEmpty)
                      ? Colors.black
                      : const Color(0xffD8DADC),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: (errorText != null)
                  ? Colors.red.shade800
                  : (controller.text.isNotEmpty)
                      ? Colors.black
                      : const Color(0xffD8DADC),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: (errorText != null) ? Colors.red.shade800 : Colors.black,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        controller: controller,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }
          onChanged(value);
        },
      ),
    );
  }
}
