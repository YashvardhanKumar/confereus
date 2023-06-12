import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../input_fields/dropdown_text_field.dart';

void editWorkExperience(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // useRootNavigator: true,
    builder: (_) {
      return EditWorkExperienceDrawer();
    },
  );
}

class EditWorkExperienceDrawer extends StatefulWidget {
  const EditWorkExperienceDrawer({
    super.key,
  });

  @override
  State<EditWorkExperienceDrawer> createState() =>
      _EditWorkExperienceDrawerState();
}

class _EditWorkExperienceDrawerState extends State<EditWorkExperienceDrawer> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController empTypeCtrl = TextEditingController();
  TextEditingController compNameCtrl = TextEditingController();
  TextEditingController workLocCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  bool workingHere = false;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add Work Experience',
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
                  label: 'Title',
                  controller: titleCtrl,
                  hint: 'Eg. Product Management',
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: CustomDropDownField(
                  label: 'Employee Type',
                  controller: empTypeCtrl,
                  hint: 'Select One',
                  listItems: [
                    'Intern'
                        'Full-Time Job',
                    'Part-Time Job',
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: CustomTextFormField(
                  label: 'Company Name',
                  controller: compNameCtrl,
                  hint: 'Eg. Microsoft',
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: CustomTextFormField(
                  label: 'Work Location (optional)',
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
                        enabled: !workingHere,
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
                  workingHere = !workingHere;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: workingHere,
                      onChanged: (val) {
                        workingHere = val!;
                        setState(() {});
                      },
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Text(
                      'Currently working here',
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
          ),
        );
      },
    );
  }
}
