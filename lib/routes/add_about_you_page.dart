import 'package:confereus/API/user_api.dart';
import 'package:confereus/components/bottom_drawers/add_education.dart';
import 'package:confereus/components/bottom_drawers/add_skills.dart';
import 'package:confereus/components/bottom_drawers/add_work_experience.dart';
import 'package:confereus/components/button/add_button.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/main.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:confereus/routes/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

import '../components/bottom_drawers/edit_education.dart';
import '../components/bottom_drawers/edit_skills.dart';
import '../components/bottom_drawers/edit_work_experience.dart';
import '../components/tiles/education_tile.dart';
import '../components/tiles/skill_tile.dart';
import '../components/tiles/work_experience_tile.dart';

// Credentials credentials = Credentials.anonymous();
//
// final configRealm = Configuration.flexibleSync(credentials, schemaObjects)
// final realm = Realm(config);

class AddAboutYou extends StatefulWidget {
  const AddAboutYou({Key? key}) : super(key: key);

  // final Users user;

  @override
  State<AddAboutYou> createState() => _AddAboutYouState();
}

class _AddAboutYouState extends State<AddAboutYou> {
  // List<WorkExperience> workExperienceList = [];
  // List<Education> educationList = [];
  // List<Skills> skillsList = [];
  // late UserAPI userAPI;

  // void getUsers() {
  //   userAPI = UserAPI();
  //   userAPI.getCurUsers().then((users) {
  //     if ((users?.workExperience?.isNotEmpty ?? false) &&
  //         (users?.education?.isNotEmpty ?? false) &&
  //         (users?.skills?.isNotEmpty ?? false)) {
  //       return const MainPage();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Users?>(
        stream: Provider.of<UserAPI>(context).getCurUsers().asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // if (snapshot.hasData) {

          final users = snapshot.data!;
          if ((users.workExperience?.isNotEmpty ?? false) ||
              (users.education?.isNotEmpty ?? false) ||
              (users.skills?.isNotEmpty ?? false)) {
            return const MainPage();
          }
          // workExperienceList = users.workExperience ?? [];
          // educationList = users.education ?? [];
          // skillsList = users.skills ?? [];
          // }
          return Scaffold(
            appBar: (snapshot.hasData)
                ? AppBar(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const MainPage()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Skip for now',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kColorDark,
                          ),
                        ),
                      )
                    ],
                  )
                : null,
            body: Builder(builder: (context) {
              // if (!snapshot.hasData) {
              //   return Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }
              final users = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(10.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Work Experience',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            (users.workExperience?.isNotEmpty ?? false)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: users.workExperience!
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: WorkExperienceTile(
                                              data: e,
                                              updateState: () =>
                                                  setState(() {}),
                                              onEditClicked: () async {
                                                await editWorkExperience(
                                                  context,
                                                  e,
                                                );
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  )
                                : const CustomText(
                                    'Nothing Added',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    textAlign: TextAlign.center,
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AddButton(
                          text: 'Add Work Experience',
                          onPressed: () async {
                            await addWorkExperience(context);
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Education',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            (users.education?.isNotEmpty ?? false)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: users.education!
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: EducationTile(
                                              data: e,
                                              updateState: () =>
                                                  setState(() {}), onEditClicked: () async {
                                              await editEducation(context, e);
                                              setState(() {

                                              });
                                            },
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  )
                                : const CustomText(
                                    'Nothing Added',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    textAlign: TextAlign.center,
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AddButton(
                          text: 'Add Education',
                          onPressed: () async {
                            await addEducation(context);
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Skills',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            (users.skills?.isNotEmpty ?? false)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: users.skills!
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SkillTile(
                                              data: e,
                                              updateState: () =>
                                                  setState(() {}), onEditClicked: () async {
                                              await editSkills(context, e);
                                              setState(() {

                                              });
                                            },
                                            ),
                                          ),
                                        )
                                        .toList())
                                : const CustomText(
                                    'Nothing Added',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    textAlign: TextAlign.center,
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AddButton(
                          text: 'Add Skills',
                          onPressed: () async {
                            await addSkills(context);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomFilledButton(
                onPressed: () {
                  final data = JwtDecoder.tryDecode(storage.read('token'));
                  if (data == null) {
                    storage.write('token', null);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LogoPage(
                                needsLogin: true,
                              )),
                      (_) => false,
                    );
                  }
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const MainPage()));
                },
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
