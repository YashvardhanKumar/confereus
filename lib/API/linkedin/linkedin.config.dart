import 'package:confereus/secrets.dart';

class LinkedInData {
  static String clientId = LinkedinAPI.CLIENT_ID;
  static String redirectUrl = "http://localhost:3000/signin-linkedin";
  static String oauthUrl = 'https://www.linkedin.com/oauth/v2/authorization?response_type=code';
  static String scope = 'r_liteprofile%20r_emailaddress';
  static String state = '123456';
}

