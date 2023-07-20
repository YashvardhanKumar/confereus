import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../API/user_profile_api.dart';
import '../input_fields/dropdown_text_field.dart';

Future editWorkExperience(BuildContext context, WorkExperience data) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // useRootNavigator: true,
    builder: (_) {
      return EditWorkExperienceDrawer(
        data: data,
      );
    },
  );
}

class EditWorkExperienceDrawer extends StatefulWidget {
  const EditWorkExperienceDrawer({
    super.key,
    required this.data,
  });

  final WorkExperience data;

  @override
  State<EditWorkExperienceDrawer> createState() =>
      _EditWorkExperienceDrawerState();
}

class _EditWorkExperienceDrawerState extends State<EditWorkExperienceDrawer> {
  late final titleCtrl = TextEditingController(text: widget.data.position);
  late final empTypeCtrl = TextEditingController(text: widget.data.jobType);
  late final compNameCtrl = TextEditingController(text: widget.data.company);
  late final workLocCtrl = TextEditingController(text: widget.data.location);
  late final startDateCtrl = TextEditingController(
      text: DateFormat('MM/yyyy').format(widget.data.start));
  late final endDateCtrl = TextEditingController(
      text: widget.data.end != null
          ? DateFormat('MM/yyyy').format(widget.data.end!)
          : null);
  bool workingHere = false;
  DateTime? start, end;
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
            child: Padding(
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    child: CustomTextFormField(
                      label: 'Title',
                      controller: titleCtrl,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Field Required";
                        }
                        return null;
                      },
                      hint: 'Eg. Product Management',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    child: CustomDropDownField(
                      label: 'Employee Type',
                      controller: empTypeCtrl,
                      hint: 'Select One',
                      listItems: const [
                        'Intern'
                            'Full-Time Job',
                        'Part-Time Job',
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    child: CustomTextFormField(
                      label: 'Company Name',
                      controller: compNameCtrl,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Field Required";
                        }
                        return null;
                      },
                      hint: 'Eg. Microsoft',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    child: CustomTextFormField(
                      label: 'Work Location (optional)',
                      controller: workLocCtrl,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Field Required";
                        }
                        return null;
                      },
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
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Field Required";
                              }
                              try {
                                start = DateFormat('MM/yyyy').parseStrict(val);
                                setState(() {});
                              } catch (e) {
                                return "Invalid Format";
                              }
                              return null;
                            },
                            hint: 'MM/YYYY',
                            suffix: GestureDetector(
                              child: const Icon(Icons.calendar_today_rounded),
                              onTap: () async {
                                start = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1800),
                                  lastDate: DateTime.now(),
                                );
                                if (start != null) {
                                  String formattedDate =
                                      DateFormat('MM/yyyy').format(start!);
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
                            validator: (workingHere)
                                ? null
                                : (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Field Required";
                                    }
                                    try {
                                      start = DateFormat('MM/yyyy')
                                          .parseStrict(val);
                                      setState(() {});
                                    } catch (e) {
                                      return "Invalid Format";
                                    }
                                    return null;
                                  },
                            hint: 'MM/YYYY',
                            suffix: GestureDetector(
                              child: const Icon(Icons.calendar_today_rounded),
                              onTap: () async {
                                end = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1800),
                                  lastDate: DateTime.now(),
                                );
                                if (end != null) {
                                  String formattedDate =
                                      DateFormat('MM/yyyy').format(end!);
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
                  const SizedBox(
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
                            await userAPI.editWorkExperience(
                              context,
                              widget.data,
                              position: titleCtrl.text,
                              company: compNameCtrl.text,
                              jobType: empTypeCtrl.text,
                              start: start,
                              end: end,
                            );
                            // await userAPI.editWorkExperience(context, widget.data,
                            //     position: titleCtrl.text,
                            //     company: compNameCtrl.text,
                            //     jobType: empTypeCtrl.text,
                            //     start: start,
                            //     end: end);
                            Navigator.pop(context);
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
            ),
          );
        },
      ),
    );
  }
}
