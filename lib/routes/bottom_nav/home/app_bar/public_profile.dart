import 'package:confereus/API/conference_api.dart';
import 'package:confereus/API/user_profile_api.dart';
import 'package:confereus/components/add_about_you_tile.dart';
import 'package:confereus/components/bottom_drawers/add_education.dart';
import 'package:confereus/components/bottom_drawers/add_skills.dart';
import 'package:confereus/components/bottom_drawers/edit_education.dart';
import 'package:confereus/components/bottom_drawers/edit_skills.dart';
import 'package:confereus/components/bottom_drawers/edit_work_experience.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/tiles/education_tile.dart';
import 'package:confereus/components/tiles/skill_tile.dart';
import 'package:confereus/components/tiles/work_experience_tile.dart';
import 'package:confereus/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/bottom_drawers/add_work_experience.dart';
import '../../../../components/button/text_button.dart';
import '../../../../components/common_pages/see_all_page.dart';
import '../../../../components/tiles/registered_event_tiles_small.dart';
import '../../../../main.dart';
import '../../../../models/conference model/conference.model.dart';
import '../../../../models/user model/user_model.dart';

class PublicProfile extends StatefulWidget {
  const PublicProfile({Key? key, required this.userId, required this.email})
      : super(key: key);
  final String userId;
  final String email;

  @override
  State<PublicProfile> createState() => _PublicProfileState();
}

class _PublicProfileState extends State<PublicProfile> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const CustomText('Profile'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await launchUrl(Uri.parse(
              'mailto:yashram9798@gmail.com?subject=Write%20your%20subject%20here'));
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.mail,
          color: Colors.white,
        ),
      ),
      body: Consumer2<ConferenceAPI, UserProfileAPI>(
          builder: (context, confApi, userApi, _) {
        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: StreamBuilder<Users?>(
              stream: userApi.userProfile(context, widget.userId).asStream(),
              builder: (context, userSnap) {
                return StreamBuilder<List<Conference>?>(
                    stream: confApi.fetchConference('all').asStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData && !userSnap.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data == null ||
                          snapshot.data!.isEmpty ||
                          userSnap.data == null) {
                        return Container();
                      }
                      final userData = userSnap.data!;
                      final curUserJob = userData.workExperience!
                          .where((element) => element.end == null)
                          .first;
                      final registeredConf = snapshot.data!
                          .where((e) =>
                              e.registered.contains(storage.read('userId')))
                          .toList();
                      final createdConf = snapshot.data!
                          .where((e) => e.creator == storage.read('userId'))
                          .toList();
                      final isAdmin = widget.userId == storage.read('userId');
                      return ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                radius: 50,
                                child: userData.profileImageURL != null
                                    ? Image.network(userData.profileImageURL!)
                                    : const Icon(
                                        Icons.person,
                                        size: 70,
                                        color: Colors.grey,
                                      ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    CustomText(
                                      userData.name,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Material(
                                            color: kColorDark.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CustomText(
                                                    '${registeredConf.length}',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                  ),
                                                  const CustomText(
                                                    'Attended',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Material(
                                            color: kColorDark.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CustomText(
                                                    '${createdConf.length}',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                  ),
                                                  const CustomText(
                                                    'Presented',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (userData.workExperience!
                              .where((element) => element.end == null)
                              .isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  'Works at ${curUserJob.company}',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                CustomText(
                                  'Currently working as ${userData.workExperience![0].position}',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            ),
                          const SizedBox(height: 10),
                          const Divider(),

                          // const CustomText(
                          //   'About You',
                          //   fontSize: 22,
                          //   fontWeight: FontWeight.w500,
                          // ),

                          AboutTile(
                            title: 'Work Experience',
                            items: List.generate(
                              userData.workExperience!.length,
                              (i) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: WorkExperienceTile(
                                    isAdmin: isAdmin,
                                    data: userData.workExperience![i],
                                    updateState: () => setState(() {}),
                                    onEditClicked: () async {
                                      await editWorkExperience(
                                          context, userData.workExperience![i]);
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                            addFunction: () async {
                              await addWorkExperience(context);
                              setState(() {});
                            },
                            isAdmin: isAdmin,
                          ),
                          const SizedBox(height: 10),
                          AboutTile(
                            title: 'Education',
                            items: List.generate(
                              userData.education!.length,
                              (i) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: EducationTile(
                                    isAdmin: isAdmin,
                                    data: userData.education![i],
                                    updateState: () => setState(() {}),
                                    onEditClicked: () async {
                                      await editEducation(
                                          context, userData.education![i]);
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                            addFunction: () async {
                              await addEducation(context);
                              setState(() {});
                            },
                            isAdmin: isAdmin,
                          ),
                          const SizedBox(height: 10),
                          AboutTile(
                            isAdmin: isAdmin,
                            title: 'Skills',
                            items: List.generate(
                              userData.skills!.length,
                              (i) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SkillTile(
                                    isAdmin: isAdmin,
                                    data: userData.skills![i],
                                    updateState: () => setState(() {}),
                                    onEditClicked: () async {
                                      await editSkills(
                                          context, userData.skills![i]);
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                            addFunction: () async {
                              await addSkills(context);
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (createdConf.isNotEmpty)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: CustomText(
                                        'Created Conferences',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomTextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SeeAllPage(
                                              isCreated: true,
                                              stream: confApi
                                                  .fetchConference('all')
                                                  .asStream(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const CustomText(
                                        'See all',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: kColorDark,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 310,
                                  width: deviceSize.width,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    // primary: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: createdConf.length,
                                    itemBuilder: (_, i) {
                                      return RegisteredConferenceCard(
                                        data: createdConf[i],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      );
                    });
              }),
        );
      }),
    );
  }
}
