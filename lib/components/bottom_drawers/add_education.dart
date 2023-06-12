import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../input_fields/dropdown_text_field.dart';

void addEducation(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // useRootNavigator: true,
    builder: (_) {
      return AddEducation();
    },
  );
}

class AddEducation extends StatefulWidget {
  const AddEducation({
    super.key,
  });

  @override
  State<AddEducation> createState() =>
      _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  TextEditingController instituteCtrl = TextEditingController();
  TextEditingController degreeCtrl = TextEditingController();
  TextEditingController fieldCtrl = TextEditingController();
  TextEditingController workLocCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  bool studyingHere = false;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(20.0),
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Add Education',
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
                label: 'Institute/School/University name',
                controller: instituteCtrl,
                hint: 'Eg. Amity University',
              ),
            ),Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: CustomTextFormField(
                label: 'Degree',
                controller: degreeCtrl,
                hint: 'Eg. BTech',
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: CustomTextFormField(
                label: 'Field',
                controller: fieldCtrl,
                hint: 'Eg. Information Technology',
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: CustomTextFormField(
                label: 'Location (optional)',
                controller: workLocCtrl,
                hint: 'Eg. Bandra, India',
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    child: CustomTextFormField(
                      label: 'Start',
                      controller: startDateCtrl,
                      hint: 'MM/YYYY',
                      suffix: GestureDetector(
                        child: const Icon(Icons.calendar_today_rounded),
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1800),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            String formattedDate =
                                DateFormat('MM/yyyy').format(date);
                            setState(() {
                              startDateCtrl.text = formattedDate;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    child: CustomTextFormField(
                      enabled: !studyingHere,
                      label: 'End',
                      controller: endDateCtrl,
                      hint: 'MM/YYYY',
                      suffix: GestureDetector(
                        child: const Icon(Icons.calendar_today_rounded),
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1800),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            String formattedDate =
                                DateFormat('MM/yyyy').format(date);
                            setState(() {
                              endDateCtrl.text = formattedDate;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                studyingHere = !studyingHere;
                setState(() {});
              },
              child: Row(
                children: [
                  Checkbox(
                    value: studyingHere,
                    onChanged: (val) {
                      studyingHere = val!;
                      setState(() {});
                    },
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Text(
                    'Currently studying here',
                    style: GoogleFonts.poppins(),
                  )
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
