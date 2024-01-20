import 'package:flutter/painting.dart';

// const kColorDark = Color(0xff332D72);
// const kColorLight = Color(0xffE8E7F9);

// const kColorDark = Color(0xff00A9FF);
// const kColorLight = Color(0xffCDF5FD);

const kColorDark = Color(0xff4477CE);
// const kColorLight = Color(0xffFFF2F2);
const kColorLight = Color(0x224477CE);

// const url = "http://10.0.2.2:3000";
// const url = "http://192.168.65.68:3000";
// const url = "http://192.168.11.182:3000";
const url = "https://confereus.onrender.com";
const signupRoute = "$url/signup";
const loginRoute = "$url/login";
const changePasswordRoute = "$url/resetpassword";
const sendOTPMailRoute = "$url/sendotpmail";
const verifyMailRoute = "$url/verifymail";
const logoutRoute = "$url/logout";
const refreshTokenRoute = "$url/refreshtoken";
const getAllUsersRoute = "$url/getAllUsers";
String _conferenceRoute (String id) => "$url/$id/conferences";
String uploadConfLogoRoute (String id, String confId) => "${_conferenceRoute(id)}/$confId/uploadLogo";

String _eventRoute (String id, String confId) => "${_conferenceRoute(id)}/$confId";
String _profileRoute (String id) => "$url/$id/profile";
String conferenceGetRoute (String id, String? type) => '${_conferenceRoute(id)}?type=$type';
String conferenceAddRoute (String id) => '${_conferenceRoute(id)}/add';
String conferenceEditRoute (String id, String confId) => '${_conferenceRoute(id)}/edit/$confId';
String conferenceDeleteRoute (String id, String confId) => '${_conferenceRoute(id)}/delete/$confId';

String conferenceRegisterRoute (String id, String confId) => '${_conferenceRoute(id)}/$confId/register';
String getRegisteredConferencesRoute (String id) => '${_conferenceRoute(id)}/registered';

String abstractGetRoute (String id, String confId, [String? eventId]) => '${_eventRoute(id,confId)}/abstract/${eventId ?? ""}';
String abstractAddRoute (String id,String confId) => '${_eventRoute(id,confId)}/abstract/add';
String abstractEditRoute (String id, String confId,String absId) => '${_eventRoute(id,confId)}/edit/$absId';
String abstractApproveRoute (String id, String confId,String absId) => '${_eventRoute(id,confId)}/approve/$absId';
String abstractDeleteRoute (String id, String confId, String absId) => '${_eventRoute(id,confId)}/delete/$absId';


String eventGetRoute (String id, String confId) => '${_eventRoute(id,confId)}/events';
String eventAddRoute (String id, String confId) => '${_eventRoute(id,confId)}/events/add';
String eventEditRoute (String id, String confId, String eventId) => '${_eventRoute(id,confId)}/events/edit/$eventId';
String eventDeleteRoute (String id, String confId,String eventId) => '${_eventRoute(id,confId)}/events/delete/$eventId';

String fetchProfile (String id) => _profileRoute(id);
String editProfileRoute (String id) => '${_profileRoute(id)}/edit';

String workspaceAddRoute (String id) => '${_profileRoute(id)}/workspace/add';
String workspaceEditRoute (String id, String wid) => '${_profileRoute(id)}/workspace/$wid/edit';
String workspaceDeleteRoute (String id, String wid) => '${_profileRoute(id)}/workspace/$wid/delete';

String educationAddRoute (String id) => '${_profileRoute(id)}/education/add';
String educationEditRoute (String id, String eid) => '${_profileRoute(id)}/education/$eid/edit';
String educationDeleteRoute (String id, String eid) => '${_profileRoute(id)}//education/$eid/delete';

String skillsAddRoute (String id) => '${_profileRoute(id)}/skills/add';
String skillsEditRoute (String id, String sid) => '${_profileRoute(id)}/skills/$sid/edit';
String skillsDeleteRoute (String id, String sid) => '${_profileRoute(id)}/skills/$sid/delete';

String abstractUrl = 'https://docs.google.com/document/d/180xBZcDNKIOwh-KSgwXmz4vPP_Tq1Tlx/edit';
String fullPaperUrl = 'https://docs.google.com/document/d/1FitLdrnGOXM8dIicByWqkQ9ZejQCs4KA/edit';

const linkedinServerLoginRoute = "$url/applink/r/linkedinlogin";
const linkedinLoginRoute = "$url/signin-linkedin";