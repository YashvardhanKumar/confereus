import 'package:confereus/components/bottom_drawers/add_education.dart';
import 'package:confereus/components/bottom_drawers/add_skills.dart';
import 'package:confereus/components/bottom_drawers/add_work_experience.dart';
import 'package:confereus/components/button/add_button.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/routes/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/tiles/education_tile.dart';
import '../components/tiles/skill_tile.dart';
import '../components/tiles/work_experience_tile.dart';

class AddAboutYou extends StatefulWidget {
  const AddAboutYou({Key? key}) : super(key: key);

  @override
  State<AddAboutYou> createState() => _AddAboutYouState();
}

class _AddAboutYouState extends State<AddAboutYou> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
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
      ),
      body: ListView(
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
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('Nothing Added',style: GoogleFonts.poppins(
                        //   color: Colors.grey,
                        //   fontSize: 14,
                        // ),),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: WorkExperienceTile(
                            position: 'Software Dev Engineer',
                            jobType: 'Full-Time Job',
                            location: 'Los Angeles',
                            company: 'Microsoft',
                            start: DateTime(2019, 8, 12),
                            end: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: WorkExperienceTile(
                            position: 'Software Dev Engineer',
                            jobType: 'Full-Time Job',
                            location: 'Los Angeles',
                            company: 'Microsoft',
                            start: DateTime(2019, 8, 12),
                            end: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: WorkExperienceTile(
                            position: 'Software Dev Engineer',
                            jobType: 'Full-Time Job',
                            location: 'Los Angeles',
                            company: 'Microsoft',
                            start: DateTime(2019, 8, 12),
                            end: null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                AddButton(
                  text: 'Add Work Experience',
                  onPressed: () => addWorkExperience(context),
                ),
                SizedBox(height: 30),
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
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Nothing Added',
                        //   style: GoogleFonts.poppins(
                        //     color: Colors.grey,
                        //     fontSize: 14,
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: EducationTile(
                            institution: 'DAV Public School',
                            degree: 'Jr Kg - 10th',
                            field: "Metric",
                            location: "Thane, Maharashtra, India",
                            start: DateTime(2005, 3),
                            end: DateTime(2018, 3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: EducationTile(
                            institution: 'New Horizon Scholars School',
                            degree: '10+2',
                            field: "Science",
                            location: "Thane, Maharashtra, India",
                            start: DateTime(2018, 6),
                            end: DateTime(2020, 3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: EducationTile(
                            institution:
                                'Atal Bihari Vajpayee Indian Institute of Information Technology and Management',
                            degree: 'IT',
                            field: "BTech + MTech",
                            location: "Gwalior, India",
                            start: DateTime(2020, 12),
                            end: DateTime(2025, 5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                AddButton(
                  text: 'Add Education',
                  onPressed: () {
                    addEducation(context);
                  },
                ),
                SizedBox(
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
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Nothing Added',
                        //   style: GoogleFonts.poppins(
                        //     color: Colors.grey,
                        //     fontSize: 14,
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SkillTile(
                              skill: 'Flutter', expertise: 'Advanced'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SkillTile(
                              skill: 'Firebase', expertise: 'Advanced'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SkillTile(
                              skill: 'Web Development',
                              expertise: 'Intermediate'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                AddButton(
                  text: 'Add Skills',
                  onPressed: () {
                    addSkills(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomFilledButton(
          onPressed: () {
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => MainPage()));
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
  }
}





