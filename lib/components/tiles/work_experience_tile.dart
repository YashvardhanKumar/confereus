import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../button/text_button.dart';

class WorkExperienceTile extends StatelessWidget {
  const WorkExperienceTile({
    super.key,
    required this.position,
    required this.jobType,
    required this.location,
    required this.start,
    required this.end,
    required this.company,
  });

  final String position, jobType, company, location;
  final DateTime start;
  final DateTime? end;

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
                position,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                company,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                jobType,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 15,
                    color: Color(0xff8B8B8B),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${DateFormat.yMMMM().format(start)} - ${(end == null ? 'Present' : DateFormat.yMMM().format(end!))}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Color(0xff8B8B8B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 15,
                    color: Color(0xff8B8B8B),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    location,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Color(0xff8B8B8B),
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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