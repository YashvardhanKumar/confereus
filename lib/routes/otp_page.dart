import 'dart:async';
import 'dart:convert';

import 'package:confereus/constants.dart';
import 'package:confereus/routes/add_about_you_page.dart';
import 'package:confereus/sign_up_APIs/email_and_password/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';

import '../components/button/text_button.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  // final List<FocusNode> focusNode = [];
  final List<TextEditingController> controllers = [];
  String? errorText;
  Timer? timer;
  Timer? resendTimer;
  String? verifyOTP;
  int? tick;
  IOWebSocketChannel? _channel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOTP(context, widget.email).then((channel) {
      _channel = channel;
      setState(() {});
      timer = Timer.periodic(const Duration(minutes: 2), (timer) {
        if (timer.tick == 1) {
          // errorText = null;
          setState(() {});
          timer.cancel();
        }
      });
      resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        tick = 60 - timer.tick;
        setState(() {});
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
                      controller: controllers[index],
                      // focusNode: focusNode[index],
                      onChanged: (value) {
                        if (index == 5) {
                          FocusScope.of(context).unfocus();
                          continueFunction();
                          return;
                        }
                        print('1 : ${controllers[0].text}');
                        print('2 : ${controllers[1].text}');
                        print('3 : ${controllers[2].text}');
                        print('4 : ${controllers[3].text}');
                        print('5 : ${controllers[4].text}');
                        print('6 : ${controllers[5].text}');
                      },
                    ),
                  ),
                  // [
                  // Flexible(
                  //   child: OTPBox(
                  //     controller: controllers[0],
                  //     focusNode: focusNode[0],
                  //     onChanged: (value) {
                  //       if (value.isNotEmpty) {
                  //         c1.text = value.characters.first;
                  //         if (c2.text.isEmpty &&
                  //             c3.text.isEmpty &&
                  //             c4.text.isEmpty &&
                  //             c5.text.isEmpty &&
                  //             c6.text.isEmpty) {
                  //           errorText = null;
                  //           setState(() {});
                  //         }
                  //         if (value.length >= 2) {
                  //           c2.text = value.characters.elementAt(1);
                  //         }
                  //         focusNode2.requestFocus();
                  //       } else {
                  //         c1.text = '';
                  //         focusNode1.unfocus();
                  //       }
                  //       setState(() {});
                  //     },
                  //   ),
                  //   // child: TextFormField(
                  //   //   // controller: widget.controller,
                  //   //   cursorColor: Colors.black,
                  //   //   // obscureText: widget.isPassword && !isVisible,
                  //   //   // keyboardType: widget.keyboardType,
                  //   //   // validator: widget.validator,
                  //   //   decoration: InputDecoration(
                  //   //     isCollapsed: true,
                  //   //     contentPadding: const EdgeInsets.all(12),
                  //   //     border: OutlineInputBorder(
                  //   //       borderSide: const BorderSide(color: Colors.black),
                  //   //       borderRadius: BorderRadius.circular(5),
                  //   //     ),
                  //   //     enabledBorder: OutlineInputBorder(
                  //   //       borderSide: const BorderSide(color: Colors.black),
                  //   //       borderRadius: BorderRadius.circular(5),
                  //   //     ),
                  //   //     focusedBorder: OutlineInputBorder(
                  //   //       borderSide: const BorderSide(color: Colors.black, width: 2),
                  //   //       borderRadius: BorderRadius.circular(5),
                  //   //     ),
                  //   //   ),
                  //   // ),
                  // ),
                  //   Flexible(
                  //     child: OTPBox(
                  //       controller: c2,
                  //       focusNode: focusNode2,
                  //       onChanged: (value) {
                  //         if (value.isNotEmpty) {
                  //           c2.text = value.characters.first;
                  //           if (c1.text.isEmpty &&
                  //               c3.text.isEmpty &&
                  //               c4.text.isEmpty &&
                  //               c5.text.isEmpty &&
                  //               c6.text.isEmpty) {
                  //             errorText = null;
                  //             setState(() {});
                  //           }
                  //           if (value.length == 2) {
                  //             c3.text = value.characters.last;
                  //           }
                  //           focusNode3.requestFocus();
                  //         } else {
                  //           c2.text = '';
                  //           focusNode1.requestFocus();
                  //         }
                  //         setState(() {});
                  //       },
                  //     ),
                  //   ),
                  //   Flexible(
                  //     child: OTPBox(
                  //       controller: c3,
                  //       focusNode: focusNode3,
                  //       onChanged: (value) {
                  //         if (value.isNotEmpty) {
                  //           c3.text = value.characters.first;
                  //           if (c2.text.isEmpty &&
                  //               c1.text.isEmpty &&
                  //               c4.text.isEmpty &&
                  //               c5.text.isEmpty &&
                  //               c6.text.isEmpty) {
                  //             errorText = null;
                  //             setState(() {});
                  //           }
                  //           if (value.length == 2) {
                  //             c4.text = value.characters.last;
                  //           }
                  //           focusNode4.requestFocus();
                  //         } else {
                  //           c3.text = '';
                  //           focusNode2.requestFocus();
                  //         }
                  //         setState(() {});
                  //       },
                  //     ),
                  //   ),
                  //   Flexible(
                  //     child: OTPBox(
                  //       controller: c4,
                  //       focusNode: focusNode4,
                  //       onChanged: (value) {
                  //         if (value.isNotEmpty) {
                  //           c4.text = value.characters.first;
                  //           if (c2.text.isEmpty &&
                  //               c3.text.isEmpty &&
                  //               c1.text.isEmpty &&
                  //               c5.text.isEmpty &&
                  //               c6.text.isEmpty) {
                  //             errorText = null;
                  //             setState(() {});
                  //           }
                  //           if (value.length == 2) {
                  //             c5.text = value.characters.last;
                  //           }
                  //           focusNode5.requestFocus();
                  //         } else {
                  //           c4.text = '';
                  //           focusNode3.requestFocus();
                  //         }
                  //         setState(() {});
                  //       },
                  //     ),
                  //   ),
                  //   Flexible(
                  //     child: OTPBox(
                  //       controller: c5,
                  //       focusNode: focusNode5,
                  //       onChanged: (value) {
                  //         if (value.isNotEmpty) {
                  //           c5.text = value.characters.first;
                  //           if (c2.text.isEmpty &&
                  //               c3.text.isEmpty &&
                  //               c4.text.isEmpty &&
                  //               c1.text.isEmpty &&
                  //               c6.text.isEmpty) {
                  //             errorText = null;
                  //             setState(() {});
                  //           }
                  //           if (value.length == 2) {
                  //             c6.text = value.characters.last;
                  //             continueFunction();
                  //           }
                  //           focusNode6.requestFocus();
                  //         } else {
                  //           c5.text = '';
                  //           focusNode4.requestFocus();
                  //         }
                  //         setState(() {});
                  //       },
                  //     ),
                  //   ),
                  //   Flexible(
                  //     child: OTPBox(
                  //       controller: c6,
                  //       focusNode: focusNode6,
                  //       onChanged: (value) {
                  //         if (value.isNotEmpty) {
                  //           c6.text = value.characters.first;
                  //           setState(() {});
                  //           focusNode6.unfocus();
                  //           continueFunction();
                  //         } else {
                  //           c6.text = '';
                  //           focusNode5.requestFocus();
                  //           setState(() {});
                  //         }
                  //       },
                  //     ),
                  //   ),
                  //   ],
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
                    child: Text(
                      'Resend?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kColorDark,
                      ),
                    ),
                    onPressed: (tick == null || tick != 0)
                        ? null
                        : () async {
                            getOTP(context, widget.email).then((value) {
                              _channel = value;
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
                          }),
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

  void continueFunction() async {
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
    print(verifyOTP);
    print(otp);
    _channel?.stream.listen((event) async {
      event = event.replaceAll(RegExp("'"), '"');
      var verify = json.decode(event);
      _channel!.sink.close();
      verifyOTP = verify["otp"];
      setState(() {});
      print(verify["otp"]);
      // Check if the status is succesfull
      if (verifyOTP != null) {
        errorText = verifyEmail(context, otp, verifyOTP!);
      } else {
        errorText = 'Session Expired, resend OTP';
      }
      setState(() {});
      if (errorText == null) {
        errorText = null;
        setState(() {});
        // box.write('isLogin', true);
        // if (box.read('isAnonymous') ?? false) {
        //   box.write('isAnonymous', false);
        //   Navigator.pop(context);
        //   Navigator.pop(context);
        // }
        // else {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AddAboutYou()));
      }
    });
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
          print(controller.text);
          onChanged(value);
        },
      ),
    );
  }
}
