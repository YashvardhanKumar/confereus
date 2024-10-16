import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'provider/login_status_provider.dart';
import 'routes/auth/login_signup_page.dart';
import 'routes/main_page.dart';

final storage = GetStorage('user');

class LogoPage extends StatefulWidget {
  const LogoPage({Key? key, required this.needsLogin}) : super(key: key);
  final bool needsLogin;

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  late bool isLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isLoggedIn = !widget.needsLogin;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isLoggedIn = Provider.of<LoginStatus>(context, listen: false).isLoggedIn;
      if (storage.read('provider') == 'email_login') {}
      // print(storage.getValues());
      // print(storage.getKeys());
      // Future.delayed(
      //   const Duration(seconds: 0),
      //   () =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => (isLoggedIn)
              ? const MainPage()
          // ? AddAboutYou()
              : const LoginSignUpPage(),
        ),
      );
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomSheet: BottomSheet(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        onClosing: () {},
        builder: (BuildContext context) => Container(
          alignment: Alignment.center,
          height: 100,
          child: const Text('Made In India'),
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Center(
          child: Image.asset('images/logowithname.png'),
        ),
      ),
    );
  }
}