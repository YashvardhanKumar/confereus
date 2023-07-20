import 'dart:async';

import 'package:confereus/API/user_api.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/routes/add_about_you_page.dart';
import 'package:confereus/routes/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/button/text_button.dart';
import '../../main.dart';
import '../../models/user model/user_model.dart';
import '../../provider/login_status_provider.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({Key? key, required this.user}) : super(key: key);
  final Users user;

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
    Provider.of<UserAPI>(context, listen: false)
        .sendMail(widget.user.email)
        .then((sent) {
      isSent = sent;
      // _channel = channel;
      setState(() {});
      if (!isSent) {
        return;
      }
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
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Verify your Account',
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
                                .sendMail(widget.user.email)
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
    // if (c1.text.isNotEmpty &&
    //     c2.text.isNotEmpty &&
    //     c3.text.isNotEmpty &&
    //     c4.text.isNotEmpty &&
    //     c5.text.isNotEmpty) {
    //   String otp = c1.text + c2.text + c3.text + c4.text + c5.text + c6.text;
    // print(verifyOTP);

    // _channel?.stream.listen((event) async {
    //   event = event.replaceAll(RegExp("'"), '"');
    //   var verify = json.decode(event);
    //   _channel!.sink.close();
    //   verifyOTP = verify["otp"];
    //   setState(() {});
    //   print(verify["otp"]);
    // Check if the status is succesfull

    errorText = await Provider.of<UserAPI>(context, listen: false)
        .verifyOTP(context, otp);
    setState(() {});
    if (errorText == "Login Needed") {
      Provider.of<LoginStatus>(context).clearData();
    }
    print(storage.read('userId'));
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => AddAboutYou()), (route) => false);
    // if (errorText == null) {
    //   errorText = null;
    //   setState(() {});
    //   // box.write('isLogin', true);
    //   // if (box.read('isAnonymous') ?? false) {
    //   //   box.write('isAnonymous', false);
    //   //   Navigator.pop(context);
    //   //   Navigator.pop(context);
    //   // }
    //   // else {
    //   while (Navigator.canPop(context)) {
    //     Navigator.pop(context);
    //   }
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (_) => const AddAboutYou()));
    // }
    // });
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
