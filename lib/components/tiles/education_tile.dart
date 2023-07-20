import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../API/user_profile_api.dart';
import '../../models/user model/user_model.dart';
import '../button/text_button.dart';

class EducationTile extends StatelessWidget {
  const EducationTile({
    Key? key,
    required this.data, required this.updateState, required this.onEditClicked,
  }) : super(key: key);
  final Education data;
  final VoidCallback updateState;
  final VoidCallback onEditClicked;

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
                data.institution,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                data.degree,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                data.field,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 15,
                    color: Color(0xff8B8B8B),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${DateFormat.yMMMM().format(data.start)} - ${(DateFormat.yMMM().format(data.end ?? data.start))}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xff8B8B8B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 15,
                    color: Color(0xff8B8B8B),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (data.location != null)
                    Text(
                      data.location!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xff8B8B8B),
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        // IconButton(onPressed: () {}, icon: Icon(Icons.edit_rounded), visualDensity: VisualDensity.compact,),
        Row(
          children: [
            CustomTextButton(
              onPressed: onEditClicked,
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.edit_rounded),
              ),
            ),
            Consumer<UserProfileAPI>(builder: (context, userAPI, child) {
              return CustomTextButton(
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.delete_forever_rounded),
                ),
                onPressed: () async {
                  await userAPI
                      .deleteEducation(context, data.id);
                  updateState();
                },
              );
            }),
          ],
        ),
      ],
    );
  }
}
