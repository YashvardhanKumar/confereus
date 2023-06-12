import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../button/text_button.dart';

class EducationTile extends StatelessWidget {
  const EducationTile({
    Key? key,
    required this.institution,
    required this.degree,
    required this.field,
    required this.location,
    required this.start,
    required this.end,
  }) : super(key: key);
  final String institution, degree, field, location;
  final DateTime start;
  final DateTime end;

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
                institution,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                degree,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                field,
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
                    '${DateFormat.yMMMM().format(start)} - ${(DateFormat.yMMM().format(end))}',
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
        // IconButton(onPressed: () {}, icon: Icon(Icons.edit_rounded), visualDensity: VisualDensity.compact,),
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