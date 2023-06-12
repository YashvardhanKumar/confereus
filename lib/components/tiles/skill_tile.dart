import 'package:confereus/components/button/text_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillTile extends StatelessWidget {
  const SkillTile({Key? key, required this.skill, required this.expertise})
      : super(key: key);
  final String skill, expertise;

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
                skill,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                expertise,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Color(0xff8B8B8B),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            CustomTextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.edit_rounded),
              ),
            ),
            CustomTextButton(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.delete_forever_rounded),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
