import 'package:confereus/components/bottom_drawers/edit_skills.dart';
import 'package:confereus/components/button/text_button.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../API/user_profile_api.dart';

class SkillTile extends StatelessWidget {
  const SkillTile({Key? key, required this.data, required this.updateState, required this.onEditClicked})
      : super(key: key);
  final Skills data;
  final VoidCallback updateState,onEditClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                data.skill,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                data.expertise,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff8B8B8B),
                ),
              ),
            ],
          ),
        ),
        Consumer<UserProfileAPI>(builder: (context, userAPI, child) {
          return Row(
            children: [
              CustomTextButton(
                onPressed: onEditClicked,
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.edit_rounded),
                ),
              ),
              CustomTextButton(
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.delete_forever_rounded),
                ),
                onPressed: () async {
                  await userAPI.deleteSkills(context, data.id);
                  updateState();
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}
