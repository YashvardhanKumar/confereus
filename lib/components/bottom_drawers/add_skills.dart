import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../API/user_profile_api.dart';
import '../input_fields/dropdown_text_field.dart';

Future<Skills?> addSkills(BuildContext context) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // useRootNavigator: true,
    builder: (_) {
      return const AddSkillsDrawer();
    },
  );
}

class AddSkillsDrawer extends StatefulWidget {
  const AddSkillsDrawer({
    super.key,
  });

  @override
  State<AddSkillsDrawer> createState() => _AddSkillsDrawerState();
}

class _AddSkillsDrawerState extends State<AddSkillsDrawer> {
  TextEditingController skillCtrl = TextEditingController();
  TextEditingController expertiseCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    duration: kThemeAnimationDuration,
    child: BottomSheet(
        onClosing: () {},
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              // primary: true,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Add Skills',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: CustomTextFormField(
                    label: 'Skills',
                    controller: skillCtrl,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Field is Required';
                      }
                      return null;
                    },
                    hint: 'Eg. Machine Learning',
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: CustomDropDownField(
                    label: 'Expertise',
                    controller: expertiseCtrl,
                    hint: 'Select One',
                    listItems: const [
                      'Beginner',
                      'Intermediate',
                      'Advanced',
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Consumer<UserProfileAPI>(
                      builder: (context, userAPI, child) {
                    return CustomFilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Skills skills = Skills(
                              id: "",
                              skill: skillCtrl.text,
                              expertise: expertiseCtrl.text);

                          final data = await userAPI.addSkills(context, skills);
                          Navigator.pop(context, data);
                        }
                      },
                      child: Text(
                        'Add',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
