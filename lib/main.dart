import 'dart:async';

import 'package:confereus/API/conference_api.dart';
import 'package:confereus/API/http_client.dart';
import 'package:confereus/API/user_api.dart';
import 'package:confereus/API/user_profile_api.dart';
import 'package:confereus/provider/login_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

import 'routes/auth/login_signup_page.dart';
import 'routes/main_page.dart';

final storage = GetStorage('user');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('user');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginStatus()),
        ChangeNotifierProvider(create: (_) => HTTPClientProvider()),
        ChangeNotifierProvider(create: (_) => UserAPI()),
        ChangeNotifierProvider(create: (_) => ConferenceAPI()),
        ChangeNotifierProvider(create: (_) => EventAPI()),
        ChangeNotifierProvider(create: (_) => UserProfileAPI()),
      ],
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timer;
  bool needsLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storage.read('provider') == 'email_login') {
      String? token = storage.read('token');
      Duration time = (token == null || !JwtDecoder.isExpired(token))
          ? const Duration()
          : JwtDecoder.getRemainingTime(token);
      Timer(
        time,
        () async {
          String? message =
              await Provider.of<UserAPI>(context, listen: false).refreshToken();
          needsLogin = message != null;
          if (token == null && (storage.read('isLoggedIn') ?? false)) {
            needsLogin = false;
          }
          setState(() {});
        },
      );
      _timer = Timer.periodic(
        const Duration(minutes: 15),
        (timer) async {
          String? message =
              await Provider.of<UserAPI>(context, listen: false).refreshToken();
          needsLogin = message != null;
          if (token == null && (storage.read('isLoggedIn') ?? false)) {
            needsLogin = false;
          }
          setState(() {});
        },
      );
    } else if (storage.read('provider') == 'linkedin_login') {
      if (storage.read('isLoggedIn')) {
        needsLogin = false;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (needsLogin) {
      Provider.of<LoginStatus>(context).clearData();
    }
    Provider.of<LoginStatus>(context).syncVariables();
    // print(storage.read('isLoggedIn'));
    // storage.read('token');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff332D72)),
        useMaterial3: true,
      ),
      home: Consumer<LoginStatus>(builder: (_, status, child) {
        // storage.erase().then((value) => status.syncVariables());
        return LogoPage(
          needsLogin: needsLogin,
        );
      }),
    );
  }
}

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
      if (storage.read('provider') == 'email_login') {
      }
      // print(storage.getValues());
      // print(storage.getKeys());
      Future.delayed(
        const Duration(seconds: 1),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => (isLoggedIn)
                ? const MainPage()
                // ? AddAboutYou()
                : const LoginSignUpPage(),
          ),
        ),
      );
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
