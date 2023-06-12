import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../input_fields/dropdown_text_field.dart';

void addSkills(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // useRootNavigator: true,
    builder: (_) {
      return AddSkillsDrawer();
    },
  );
}

class AddSkillsDrawer extends StatefulWidget {
  const AddSkillsDrawer({
    super.key,
  });

  @override
  State<AddSkillsDrawer> createState() =>
      _AddSkillsDrawerState();
}

class _AddSkillsDrawerState extends State<AddSkillsDrawer> {
  TextEditingController skillCtrl = TextEditingController();
  TextEditingController expertiseCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return ListView(
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
              padding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 10),
              child: CustomTextFormField(
                label: 'Skills',
                controller: skillCtrl,
                hint: 'Eg. Machine Learning',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 10),
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
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomFilledButton(
                onPressed: () {},
                child: Text(
                  'Add',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
