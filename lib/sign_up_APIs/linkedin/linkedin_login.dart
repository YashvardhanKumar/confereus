import 'dart:convert';
import 'dart:io';

import 'package:linkedin_login/linkedin_login.dart';

import '../../constants.dart';

Future linkedInLogin(LinkedInUserModel user) async {
  // String oauthUrl =
  //     '${LinkedInData.oauthUrl}&client_id=${LinkedInData.clientId}'
  //     '&state=${LinkedInData.state}'
  //     '&redirect_uri=${LinkedInData.redirectUrl}'
  //     '&scope=${LinkedInData.scope}';
  //
  // print(Uri.parse(oauthUrl));
  Map<String, dynamic> reqBody = {
    'firstName': user.localizedFirstName,
    'lastName': user.localizedLastName,
    'profilePicture': user.profilePicture?.displayImageContent?.elements?[0]
        .identifiers?[0].file,
    'email': user.email?.elements?[0].handleDeep?.emailAddress,
  };
  print(reqBody);
  HttpClient client = HttpClient();
  // HttpClientRequest req = await client.getUrl(Uri.parse(oauthUrl));
  // req.headers.contentType = ContentType.json;
  // HttpClientResponse res =  await req.close();
  // final query = res.redirects.first.location.queryParameters;
  // final code = query["code"];
  HttpClientRequest reqFinal =
      await client.postUrl(Uri.parse(linkedinServerLoginRoute));
  reqFinal.headers.contentType = ContentType.json;
  reqFinal.add(utf8.encode(jsonEncode(reqBody)));
  HttpClientResponse userRes = await reqFinal.close();
  // await userRes.transform(utf8.decoder).join());
  var data = jsonDecode(await userRes.transform(utf8.decoder).join());
  return data;
  // .then((res) {
  // const user = res;
  // setState({
  // user,
  // loaded: true
  // })
  // // Do something with user
  // });
}
